//
//  RemindersViewController.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/27/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RemindersViewController: BaseViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var remindersTableView: UITableView!
 
    var openReminders: [ReminderModel] = []
    var closedReminders: [ReminderModel] = []
    
    var selectedIndex = -1
    
    @objc func closeReminderFromDetailCell(_sender: Any) {
        let reminderButton = _sender as! UIButton
        guard let cell = reminderButton.superview?.superview as? ReminderDetailTableViewCell else {
            return // or fatalError() or whatever
        }
        
        guard let indexpath = remindersTableView.indexPath(for: cell) else {
            return
        }
        
        guard indexpath.section == 0 else {
            return
        }
        
        updateReminderToClosedState(indexpath: indexpath)
    }
    
    @IBAction func closeReminder(_ sender: Any) {
        
        let reminderButton = sender as! UIButton
        guard let cell = reminderButton.superview?.superview as? RemindersTableViewCell else {
            return // or fatalError() or whatever
        }
        
        guard let indexpath = remindersTableView.indexPath(for: cell) else {
            return
        }
        
        guard indexpath.section == 0 else {
            return
        }
        
        updateReminderToClosedState(indexpath: indexpath)

    }
    
    @objc func showReminderDetail(sender: UIButton) {
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    func updateReminderToClosedState(indexpath: IndexPath) {
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        let reminder = openReminders[indexpath.row]
        
        WebService().deleteReminder(reminderId: String(describing: reminder.reminderID as NSNumber)) { (returnedDict) in
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
                self.stopAnimating()
                
                self.remindersTableView.reloadData()
            }
        }
    }
    
    func getDateFromTimestamp(timeStamp:NSNumber) -> String{
        let timeinterval : TimeInterval = timeStamp.doubleValue / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        //.dateFormat = "h:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.string(from: dateFromServer as Date).capitalized
        
        let dateobj = dateFormatter.date(from: date)
        
        
        dateFormatter.dateFormat = "dd MMM, hh:mm"
//        dateFormatter.timeStyle = .short
        date = dateFormatter.string(from: dateFromServer as Date).capitalized
        if NSCalendar.current.isDateInToday(dateobj!) == true {
            date = "TODAY \(date)"
        }else if NSCalendar.current.isDateInTomorrow(dateobj!) == true{
            date = "TOMORROW \(date)"
        }
        return date
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        remindersTableView.backgroundColor = UIColor.white

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        openReminders.removeAll()
        closedReminders.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let webservice = WebService()
            self.startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
            
            webservice.getReminders { (returnedDict) in
                self.stopAnimating()
                print(returnedDict)
                if returnedDict["Error"] as? Bool == true {
                 self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                }
                else {
                    self.parseReminders(reminders: returnedDict["data"] as! Array)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            let selectedReminder = openReminders[selectedIndex]
            let reminderDetail = segue.destination as? AddOrEditReminderViewController
            reminderDetail?.isEdit = true
            reminderDetail?.selectedReminder = selectedReminder
        }
    }
    
    func parseReminders(reminders: [[String: Any]]) {
        for reminder in reminders {
            let reminderModel = ReminderModel()
            
            if let reminderID = reminder["reminderId"] as? NSNumber {
                reminderModel.reminderID = reminderID
            }
            
            if let category = reminder["category"] as? String {
                reminderModel.category = category
            }
            
            if let title = reminder["title"] as? String {
                reminderModel.title = title
            }
            
            if let createdById =  reminder["createdById"] as? NSNumber {
                reminderModel.createdByID = createdById
            }
            
            if let location = reminder["location"] as? String {
                reminderModel.location = location
            }
            
            if let status =  reminder["status"] as? String {
                reminderModel.status = status
            }
            
            if let reminderTime = reminder["reminderTime"] as? NSNumber {
                reminderModel.reminderTime = reminderTime
            }
            
            if reminderModel.status == "Start" {
                openReminders.append(reminderModel)
            }
            else {
                closedReminders.append(reminderModel)
            }
        }
        remindersTableView.reloadData()
    }
    
    func sectionHeaderView(withLabel: String) -> UIView {
        let headerView = UIView.init(frame: CGRect.zero)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor.clear
        
        let imageView = UIImageView.init(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "reminder basket")
        imageView.tag = 1
        headerView.addSubview(imageView)
        
        let label = UILabel.init(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = withLabel
        label.tag = 2
        label.font = UIFont.init(name: "Lato-Bold", size: 24)
        label.textColor = UIColor.darkGray
        headerView.addSubview(label)
        
        let viewsDict: [String: Any] = ["Header": headerView, "Image": imageView, "Label": label]
        
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[Image]-20-[Label]-10@200-|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        
        headerView.addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint.init(item: label, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint.init(item: headerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width))
        
        headerView.addConstraint(NSLayoutConstraint.init(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 75))
        
        return headerView
    }
}


extension RemindersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        if section == 0 {
            headerView.addSubview(sectionHeaderView(withLabel: "Reminders"))
        }
        else {
            headerView.addSubview(sectionHeaderView(withLabel: "Completed"))
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        view.backgroundColor = UIColor.white
        return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if openReminders.count == 0 {
                return 1
            }
            return openReminders.count
        case 1:
            if closedReminders.count == 0 {
                return 1
            }
            return closedReminders.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminderCell = tableView.dequeueReusableCell(withIdentifier: "Reminder") as? RemindersTableViewCell
        reminderCell?.selectionStyle = .none
        
        if indexPath.section == 0 {
            if openReminders.count == 0 {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as? RemindersEmptyTableViewCell
                let emptyquote = "The way to get started is to quit  talking and begin doing."
                emptyCell?.emptyLabel.text = emptyquote + "- WALT DISNEY"
                return emptyCell!
            }
            if selectedIndex == indexPath.row {
                let detailCell = tableView.dequeueReusableCell(withIdentifier: "ReminderDetail") as? ReminderDetailTableViewCell
                let reminder = openReminders[indexPath.row]
                detailCell?.reminderTitleLabel.text = reminder.title
                detailCell?.reminderLocationLabel.text = reminder.location
                detailCell?.reminderDateLabel.text = getDateFromTimestamp(timeStamp: reminder.reminderTime as NSNumber)
                detailCell?.selectionStyle = .none
                
                detailCell?.reminderStatusButton.addTarget(self, action: #selector(closeReminderFromDetailCell(_sender:)), for: .touchUpInside)
                detailCell?.reminderEditButton.addTarget(self, action: #selector(showReminderDetail(sender:)), for: .touchUpInside)
                
                
                return detailCell!
            }
            
            let reminder = openReminders[indexPath.row]
            reminderCell?.reminderButton.setImage(#imageLiteral(resourceName: "ReminderPending"), for: .normal)
            reminderCell?.selectionStyle = .none
            reminderCell?.reminderLabel.text = reminder.title
        }
        else if indexPath.section == 1 {
            
            if closedReminders.count == 0 {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? RemindersEmptyTableViewCell
                emptyCell?.emptyLabel.text = "You have not completed any reminders!"
                return emptyCell!
            }

            let reminder = closedReminders[indexPath.row]
            let attributedString: NSMutableAttributedString =  NSMutableAttributedString(string: reminder.title)
            attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: reminder.title.characters.count))

            
            reminderCell?.reminderButton.setImage(#imageLiteral(resourceName: "RemindersCompleted"), for: .normal)
            reminderCell?.reminderLabel.attributedText = attributedString
        }
        
        return reminderCell!
    }
}


extension RemindersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if selectedIndex == indexPath.row {
                selectedIndex = -1
            }
            else {
                selectedIndex = indexPath.row
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if openReminders.count == 0 {
                return 100
            }
            if selectedIndex == indexPath.row {
                return 110
            }
            return 50
        case 1:
            if closedReminders.count == 0 {
                return 100
            }
            return 50
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}
