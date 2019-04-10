//
//  NewMeTimeViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import VisualEffectView

class NewMeTimeViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var meTimeItemsTableView: UITableView!
    
    @IBOutlet weak var addNewMeTimeBtn: UIImageView!
    
    var loggedInUser: User!;
    var metimeEvents = [MetimeRecurringEvent]();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "MeTIME"
        view.backgroundColor = themeColor;
        meTimeItemsTableView.backgroundColor = themeColor;
        self.setupNavBar(); 
        
        meTimeItemsTableView.register(UINib(nibName: "MeTimeDescTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MeTimeDescTableViewCell")
        meTimeItemsTableView.register(UINib(nibName: "MeTimeItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MeTimeItemTableViewCell")
        meTimeItemsTableView.register(UINib(nibName: "MeTimeUnscheduleTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MeTimeUnscheduleTableViewCell")
        meTimeItemsTableView.register(UINib(nibName: "MeTimeTwoLineTitleTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MeTimeTwoLineTitleTableViewCell")
        meTimeItemsTableView.register(UINib(nibName: "MeTimeThreeLineTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MeTimeThreeLineTableViewCell")
        
        //Variables Initialization
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       
    }

    override func viewDidAppear(_ animated: Bool) {
        if Connectivity.isConnectedToInternet {
            self.meTimeItemsTableView.scrollsToTop = true;
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addButtonPressed))
        self.addNewMeTimeBtn.addGestureRecognizer(tap)
        
        //self.navigationController?.navigationBar.backgroundColor = themeColor;
        //self.navigationController?.navigationBar.isHidden = true;
        
        /*let addButton = UIButton.init(type: .custom)
        addButton.setImage(UIImage(named: "plus_icon"), for: .normal)
        addButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        addButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem.init(customView: addButton)
        self.navigationItem.rightBarButtonItem = rightBarButton*/
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
    
    
    func removeBlurredBackgroundView() {
        
        for subview in view.subviews {
            if subview.isKind(of: VisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func addBlurBackgroundView() -> Void {
        let bcColor = UIColor.init(red: 181/256, green: 181/256, blue: 182/256, alpha: 1)
        let visualEffectView = VisualEffectView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        // Configure the view with tint color, blur radius, etc
        visualEffectView.colorTint = bcColor
        visualEffectView.colorTintAlpha = 0.5
        visualEffectView.blurRadius = 5
        visualEffectView.scale = 1
        
        view.addSubview(visualEffectView)
    }
    
    @objc func addButtonPressed(){
        self.tabBarController?.tabBar.isHidden = true;
        self.addBlurBackgroundView();
        performSegue(withIdentifier: "showAddMetimeModal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddMetimeModal"{
            let destinationVC = segue.destination as! MeTimeAddViewController;
            destinationVC.newMeTimeViewControllerDelegate  = self;
        }
    }
}
