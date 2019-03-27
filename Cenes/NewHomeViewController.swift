//
//  NewHomeViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 12/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit


class NewHomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    
    var tabSelectedHomeDto: HomeDto!
    var loggedInUser: User!;
    var homeDtoList = [HomeDto]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.backgroundColor = themeColor;
        // Do any additional setup after loading the view.
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        self.tabSelectedHomeDto = HomeDto();
        self.tabSelectedHomeDto.tabSelected = "Calendar";
        
        
        //Calling Funcitons
        //Load Home Screen Data on user load
        self.registerTableCells()
        self.loadHomeData();
        
        
    }
    @IBOutlet weak var calendarView: UIView!
    

    override func viewWillAppear(_ animated: Bool) {
        self.setUpNavBarImages();
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func setUpNavBarImages() {
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        self.navigationController?.isNavigationBarHidden = false;
        let homeButton = UIButton.init(type: .custom)
        homeButton.setTitle("Calendar", for: .normal)
        homeButton.titleLabel?.font = .systemFont(ofSize: 10)
        homeButton.setTitleColor(UIColor.black, for: .normal)
        homeButton.frame = CGRect.init(x: 0, y: 0, width: 45 , height: 25)
        homeButton.addTarget(self, action:#selector(calendarTabPressed), for: UIControlEvents.touchUpInside)

        if (self.tabSelectedHomeDto.tabSelected == "Calendar") {
            var lineView = UIView(frame: CGRect(x: 0, y: homeButton.frame.size.height, width: homeButton.frame.size.width, height: 1))
            lineView.backgroundColor = UIColor.black
            homeButton.addSubview(lineView)
        }
        
        let gatheringButton = UIButton.init(type: .custom)
        gatheringButton.setTitle("Invitation", for: .normal)
        gatheringButton.titleLabel?.font = .systemFont(ofSize: 10)
        gatheringButton.setTitleColor(UIColor.black, for: .normal)
        gatheringButton.frame = CGRect.init(x: 0, y: 0, width: 45 , height: 25)
        gatheringButton.addTarget(self, action:#selector(invitationTabPressed), for: UIControlEvents.touchUpInside)

        if (self.tabSelectedHomeDto.tabSelected == "Invitation") {
            var gatheringLineView = UIView(frame: CGRect(x: 0, y: gatheringButton.frame.size.height, width: gatheringButton.frame.size.width, height: 1))
            gatheringLineView.backgroundColor = UIColor.black
            gatheringButton.addSubview(gatheringLineView)
        }
        
        let barButton = UIBarButtonItem.init(customView: homeButton)
        let invitieButton = UIBarButtonItem.init(customView: gatheringButton)
        self.navigationItem.leftBarButtonItems = [barButton, invitieButton]
        
        let calendarButton = UIButton.init(type: .custom)
        calendarButton.setImage(#imageLiteral(resourceName: "calendarNavBarUnselected"), for: UIControlState.normal)
        calendarButton.setImage(#imageLiteral(resourceName: "calendarNavBarSelected"), for: UIControlState.selected)
        calendarButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        let calendarBarButton = UIBarButtonItem.init(customView: calendarButton)
        
        self.navigationItem.rightBarButtonItem = calendarBarButton
       
        
    }
    
    func registerTableCells() ->Void {
        homeTableView.register(UINib(nibName: "HomeEventTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeEventTableViewCell")
        homeTableView.register(UINib(nibName: "HomeCalendarTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeCalendarTableViewCell")
        homeTableView.register(UINib(nibName: "HomeHolidayTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeHolidayTableViewCell")
        homeTableView.register(UINib(nibName: "HomeEventHeaderViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeEventHeaderViewCell")
    }
    
    func loadHomeData() -> Void {
        let queryStr = "user_id=\(String(self.loggedInUser.userId))&date=\(String(Date().toMillis()))";
        
        HomeService().getHomeEvents(queryStr: queryStr, token: self.loggedInUser.token) {(returnedDict) in
            print(returnedDict)
            
            //No Error then populate the table
            if (returnedDict["Error"] as? Bool == false) {
                self.homeDtoList = HomeManager().parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
                self.homeTableView.reloadData();
            } else {
                //Show Empty Screen
            }
        }
    }
    
    func loadGatheringDataByStatus(status: String) -> Void {
        
        let queryStr = "user_id=\(String(self.loggedInUser.userId))&status=\(status)";
        GatheringService().getGatheringEventsByStatus(queryStr: queryStr, token: self.loggedInUser.token) {(returnedDict) in
            print(returnedDict)
            

        }
    }
    
    @objc func calendarTabPressed() {
        self.tabSelectedHomeDto.tabSelected = "Calendar";
        self.setUpNavBarImages();
        self.loadHomeData();
    }
    
    @objc func invitationTabPressed() {
        self.tabSelectedHomeDto.tabSelected = "Invitation";
        self.setUpNavBarImages();
        self.loadGatheringDataByStatus(status: "Going");
    }
}
