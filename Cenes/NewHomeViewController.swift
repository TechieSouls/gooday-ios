//
//  NewHomeViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 12/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

protocol DataTableViewCellProtocol {
    func reloadTableToTop();
    func reloadTableToDesiredSection(rowsToAdd: Int, sectionIndex: Int);
    func scrollTableToDesiredIndex(sectionIndex: Int);
    func addRemoveSubViewOnHeaderTabSelected(selectedTab: String);
}

class NewHomeViewController: UIViewController, UITabBarControllerDelegate, NewHomeViewProtocol {
    
    @IBOutlet weak var homeTableView: UITableView!

    var homescreenDto: HomeDto = HomeDto();
    var loggedInUser: User!;
    var homeDtoList = [HomeData]();
    var totalPageCounts: Int = 0;
    var dataTableViewCellProtocolDelegate: DataTableViewCellProtocol!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.calendarView.backgroundColor = themeColor;
        // Do any additional setup after loading the view.
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);        
        
        var dateComponets = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
        dateComponets.hour = 0;
        dateComponets.minute = 0;
        dateComponets.second = 0;
        dateComponets.nanosecond = 0;
        homescreenDto.timeStamp = Int(Calendar.current.date(from: dateComponets)!.millisecondsSince1970);
        print("Home Screen Date : \(homescreenDto.timeStamp)")
        
        tabBarController?.delegate = self

        //Calling Funcitons
        //Load Home Screen Data on user load
        self.registerTableCells()
        
        DispatchQueue.global(qos: .background).async {
            self.syncDeviceContacts();
        }
        
        self.refreshHomeScreenData();
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.setUpNavBarImages();
        self.homescreenDto.homeRowsVisibility[HomeRows.CalendarRow] = false;
        tabBarController?.delegate = self

        DispatchQueue.main.async {
            self.homeTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //refreshHomeScreenData();
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func syncDeviceContacts() {
        UserService().syncDevicePhoneNumbers(complete: {(response)  in
            
        });
    }
    func refreshHomeScreenData() {
        
        //This method will load the events under calendar Tab
        self.initilizeCalendarData();
        
        //This method will load the dots in the calendar
        self.loadCalendarEventsData();
        
        //This method is to load the invitation tabs data.
        initilizeInvitationTabsData();
    }
    
    /**
     * This method will be used by other screen to refersh home page data when needed.
     **/
    func refershDataFromOtherScreens() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.refreshHomeScreenData();
        });
    }

    
    func setUpNavBarImages() {
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        self.navigationController?.isNavigationBarHidden = false;
        self.navigationController?.navigationBar.isHidden = false;
        self.tabBarController?.tabBar.isHidden = false;
        let myView = UIView.init(frame: CGRect.init(x: 0, y: -1, width: ((self.tabBarController?.tabBar.frame.width)!), height: 2));
        myView.backgroundColor = themeColor;
        self.tabBarController?.tabBar.addSubview(myView);
        
        
        let homeButton = UIButton.init(type: .custom)
        homeButton.setTitle("Calendar", for: .normal)
        homeButton.titleLabel?.font = .systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        homeButton.setTitleColor(UIColor.black, for: .normal)
        homeButton.frame = CGRect.init(x: 10, y: 0, width: 65 , height: 25)
        homeButton.addTarget(self, action:#selector(calendarTabPressed), for: UIControlEvents.touchUpInside)

        if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
            let lineView = UIView(frame: CGRect(x: 0, y: homeButton.frame.size.height, width: homeButton.frame.size.width, height: 1))
            lineView.backgroundColor = UIColor.black
            homeButton.addSubview(lineView)
        }
        
        let gatheringButton = UIButton.init(type: .custom)
        gatheringButton.setTitle("Invitation", for: .normal)
        gatheringButton.titleLabel?.font = .systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        gatheringButton.setTitleColor(UIColor.black, for: .normal)
        gatheringButton.frame = CGRect.init(x: 0, y: 0, width: 70 , height: 25)
        gatheringButton.addTarget(self, action:#selector(invitationTabPressed), for: UIControlEvents.touchUpInside)

        if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.InvitationTab) {
            let gatheringLineView = UIView(frame: CGRect(x: 0, y: gatheringButton.frame.size.height, width: gatheringButton.frame.size.width, height: 1))
            gatheringLineView.backgroundColor = UIColor.black
            gatheringButton.addSubview(gatheringLineView)
        }
        
        let barButton = UIBarButtonItem.init(customView: homeButton)
        let invitieButton = UIBarButtonItem.init(customView: gatheringButton)
        self.navigationItem.leftBarButtonItems = [barButton, invitieButton]
        
        let calendarButton = UIButton.init(type: .custom)
        calendarButton.setImage(UIImage.init(named: "plus_icon"), for: UIControlState.normal)
        //calendarButton.setImage(UIImage.init(named: "plus_icon"),, for: UIControlState.selected)
        calendarButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        calendarButton.addTarget(self, action:#selector(plusButtonPressed), for: UIControlEvents.touchUpInside)

        let calendarBarButton = UIBarButtonItem.init(customView: calendarButton)

        self.navigationItem.rightBarButtonItem = calendarBarButton
       
        
    }
    
    func registerTableCells() ->Void {
        
        homeTableView.register(UINib(nibName: "DateDropDownTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DateDropDownTableViewCell");
        
        homeTableView.register(UINib(nibName: "InvitationTabsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InvitationTabsTableViewCell");
        
        homeTableView.register(UINib(nibName: "HomeFSCalendarTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeFSCalendarTableViewCell");
        
        homeTableView.register(UINib(nibName: "DataTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DataTableViewCell");
        
    }
    
    
    func loadPastEvents() -> Void {
        
        let queryStr = "userId=\(String(loggedInUser.userId))&timestamp=\(String(homescreenDto.timeStamp))&pageNumber=\(String(0))&offSet=\(String(20))";
        
        HomeService().getHomeEvents(queryStr: queryStr, token: loggedInUser.token) {(returnedDict) in
            //print(returnedDict)
            
            //No Error then populate the table
            if (returnedDict["success"] as? Bool == true) {
                let calendarData = HomeManager().parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
                
                self.homescreenDto.pageable.totalCalendarCounts = returnedDict["totalCounts"]  as! Int;
                
                self.homescreenDto.calendarData = HomeManager().mergeCurrentAndFutureList(currentList: self.homescreenDto.calendarData, futureList: calendarData)
                
                //if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                    //self.homeDtoList = self.homescreenDto.calendarData;
                    //self.totalPageCounts = self.homescreenDto.pageable.totalCalendarCounts
                    //self.homeTableView.reloadData();
                    
                    let previousDate = Calendar.current.date(byAdding: .month, value: -6, to: Date())!
                    
                    let queryStr = "userId=\(String(self.loggedInUser.userId))&startTime=\(String(describing: previousDate.millisecondsSince1970))&endTime=\(String(describing: self.homescreenDto.timeStamp))";
                    
                    HomeService().getHomePastEvents(queryStr: queryStr, token: self.loggedInUser.token) {(returnedDict) in
                        //print(returnedDict)
                        
                        self.homeTableView.reloadData();

                        //No Error then populate the table
                        if (returnedDict["success"] as? Bool == true) {
                            var calendarData = HomeManager().parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
                            print("Previous Events Count : ", calendarData.count)

                            if (calendarData.count > 0) {
                                if (self.homescreenDto.pageable.totalCalendarCounts == 0) {
                                    self.homescreenDto.scrollToSectionIndex = calendarData.count - 1;
                                } else {
                                    self.homescreenDto.scrollToSectionIndex = calendarData.count;
                                }
                                
                                
                                self.homescreenDto.calendarData = HomeManager().mergePreviousDataAtTop(currentList: self.homescreenDto.calendarData, previous: calendarData);
                                
                                self.homeDtoList = self.homescreenDto.calendarData;
                                self.totalPageCounts =  self.totalPageCounts + calendarData.count;
                                
                                
                                // Better than reload the whole tableview
                                /*let lastOffset = self.homeTableView.contentOffset
                                 
                                 self.homeTableView.beginUpdates()
                                 self.homeTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                                 self.homeTableView.endUpdates()
                                 self.homeTableView.contentOffset = lastOffset
                                 */
                                
                                self.dataTableViewCellProtocolDelegate.reloadTableToDesiredSection(rowsToAdd: calendarData.count, sectionIndex: self.homescreenDto.scrollToSectionIndex)
                                
                            }
                        }
                    }
                //}
            } else {
                //Show Empty Screen
            }
        }
    }
    
    /**
     * This function is used to show the data under Calendar Tab..
     **/
    func loadHomeData(pageNumber: Int, offSet: Int) -> Void {
        
        let queryStr = "userId=\(String(loggedInUser.userId))&timestamp=\(String(homescreenDto.timeStamp))&pageNumber=\(String(pageNumber))&offSet=\(String(offSet))";
        
        HomeService().getHomeEvents(queryStr: queryStr, token: loggedInUser.token) {(returnedDict) in
            //print(returnedDict)
            
            //No Error then populate the table
            if (returnedDict["success"] as? Bool == true) {
                var calendarData = HomeManager().parseResults(resultArray: (returnedDict["data"] as? NSArray)!)

                self.homescreenDto.pageable.totalCalendarCounts = returnedDict["totalCounts"]  as! Int;

                self.homescreenDto.calendarData = HomeManager().mergeCurrentAndFutureList(currentList: self.homescreenDto.calendarData, futureList: calendarData)
                
                if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                    self.homeDtoList = self.homescreenDto.calendarData;
                    self.totalPageCounts = self.homescreenDto.pageable.totalCalendarCounts
                    self.homeTableView.reloadData();
                }
            } else {
                //Show Empty Screen
            }
        }
    }
    
    /**
     * This funciton is to show data under the Invitation Tabs
     * Accepted | Pending | Declined
     **/
    func loadGatheringDataByStatus(status: String, pageNumber: Int, offSet: Int) -> Void {
        
        let queryStr = "userId=\(String(self.loggedInUser.userId))&status=\(status)&timestamp=\(String(homescreenDto.timeStamp))&pageNumber=\(String(pageNumber))&offSet=\(String(offSet))";
        
        GatheringService().getGatheringEventsByStatus(queryStr: queryStr, token: self.loggedInUser.token) {(returnedDict) in
            //print(returnedDict)
            //No Error then populate the table
            if (returnedDict["success"] as? Bool == true) {
                var homeDataList = HomeManager().parseInvitationResults(resultArray: (returnedDict["data"] as? NSArray)!)
                
                if (status == "Going") {
                    self.homescreenDto.acceptedGatherings = HomeManager().mergeCurrentAndFutureList(currentList: self.homescreenDto.acceptedGatherings, futureList: homeDataList);

                    self.homescreenDto.pageable.totalAcceptedCounts = returnedDict["totalCounts"]  as! Int;
                } else if (status == "Pending") {
                    self.homescreenDto.pendingGatherings = HomeManager().mergeCurrentAndFutureList(currentList: self.homescreenDto.pendingGatherings, futureList: homeDataList);
                    self.homescreenDto.pageable.totalPendingCounts = returnedDict["totalCounts"]  as! Int;

                } else if (status == "NotGoing") {
                    self.homescreenDto.declinedGatherings = HomeManager().mergeCurrentAndFutureList(currentList: self.homescreenDto.declinedGatherings, futureList: homeDataList);
                    self.homescreenDto.pageable.totalDeclinedCounts = returnedDict["totalCounts"]  as! Int;

                }
                
                if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.InvitationTab) {
                    if (self.homescreenDto.invitationTabs == HomeInvitationTabs.Accepted) {
                        self.homeDtoList = self.homescreenDto.acceptedGatherings;
                        self.totalPageCounts = self.homescreenDto.pageable.totalAcceptedCounts
                        self.homeTableView.reloadData();
                        
                    } else if (self.homescreenDto.invitationTabs == HomeInvitationTabs.Pending) {
                        self.homeDtoList = self.homescreenDto.pendingGatherings;
                        self.totalPageCounts = self.homescreenDto.pageable.totalPendingCounts
                        self.homeTableView.reloadData();
                        
                        
                    } else if (self.homescreenDto.invitationTabs == HomeInvitationTabs.Declined) {
                        self.homeDtoList = self.homescreenDto.declinedGatherings;
                        self.totalPageCounts = self.homescreenDto.pageable.totalDeclinedCounts;
                        self.homeTableView.reloadData();
                    }
                }
                
            } else {
                //Show Empty Screen
            }

        }
    }
    
    func loadGatheringDataByPullDown(status: String, pageNumber: Int, offSet: Int) -> Void {
        
        let queryStr = "userId=\(String(self.loggedInUser.userId))&status=\(status)&timestamp=\(String(homescreenDto.timeStamp))&pageNumber=\(String(pageNumber))&offSet=\(String(offSet))";
        
        GatheringService().getGatheringEventsByStatus(queryStr: queryStr, token: self.loggedInUser.token) {(returnedDict) in
            print(returnedDict)
            //No Error then populate the table
            if (returnedDict["success"] as? Bool == true) {
                var homeDataList = HomeManager().parseInvitationResults(resultArray: (returnedDict["data"] as? NSArray)!)
                
                if (status == "Going") {
                    self.homescreenDto.pageable.acceptedGathetingPageNumber = 0;
                    self.homescreenDto.acceptedGatherings = HomeManager().mergeCurrentAndFutureList(currentList: self.homescreenDto.acceptedGatherings, futureList: homeDataList);
                    self.homescreenDto.pageable.totalAcceptedCounts = returnedDict["totalCounts"]  as! Int;

                } else if (status == "Pending") {
                    self.homescreenDto.pageable.pendingGathetingPageNumber = 0;
                    self.homescreenDto.pendingGatherings = HomeManager().mergeCurrentAndFutureList(currentList: self.homescreenDto.pendingGatherings, futureList: homeDataList);
                    self.homescreenDto.pageable.totalPendingCounts = returnedDict["totalCounts"]  as! Int;

                } else if (status == "NotGoing") {
                    self.homescreenDto.pageable.declinedGathetingPageNumber = 0;
                    self.homescreenDto.declinedGatherings = HomeManager().mergeCurrentAndFutureList(currentList: self.homescreenDto.declinedGatherings, futureList: homeDataList);
                    self.homescreenDto.pageable.totalDeclinedCounts = returnedDict["totalCounts"]  as! Int;

                }
                
                if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.InvitationTab) {

                    if (self.homescreenDto.invitationTabs == HomeInvitationTabs.Accepted) {
                        self.homeDtoList = self.homescreenDto.acceptedGatherings;
                        self.totalPageCounts = self.homescreenDto.pageable.totalAcceptedCounts
                        self.homeTableView.reloadData();
                        
                    } else if (self.homescreenDto.invitationTabs == HomeInvitationTabs.Pending) {
                        self.homeDtoList = self.homescreenDto.pendingGatherings;
                        self.totalPageCounts = self.homescreenDto.pageable.totalPendingCounts
                        self.homeTableView.reloadData();
                        
                        
                    } else if (self.homescreenDto.invitationTabs == HomeInvitationTabs.Declined) {
                        self.homeDtoList = self.homescreenDto.declinedGatherings;
                        self.totalPageCounts = self.homescreenDto.pageable.totalDeclinedCounts;
                        self.homeTableView.reloadData();
                        
                    }
                }
            } else {
                //Show Empty Screen
            }
            
        }
    }
    
    /**
     * This function is to show dots in the Calendar at home screen
     **/
    func loadCalendarEventsData() -> Void {
        
        var yearStartDateComponents = DateComponents();
        yearStartDateComponents.day = 1;
        yearStartDateComponents.month = 6;
        yearStartDateComponents.hour = 0;
        yearStartDateComponents.minute = 0;
        yearStartDateComponents.second = 0;
        yearStartDateComponents.nanosecond = 0;
        yearStartDateComponents.year = (Calendar.current.dateComponents(in: TimeZone.current, from: Date()).year! - 1);
        let startTime: Int64 = Calendar.current.date(from: yearStartDateComponents)!.millisecondsSince1970;
        
        
        var yearEndDateComponents = DateComponents();
        yearEndDateComponents.day = 31;
        yearEndDateComponents.month = 12;
        yearEndDateComponents.hour = 23;
        yearEndDateComponents.minute = 59;
        yearEndDateComponents.second = 59;
        yearEndDateComponents.nanosecond = 0;
        yearEndDateComponents.year = (Calendar.current.dateComponents(in: TimeZone.current, from: Date()).year!+1);
        let endTime: Int64 = Calendar.current.date(from: yearEndDateComponents)!.millisecondsSince1970;
        
        let queryStr = "userId=\(String(loggedInUser.userId))&startTime=\(String(startTime))&endTime=\(String(endTime))";
        
        HomeService().getHomeCalendarEvents(queryStr: queryStr, token: loggedInUser.token) {(returnedDict) in
            print(returnedDict)
            
            //No Error then populate the table
            if (returnedDict["success"] as? Bool == true) {
                var calendarEventsData = returnedDict["data"] as! NSArray
                
                let calendarEventDataDto = self.homescreenDto.calendarEventsData;
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd";
                
                for calendarEventTemp in calendarEventsData {
                    var calendarEventDict = calendarEventTemp as! NSDictionary;
                
                    let eventDateMillis: Int = calendarEventDict.value(forKey: "start_time") as! Int;
                    let eventDateStr = dateFormatter.string(from: Date(milliseconds: eventDateMillis));
                    
                    let eventType: String = calendarEventDict.value(forKey: "schedule_as") as! String;
                    
                    if (!calendarEventDataDto.eventDates.contains(eventDateStr) && (eventType == "Event" || eventType == "Gathering")) {
                        calendarEventDataDto.eventDates.append(eventDateStr);
                    }
                    
                    if (!calendarEventDataDto.holidayDates.contains(eventDateStr) && eventType == "Holiday") {
                        calendarEventDataDto.holidayDates.append(eventDateStr);
                    }
                }
                self.homescreenDto.calendarEventsData = calendarEventDataDto;
                self.homeTableView.reloadData();
            } else {
                //Show Empty Screen
            }
        }
    }
    
    func calendarDatePressed(date: Date) {
        
        homescreenDto.timeStamp = Int(date.millisecondsSince1970);
        initilizeCalendarData();
        initilizeInvitationTabsData();
    }
    
    func initilizeCalendarData() {
        homescreenDto.pageable.calendarDataPageNumber = 0;
        homescreenDto.calendarData = [HomeData]();
        //self.loadHomeData(pageNumber: homescreenDto.pageable.calendarDataPageNumber, offSet: homescreenDto.pageable.calendarDataOffset);
        self.loadPastEvents();
    }
    
    func initilizeInvitationTabsData() {
        homescreenDto.pageable.acceptedGathetingPageNumber = 0;
        homescreenDto.pageable.pendingGathetingPageNumber = 0;
        homescreenDto.pageable.declinedGathetingPageNumber = 0;
        
        homescreenDto.acceptedGatherings = [HomeData]();
        homescreenDto.pendingGatherings = [HomeData]();
        homescreenDto.declinedGatherings = [HomeData]();
        
        self.loadGatheringDataByStatus(status: "Going", pageNumber: homescreenDto.pageable.acceptedGathetingPageNumber, offSet: homescreenDto.pageable.acceptedGatheringOffset);
        self.loadGatheringDataByStatus(status: "Pending", pageNumber: homescreenDto.pageable.pendingGathetingPageNumber, offSet: homescreenDto.pageable.pendingGatheringOffset);
        self.loadGatheringDataByStatus(status: "NotGoing", pageNumber: homescreenDto.pageable.declinedGathetingPageNumber, offSet: homescreenDto.pageable.declinedGatheringOffset);
    }
    
    @objc func calendarTabPressed() {
        self.homescreenDto.headerTabsActive = HomeHeaderTabs.CalendarTab;
        
        self.homescreenDto.homeRowsVisibility[HomeRows.ThreeTabs] = false;

        self.homeDtoList = homescreenDto.calendarData;
        self.setUpNavBarImages();
        self.homeTableView.reloadData()
        self.dataTableViewCellProtocolDelegate.reloadTableToTop();
        //self.loadHomeData();
    }
    
    @objc func invitationTabPressed() {
        self.homescreenDto.headerTabsActive = HomeHeaderTabs.InvitationTab;
        
        //self.dataTableViewCellProtocolDelegate.addRemoveSubViewOnHeaderTabSelected(selectedTab: HomeHeaderTabs.InvitationTab);

        self.homescreenDto.homeRowsVisibility[HomeRows.ThreeTabs] = true;
        self.homescreenDto.invitationTabs = HomeInvitationTabs.Accepted;
        self.homeDtoList = homescreenDto.acceptedGatherings;
        self.setUpNavBarImages();
        self.homeTableView.reloadData()
        self.dataTableViewCellProtocolDelegate.reloadTableToTop();
        //self.loadGatheringDataByStatus(status: "Going");
    }
    
    @objc func plusButtonPressed() {
        let friendsViewController: FriendsViewController = storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
        navigationController?.pushViewController(friendsViewController, animated: true)
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (self.homeDtoList.count > 0) {
            if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                self.dataTableViewCellProtocolDelegate.scrollTableToDesiredIndex(sectionIndex: self.homescreenDto.scrollToSectionIndex)
            } else {
                self.dataTableViewCellProtocolDelegate.reloadTableToTop();
            }
        }
    }
}
