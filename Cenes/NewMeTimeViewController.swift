//
//  NewMeTimeViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NewMeTimeViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var meTimeItemsTableView: UITableView!
    
    @IBOutlet weak var meTimeAddView: UIView!
    
    @IBOutlet weak var transparentView: UIView!
    
    var loggedInUser: User!;
    var metimeEvents = [MetimeRecurringEvent]();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "MeTIME"
        view.backgroundColor = themeColor;
        meTimeItemsTableView.backgroundColor = themeColor;
        self.setupNavBar(); 
        
        
        view.backgroundColor = UIColor.white;
        meTimeItemsTableView.backgroundColor = themeColor;
        navigationController?.navigationBar.shouldRemoveShadow(true)
        navigationController?.navigationBar.backgroundColor = themeColor
        
        meTimeItemsTableView.register(UINib(nibName: "MeTimeDescTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MeTimeDescTableViewCell")
        meTimeItemsTableView.register(UINib(nibName: "MeTimeItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MeTimeItemTableViewCell")
        meTimeItemsTableView.register(UINib(nibName: "MeTimeUnscheduleTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MeTimeUnscheduleTableViewCell")
        
        //Variables Initialization
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        // Self-sizing magic!
        self.meTimeItemsTableView.rowHeight = UITableViewAutomaticDimension
        self.meTimeItemsTableView.estimatedRowHeight = 150; //Set this to any value that works for you.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Connectivity.isConnectedToInternet {
            self.loadMeTimeData();
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupNavBar()-> Void{
        
        let addButton = UIButton.init(type: .custom)
        addButton.setImage(UIImage(named: "plus_icon"), for: .normal)
        addButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        addButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem.init(customView: addButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func loadMeTimeData() -> Void {
        
        let queryStr = "userId=\(String(self.loggedInUser.userId))";
        
        MeTimeService().getMeTimes(queryStr: queryStr, token: self.loggedInUser.token, complete: {(response) in
            
            if (response["success"] as! Bool == true) {
                
                let meTimeArray = response["data"] as! NSArray;
                
                self.metimeEvents = MetimeRecurringEvent().loadMetimeRecurringEvents(meTimeArray: meTimeArray);
                self.meTimeItemsTableView.reloadData();
            } else {
                let alert = UIAlertController(title: "Error", message: response["message"] as! String, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        });
    }
    
    func overlayBlurredBackgroundView() {
        
        let blurredBackgroundView = UIVisualEffectView()
        
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .light)
        
        view.addSubview(blurredBackgroundView)
        
    }
    
    func removeBlurredBackgroundView() {
        
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    @objc func addButtonPressed(){
        self.definesPresentationContext = true
        //self.providesPresentationContextTransitionStyle = true
        
        //self.overlayBlurredBackgroundView();
        performSegue(withIdentifier: "showAddMetimeModal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddMetimeModal"{
            let destinationVC = segue.destination;
            destinationVC.modalPresentationStyle = .fullScreen
        }
    }
}
