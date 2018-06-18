//
//  AlarmViewController.swift
//  Cenes
//
//  Created by Redblink on 07/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import GoogleSignIn
import CoreData

class AlarmViewController: UIViewController {

    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var noAlarmsLabel: UILabel!
    
    var isEditMode = false
    
    private let persistentContainer = NSPersistentContainer(name: "Cenes")
    
    func showOrHideNoAlarmsLabel() {
        var hasAlarms = false

        if let alarms = fetchedResultsController.fetchedObjects {
            hasAlarms = alarms.count > 0
        }
        
        alarmTableView.isHidden = !hasAlarms
        noAlarmsLabel.isHidden = hasAlarms
    }
    
    @IBAction func addNewAlarm(_ sender: Any) {
        self.performSegue(withIdentifier: "addOrEditAlarm", sender: nil)
    }
    
    func reloadAlarmsTable() {
        self.alarmTableView.reloadData()
    }
    
    @objc func showTableViewIsEditing() {
        if self.navigationItem.leftBarButtonItem?.title == "Edit" {
            alarmTableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
        else {
            alarmTableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }
    

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Alarm> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "alarmTime", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        alarmTableView.allowsSelectionDuringEditing = true
        
        let editButton = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(showTableViewIsEditing))
        self.navigationItem.leftBarButtonItem = editButton
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showOrHideNoAlarmsLabel()
    }

    @objc func enableOrDisableAlarm(sender: UISwitch) {
        guard let cell = sender.superview?.superview as? AlarmTableViewCell else {
            return // or fatalError() or whatever
        }
        
        let indexpath = alarmTableView.indexPath(for: cell)
        let selectedAlarm = self.fetchedResultsController.fetchedObjects![(indexpath?.row)!]
        selectedAlarm.enabled = sender.isOn
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "addOrEditAlarm" {
            let addAlarmVCNavigation = segue.destination as? UINavigationController
            let addAlarmVC = addAlarmVCNavigation?.topViewController as? AddAlarmViewController
            addAlarmVC?.managedObjectContext = persistentContainer.viewContext
            addAlarmVC?.isEditMode = false
            addAlarmVC?.autoIncrementID = (self.fetchedResultsController.fetchedObjects?.count)! + 1
            addAlarmVC?.alarmVCtitle = "Add Alarm"
        }
        if segue.identifier == "editAlarm" {
            let alarmVC = segue.destination as? AddAlarmViewController
            let indexpath = alarmTableView.indexPathForSelectedRow
            let selectedAlarm = self.fetchedResultsController.fetchedObjects![(indexpath?.row)!]
            alarmVC?.isEditMode = true
            alarmVC?.alarmVCtitle = "Edit Alarm"
            alarmVC?.selectedAlarm = selectedAlarm
            alarmVC?.managedObjectContext = persistentContainer.viewContext
        }
    }
    
    
    @IBAction func LogoutButtonPressed(_ sender: Any) {
        
        let tokenPush = UserDefaults.standard.object(forKey: "tokenData") as! String
        imageFacebookURL = nil
        GIDSignIn.sharedInstance().signOut()
        print("Logut from App")
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(tokenPush , forKey: "tokenData")
        userDefaults.synchronize()
        
        UIApplication.shared.keyWindow?.rootViewController = LoginViewController.MainViewController()
    }
}


extension AlarmViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let quotes = fetchedResultsController.fetchedObjects else {
            return 0
        }
        return quotes.count
    }
    
    func configureCell(cell: AlarmTableViewCell, atIndexpath indexPath: IndexPath) {
        let alarmRecord = fetchedResultsController.object(at: indexPath)
  
        if let alarmTime = alarmRecord.value(forKey: "alarmTime") as? Date {
            let alarm = Util.getAlarmStringFrom(date: alarmTime)
            cell.dateLabel.text = alarm
        }
        
        // Update Cell
        if let name = alarmRecord.value(forKey: "alarmName") as? String {
            cell.alarmNameLabel.text = name
        }
        
        if let weekDaysName = alarmRecord.value(forKey: "weekdaysName") as? String {
            cell.repeatedDaysLabel.text = weekDaysName
        }
        
        if let enabled = alarmRecord.value(forKey: "enabled") as? Bool {
            cell.alarmEnabledSwitch.isOn = enabled
            
            if enabled == true {
                cell.dateLabel.font = UIFont.init(name: "Lato-Regular", size: 38)
            }
            else {
                cell.dateLabel.font = UIFont.init(name: "Lato-Light", size: 38)
            }
        }
        cell.alarmEnabledSwitch.addTarget(self, action: #selector(enableOrDisableAlarm(sender:)), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Alarm", for: indexPath) as? AlarmTableViewCell
        cell?.selectionStyle = .none
        
        configureCell(cell: cell!, atIndexpath: indexPath)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.size.width, height: 1))
        view.backgroundColor = UIColor.clear
        return view
    }
}

extension AlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    // Override to support editing the table view.
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let alarm = self.fetchedResultsController.fetchedObjects![indexPath.row]
                persistentContainer.viewContext.delete(alarm)

                // Save Changes
                try persistentContainer.viewContext.save()
            } catch {
                // Error Handling
                // ...
                print("Error deleting the object")
            }
        }
    }
}

extension AlarmViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        alarmTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexpath = newIndexPath {
                alarmTableView.insertRows(at: [indexpath], with: .fade)
            }
            break
        
        case .delete:
            if let indexpath = indexPath {
                alarmTableView.deleteRows(at: [indexpath], with: .fade)
            }
            break
        case .update:
            if let indexpath = indexPath {
                let cell = alarmTableView.cellForRow(at: indexpath) as! AlarmTableViewCell
                configureCell(cell: cell, atIndexpath: indexpath)
            }
            break
        case .move:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        alarmTableView.endUpdates()
    }

}



