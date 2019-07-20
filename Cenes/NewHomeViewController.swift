//
//  NewHomeViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 12/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import Crashlytics

protocol DataTableViewCellProtocol {
    func reloadTableToTop();
    func refreshInnerTable();
    func reloadTableToDesiredSection(rowsToAdd: Int, sectionIndex: Int);
    func scrollTableToDesiredIndex(sectionIndex: Int);
    func addRemoveSubViewOnHeaderTabSelected(selectedTab: String);
}

protocol DateDroDownCellProtocol {
    func updateDate(milliseconds: Int);
}
protocol HomeFSCalendarCellProtocol {
    func updateCalendarToTodayMonth();
}
class NewHomeViewController: UIViewController, UITabBarControllerDelegate, NewHomeViewProtocol {
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var calendrStatusToast: UILabel!

    var refreshCalButton: UIButton!;
    var homescreenDto: HomeDto = HomeDto();
    var loggedInUser: User!;
    var homeDtoList = [HomeData]();
    var totalPageCounts: Int = 0;
    var currentDateSectionIndex = 0;
    var dataTableViewCellProtocolDelegate: DataTableViewCellProtocol!;
    var dateDroDownCellProtocolDelegate: DateDroDownCellProtocol!;
    var homeFSCalendarTableViewCellDelegate: HomeFSCalendarTableViewCell!
    
    var homeFSCalendarCellProtocol: HomeFSCalendarCellProtocol!;
    var activityIndicator = UIActivityIndicatorView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.calendarView.backgroundColor = themeColor;
        // Do any additional setup after loading the view.
        
        calendrStatusToast.layer.cornerRadius = 10;
        calendrStatusToast.clipsToBounds  =  true

        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);        
        
        var dateComponets = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
        dateComponets.hour = 0;
        dateComponets.minute = 0;
        dateComponets.second = 0;
        dateComponets.nanosecond = 0;
        homescreenDto.timeStamp = Int(Calendar.current.date(from: dateComponets)!.millisecondsSince1970);
        print("Home Screen Date : \(homescreenDto.timeStamp)")
        
        tabBarController?.delegate = self;
        
        activityIndicator.activityIndicatorViewStyle = .gray;
        activityIndicator.center = view.center;
        self.view.addSubview(activityIndicator);

        self.calendrStatusToast.frame = CGRect.init(x: ((self.view.frame.width/2) - (self.calendrStatusToast.frame.width/2)) , y: (self.view.frame.height/2) + 30, width: self.calendrStatusToast.frame.width, height: 35)
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
        self.initilizeInvitationTabsData();
    }
    
    /**
     * This method will be used by other screen to refersh home page data when needed.
     **/
    func refershDataFromOtherScreens() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
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
        
        
        // Left Side Buttons ************************
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
        
        
        //Right Side Button  ****************************/
        refreshCalButton = UIButton.init(type: .custom)
        refreshCalButton.setImage(UIImage.init(named: "refresh_cal_icon"), for: UIControlState.normal)
        refreshCalButton.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24)
        refreshCalButton.addTarget(self, action:#selector(refreshButtonPressed), for: UIControlEvents.touchUpInside)
        
        let refreshCalBarButton = UIBarButtonItem.init(customView: refreshCalButton)

        
        let calendarButton = UIButton.init(type: .custom)
        calendarButton.setImage(UIImage.init(named: "plus_icon"), for: UIControlState.normal)
        //calendarButton.setImage(UIImage.init(named: "plus_icon"),, for: UIControlState.selected)
        calendarButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        calendarButton.addTarget(self, action:#selector(plusButtonPressed), for: UIControlEvents.touchUpInside)

        let calendarBarButton = UIBarButtonItem.init(customView: calendarButton)

        self.navigationItem.rightBarButtonItems = [calendarBarButton, refreshCalBarButton]
       
        
    }
    
    func registerTableCells() ->Void {
        
        homeTableView.register(UINib(nibName: "DateDropDownTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DateDropDownTableViewCell");
        
        homeTableView.register(UINib(nibName: "InvitationTabsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InvitationTabsTableViewCell");
        
        homeTableView.register(UINib(nibName: "HomeFSCalendarTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeFSCalendarTableViewCell");
        
        homeTableView.register(UINib(nibName: "DataTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DataTableViewCell");
    }
        
    //Function to call events while scrolling pages.
    func getMonthPageEvents(compos: DateComponents,  startimeStamp: Int, endtimeStamp: Int, scrollType: String) {
        
        print("Loading home data by Month Wise....")

        if (self.dateDroDownCellProtocolDelegate != nil) {
            self.dateDroDownCellProtocolDelegate.updateDate(milliseconds: startimeStamp);
        }

        //This block will only run if data is not loaded.
        if (!homescreenDto.monthTrackerForDataLoad.contains("\(compos.month!)-\(compos.year!)")) {
            homescreenDto.monthTrackerForDataLoad.append("\(compos.month!)-\(compos.year!)");
            
            let queryStr = "userId=\(String(loggedInUser.userId))&startimeStamp=\(String(startimeStamp))&endtimeStamp=\(String(endtimeStamp))";
            
            HomeService().getMonthWiseEvents(queryStr: queryStr, token: loggedInUser.token, complete: {(response) in
                //print(response);
                
                let success = response.value(forKey: "success") as! Int;
                if (success == 0) {
                    
                } else {
                    
                    //self.homescreenDto.totalEventsList = HomeManager().populateTotalEventIds(eventIdList: self.homescreenDto.totalEventsList, resultArray: (response["data"] as? NSArray)!);
                    
                    //let calendarData = HomeManager().parseResults(totalEvents: self.homescreenDto.totalEventsList, resultArray: (response["data"] as? NSArray)!)
                    let homeScreenDataHolder = HomeManager().parseResultsForHomeEvents(homescreenDto: self.homescreenDto, resultArray: (response["data"] as? NSArray)!);
                    
                    var calendarData = homeScreenDataHolder.homeDataList!;
                    self.homescreenDto = homeScreenDataHolder.homescreenDto;

                    if (calendarData.count > 0) {
                        
                        var calDataFroMonthScrollDto: HomeData!
                        var sectionObjectIndex: Int = 0;
                        var isFinalMonthDtoIndexFound = false;
                        for homeDataDto in calendarData {
                            
                            sectionObjectIndex = 0;
                            for event in homeDataDto.sectionObjects {
                                if (event.scheduleAs != "MonthSeparator") {
                                    calDataFroMonthScrollDto = homeDataDto;
                                    isFinalMonthDtoIndexFound = true;
                                    break;
                                }
                                sectionObjectIndex = sectionObjectIndex +  1;
                            }
                            
                            if (isFinalMonthDtoIndexFound == true) {
                                break;
                            }
                        }
                        
                        let monthScrollDto = MonthScrollDto();
                        monthScrollDto.indexKey = calDataFroMonthScrollDto.sectionName;
                        monthScrollDto.year = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(calDataFroMonthScrollDto.sectionObjects[sectionObjectIndex].startTime))).year!;
                        
                        //self.homescreenDto.timeStamp = Int(calendarData[0].sectionObjects[0].startTime);
                        
                        self.homescreenDto.monthScrollIndex["\(compos.month!)-\(compos.year!)"] = monthScrollDto;
                        
                        monthScrollDto.timestamp = startimeStamp;
                        self.homescreenDto.topHeaderDateIndex[HomeManager().getMonthWithYearKeyForScrollIndex(startTime: self.homescreenDto.timeStamp)] = monthScrollDto;
                        
                        //if (self.homescreenDto.monthTrackerForDataLoad.count == 1) {
                        //    self.homescreenDto.scrollToMonthStartSectionAtHomeButton.append(monthScrollDto);
                        //}
                        
                        
                        self.homescreenDto.pageable.totalCalendarCounts = self.homescreenDto.pageable.totalCalendarCounts + Int(response["totalCounts"]  as! Int);
                        
                        
                        let currentMonth = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
                        
                        if (Int(compos.month!) < Int(currentMonth.month!) && Int(compos.year!) <= Int(currentMonth.year!)) {
                            
                            self.homescreenDto.calendarData = HomeManager().mergePreviousDataAtTop(currentList: self.homescreenDto.calendarData, previous: calendarData);
                            
                        } else {
                            self.homescreenDto.calendarData = HomeManager().mergeCurrentAndFutureList(currentList: self.homescreenDto.calendarData, futureList: calendarData);
                        }
                        
                        if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                            
                            self.homeDtoList = self.homescreenDto.calendarData;
                            self.totalPageCounts = self.homescreenDto.pageable.totalCalendarCounts;
                            self.dataTableViewCellProtocolDelegate.refreshInnerTable();
                            if (scrollType == HomeScrollType.CALENDARSCROLL) {
                                self.dataTableViewCellProtocolDelegate.scrollTableToDesiredIndex(sectionIndex: HomeManager().getScrollIndexFromMonthKey(homeDataList: self.homeDtoList, key: self.homescreenDto.monthScrollIndex["\(compos.month!)-\(compos.year!)"]!));
                            }
                        }
                    
                    } else {
                        
                        let key = HomeManager().getMonthWithYearKeyForScrollIndex(startTime: startimeStamp);
                        
                        let monthScrollDto = MonthScrollDto();
                        monthScrollDto.timestamp = startimeStamp;
                        self.homescreenDto.topHeaderDateIndex[key] = monthScrollDto;
                    }
                }
            })
        } else {
    
            if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {

                if (self.homescreenDto.monthScrollIndex["\(compos.month!)-\(compos.year!)"] != nil) {
                    self.dataTableViewCellProtocolDelegate.scrollTableToDesiredIndex(sectionIndex: HomeManager().getScrollIndexFromMonthKey(homeDataList: self.homeDtoList, key: self.homescreenDto.monthScrollIndex["\(compos.month!)-\(compos.year!)"]!));
                }
            }
        }
    }
    
    func loadPastEvents() -> Void {
        
        self.homescreenDto.calendarData = [HomeData]();
        let queryStr = "userId=\(String(loggedInUser.userId))&timestamp=\(String(self.homescreenDto.currentMonthStartDateTimeStamp))&pageNumber=\(String(0))&offSet=\(String(20))";
        
        HomeService().getHomeEvents(queryStr: queryStr, token: loggedInUser.token) {(returnedDict) in
            //print(returnedDict)
            
            //No Error then populate the table
            if (returnedDict["success"] as? Bool == true) {
                
                
                let homeScreenDataHolder = HomeManager().parseResultsForHomeEvents(homescreenDto: self.homescreenDto, resultArray: (returnedDict["data"] as? NSArray)!)
                
                let calendarData = homeScreenDataHolder.homeDataList!;
                self.homescreenDto = homeScreenDataHolder.homescreenDto;
                
                self.homescreenDto.pageable.totalCalendarCounts = returnedDict["totalCounts"]  as! Int;
                
                if (calendarData.count > 0) {
                    
                    self.homescreenDto.calendarData = calendarData;
                    
                    //If this is the initial hit, Then we will get the first event inedx.
                    let currentPresentDate = Date().millisecondsSince1970;
                    var homeDataForCuurentMonthFutureEvent: HomeData!;
                    var isGreaterDateFound = false;
                    for homeDataTemp in calendarData {
                        
                        for eventTemp in homeDataTemp.sectionObjects {
                            
                            if (eventTemp.startTime >=  currentPresentDate) {
                                homeDataForCuurentMonthFutureEvent = homeDataTemp;
                                isGreaterDateFound = true;
                                break;
                            }
                        }
                        
                        if (isGreaterDateFound == true) {
                            break;
                        }
                    }
                    
                    
                    var firstHomeData = calendarData[0];
                    if (homeDataForCuurentMonthFutureEvent != nil) {
                        firstHomeData = homeDataForCuurentMonthFutureEvent;
                    }
                
                
                    
                    let monthScrollDto = MonthScrollDto();
                    monthScrollDto.indexKey = firstHomeData.sectionName;
                    monthScrollDto.year = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(firstHomeData.sectionObjects[0].startTime))).year!;
                    
                    monthScrollDto.timestamp = Int(Date(milliseconds: Int(firstHomeData.sectionObjects[0].startTime)).startOfMonth().millisecondsSince1970);
                    
                    self.homescreenDto.topHeaderDateIndex[HomeManager().getMonthWithYearKeyForScrollIndex(startTime: Int(Date(milliseconds: Int(firstHomeData.sectionObjects[0].startTime)).startOfMonth().millisecondsSince1970))] = monthScrollDto;
                        
                    self.homescreenDto.scrollToMonthStartSectionAtHomeButton = [MonthScrollDto]();
                        self.homescreenDto.scrollToMonthStartSectionAtHomeButton.append(monthScrollDto);
                }
                //if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                    //self.homeDtoList = self.homescreenDto.calendarData;
                    //self.totalPageCounts = self.homescreenDto.pageable.totalCalendarCounts
                    //self.homeTableView.reloadData();
                    
                    let previousDate = Calendar.current.date(byAdding: .month, value: -12, to: Date(milliseconds: Int(self.homescreenDto.startTimeStampToFetchPageableData)))!
  
                    let queryStr = "userId=\(String(self.loggedInUser.userId))&startTime=\(String(describing: previousDate.millisecondsSince1970))&endTime=\(String(describing: self.homescreenDto.currentMonthStartDateTimeStamp))";
                
                    HomeService().getHomePastEvents(queryStr: queryStr, token: self.loggedInUser.token) {(returnedDict) in
                        //print(returnedDict)
                        
                        self.homeTableView.reloadData();

                        if (returnedDict["success"] as? Bool == true) {
                            
                            //Let calculate headers for past events
                            let pastCalendarData = HomeManager().parseResults(resultArray: returnedDict["data"] as! NSArray);

                            //Setting today date index to be at the count of past event
                            if (pastCalendarData.count > 0) {
                                if (pastCalendarData.count == 1) {
                                     self.homescreenDto.scrollToSectionSectionAtHomeButtonIndexNumber = pastCalendarData.count;
                                } else {
                                     self.homescreenDto.scrollToSectionSectionAtHomeButtonIndexNumber = pastCalendarData.count - 1;
                                }
                            }
                            
                            self.homescreenDto.pageable.totalCalendarCounts = self.homescreenDto.pageable.totalCalendarCounts + Int(returnedDict["totalCounts"]  as! Int);
                            
                            let homeScreenDataHolder = HomeManager().parseResultsForHomeEvents(homescreenDto: self.homescreenDto, resultArray: (returnedDict["data"] as? NSArray)!)
                            
                            
                            let calendarData = homeScreenDataHolder.homeDataList!;
                            self.homescreenDto = homeScreenDataHolder.homescreenDto;
                            print("Previous Events Count : ", calendarData.count)

                            //If we have past events counts is greater than zero
                            if (calendarData.count > 0) {
                                
                                //If we dont have any current events for a user. Then
                                // we will scroll user to last event of past events
                                if (self.homescreenDto.calendarData.count == 0) {
                                    self.homescreenDto.scrollToMonthStartSectionAtHomeButton = [MonthScrollDto]();
                                    let lastDataOfPastEvents = calendarData[calendarData.count - 1];
                                    
                                    let monthScrollDto = MonthScrollDto();
                                    monthScrollDto.indexKey = HomeManager().getMonthKeyForScrollIndex(startTime: Int(lastDataOfPastEvents.sectionObjects[0].startTime));
                                    monthScrollDto.year = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(lastDataOfPastEvents.sectionObjects[0].startTime))).year!;
                                    monthScrollDto.timestamp = Int(lastDataOfPastEvents.sectionObjects[0].startTime);
                                    
                                    self.homescreenDto.scrollToMonthStartSectionAtHomeButton.append(monthScrollDto);
                                }
                                
                                if (self.homescreenDto.pageable.totalCalendarCounts == 0) {
                                    //self.homescreenDto.scrollToSectionIndex = calendarData.count - 1;
                                } else {
                                    if (self.currentDateSectionIndex == 0) {
                                        self.currentDateSectionIndex = calendarData.count
                                    }
                                }
                                
                                self.homescreenDto.calendarData = HomeManager().mergePreviousDataAtTop(currentList: self.homescreenDto.calendarData, previous: calendarData);
                            }
                            
                            if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                                
                                self.homeDtoList = self.homescreenDto.calendarData;
                                self.totalPageCounts =  self.homescreenDto.pageable.totalCalendarCounts;
                                self.dataTableViewCellProtocolDelegate.refreshInnerTable();
                                
                                if (self.homescreenDto.scrollToMonthStartSectionAtHomeButton.count > 0) {
                                    self.dataTableViewCellProtocolDelegate.scrollTableToDesiredIndex(sectionIndex: HomeManager().getScrollIndexForTodaysEvent(homeDataList: self.homeDtoList, key: self.homescreenDto.scrollToMonthStartSectionAtHomeButton[0]))
                                }
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
        
        let queryStr = "userId=\(String(loggedInUser.userId))&timestamp=\(String(homescreenDto.startTimeStampToFetchPageableData))&pageNumber=\(String(pageNumber))&offSet=\(String(offSet))";
        
        HomeService().getHomeEvents(queryStr: queryStr, token: loggedInUser.token) {(returnedDict) in
            //print(returnedDict)
            
            //No Error then populate the table
            if (returnedDict["success"] as? Bool == true) {
                
                //self.homescreenDto.totalEventsList = HomeManager().populateTotalEventIds(eventIdList: self.homescreenDto.totalEventsList, resultArray: (returnedDict["data"] as? NSArray)!);
                let homeScreenDataHolder = HomeManager().parseResultsForHomeEvents(homescreenDto: self.homescreenDto, resultArray: (returnedDict["data"] as? NSArray)!)

                let calendarData = homeScreenDataHolder.homeDataList!;
                self.homescreenDto = homeScreenDataHolder.homescreenDto;
                
                /*self.homescreenDto.pageable.totalCalendarCounts = returnedDict["totalCounts"]  as! Int;

                self.homescreenDto.calendarData = HomeManager().mergeCurrentAndFutureList(currentList: self.homescreenDto.calendarData, futureList: calendarData)
                
                if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                    self.homeDtoList = self.homescreenDto.calendarData;
                    self.totalPageCounts = self.homescreenDto.pageable.totalCalendarCounts
                    self.homeTableView.reloadData();
                }*/
                
                if (calendarData.count > 0) {
                    
                    self.homescreenDto.pageable.calendarDataPageNumber = self.homescreenDto.pageable.calendarDataPageNumber + 20;

                    
                    //If this is the initial hit, Then we will get the first event inedx.
                    if (pageNumber == 0) {
                        
                        let firstHomeData = calendarData[0];
                        
                        let monthScrollDto = MonthScrollDto();
                        monthScrollDto.indexKey = firstHomeData.sectionName;
                        monthScrollDto.year = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(firstHomeData.sectionObjects[0].startTime))).year!;
                        
                        monthScrollDto.timestamp = Int(Date(milliseconds: Int(firstHomeData.sectionObjects[0].startTime)).startOfMonth().millisecondsSince1970);

                        self.homescreenDto.topHeaderDateIndex[HomeManager().getMonthWithYearKeyForScrollIndex(startTime: Int(Date(milliseconds: Int(firstHomeData.sectionObjects[0].startTime)).startOfMonth().millisecondsSince1970))] = monthScrollDto;

                        
                        //self.homescreenDto.scrollToMonthStartSectionAtHomeButton.insert(monthScrollDto, at: 0);
                    }
                    
                    //let monthScrollDto = MonthScrollDto();
                    //monthScrollDto.indexKey = calendarData[0].sectionName;
                    //monthScrollDto.year = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(calendarData[0].sectionObjects[0].startTime))).year!;
                    
                    //self.homescreenDto.timeStamp = Int(calendarData[0].sectionObjects[0].startTime);
                    
                    let compos = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: self.homescreenDto.timeStamp));
                    
                    //self.homescreenDto.monthScrollIndex["\(compos.month!)-\(compos.year!)"] = monthScrollDto;
                    
                    //monthScrollDto.timestamp = Int(Date(milliseconds: self.homescreenDto.timeStamp).startOfMonth().millisecondsSince1970);
                    //self.homescreenDto.topHeaderDateIndex[HomeManager().getMonthWithYearKeyForScrollIndex(startTime: self.homescreenDto.timeStamp)] = monthScrollDto;
                    
                        //self.homescreenDto.scrollToSectionIndexAtHomeButton.append(monthScrollDto);

                    
                       self.homescreenDto.pageable.totalCalendarCounts = self.homescreenDto.pageable.totalCalendarCounts + Int(returnedDict["totalCounts"]  as! Int);
                        
                        
                        let currentMonth = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
                        
                        if (Int(compos.month!) < Int(currentMonth.month!) && Int(compos.year!) <= Int(currentMonth.year!)) {
                            
                            self.homescreenDto.calendarData = HomeManager().mergePreviousDataAtTop(currentList: self.homescreenDto.calendarData, previous: calendarData);
                            
                        } else {
                            self.homescreenDto.calendarData = HomeManager().mergeCurrentAndFutureList(currentList: self.homescreenDto.calendarData, futureList: calendarData);
                        }
                        
                        if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                            
                            self.homeDtoList = self.homescreenDto.calendarData;
                            self.totalPageCounts = self.homescreenDto.pageable.totalCalendarCounts;
                            self.dataTableViewCellProtocolDelegate.refreshInnerTable();
                            
                            //self.dataTableViewCellProtocolDelegate.scrollTableToDesiredIndex(sectionIndex: HomeManager().getScrollIndexFromMonthKey(homeDataList: self.homeDtoList, key: self.homescreenDto.monthScrollIndex["\(compos.month!)-\(compos.year!)"]!));
                            
                        }
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
        
        let queryStr = "userId=\(String(self.loggedInUser.userId))&status=\(status)&timestamp=\(String(homescreenDto.timestampForInvitationTabs))&pageNumber=\(String(pageNumber))&offSet=\(String(offSet))";
        
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
                        self.homeFSCalendarTableViewCellDelegate.fsCalendar.adjustMonthPosition();
                        
                    }
                }
                
            } else {
                //Show Empty Screen
            }

        }
    }
    
    func loadGatheringDataByPullDown(status: String, pageNumber: Int, offSet: Int) -> Void {
        
        let queryStr = "userId=\(String(self.loggedInUser.userId))&status=\(status)&timestamp=\(String(homescreenDto.timestampForInvitationTabs))&pageNumber=\(String(pageNumber))&offSet=\(String(offSet))";
        
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
        
        self.homescreenDto.calendarEventsData = CalendarEventsData();
        
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
        
        
        var key = Date(milliseconds: Int(homescreenDto.timeStamp)).EMMMd()!;
        let components =  Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        let componentStart = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(homescreenDto.timeStamp)) )
        if(components.day == componentStart.day && components.month == componentStart.month && components.year == componentStart.year){
            key = "Today " + key;
        }else if((components.day!+1) == componentStart.day && components.month == componentStart.month && components.year == componentStart.year){
            key = "Tomorrow " + key;
        }
        
        var sectionIndex = 0;
        for homeDto in self.homeDtoList {
    
            if (homeDto.sectionName == key) {
                self.dataTableViewCellProtocolDelegate.scrollTableToDesiredIndex(sectionIndex: sectionIndex);
                break;
            }
            sectionIndex = sectionIndex + 1;
        }
    }
    
    func initilizeCalendarData() {
        
        homescreenDto.pageable.calendarDataPageNumber = 0;
        homescreenDto.calendarData = [HomeData]();
        homescreenDto.fsCalendarCurrentDateTimestamp = Int(Date().millisecondsSince1970);
        //self.loadHomeData(pageNumber: homescreenDto.pageable.calendarDataPageNumber, offSet: homescreenDto.pageable.calendarDataOffset);
        //self.loadPastEvents();
        
        
        //let currentMonth = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
        self.homescreenDto.pageableMonthToAdd = 0;
        self.homescreenDto.pageableMonthTimestamp = Int(Date().millisecondsSince1970);
        self.homescreenDto.pageable.totalCalendarCounts = 0;
        self.homescreenDto.topHeaderDateIndex = [String: MonthScrollDto]();
        self.homescreenDto.monthTrackerForDataLoad = [String]();
        self.homescreenDto.monthScrollIndex = [String: MonthScrollDto]();
        self.homescreenDto.totalEventsList = [Int32]();
        self.homescreenDto.monthSeparatorList = [String]();
    
        //self.getMonthPageEvents(compos: currentMonth, startimeStamp: Int(Date().startOfMonth().millisecondsSince1970), endtimeStamp: Int(Date().endOfMonth().millisecondsSince1970), scrollType: HomeScrollType.CALENDARSCROLL);
        
        print("Loading home data by Page Wise....")
        //self.loadHomeData(pageNumber: 0, offSet: 20);
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
        self.totalPageCounts = self.homescreenDto.pageable.totalCalendarCounts;

        self.setUpNavBarImages();
        
        self.homeTableView.reloadData();
        self.dataTableViewCellProtocolDelegate.refreshInnerTable();
        
        if (self.homescreenDto.scrollToMonthStartSectionAtHomeButton.count > 0) {
            self.dateDroDownCellProtocolDelegate.updateDate(milliseconds: self.homescreenDto.scrollToMonthStartSectionAtHomeButton[0].timestamp);
            if (self.homeFSCalendarCellProtocol != nil) {
                self.homeFSCalendarCellProtocol.updateCalendarToTodayMonth();
            }
            self.dataTableViewCellProtocolDelegate.scrollTableToDesiredIndex(sectionIndex: HomeManager().getScrollIndexForTodaysEvent(homeDataList: self.homeDtoList, key: self.homescreenDto.scrollToMonthStartSectionAtHomeButton[0]))
        }
        
    }
    
    @objc func invitationTabPressed() {
        self.homescreenDto.headerTabsActive = HomeHeaderTabs.InvitationTab;
        
        //self.dataTableViewCellProtocolDelegate.addRemoveSubViewOnHeaderTabSelected(selectedTab: HomeHeaderTabs.InvitationTab);

        self.homescreenDto.homeRowsVisibility[HomeRows.ThreeTabs] = true;
        self.homescreenDto.invitationTabs = HomeInvitationTabs.Accepted;
        self.homeDtoList = homescreenDto.acceptedGatherings;
        self.totalPageCounts = self.homescreenDto.pageable.totalAcceptedCounts;
        
        self.setUpNavBarImages();
        self.homeTableView.reloadData()
        self.dataTableViewCellProtocolDelegate.reloadTableToTop();
        //self.loadGatheringDataByStatus(status: "Going");
    }
    
    @objc func plusButtonPressed() {
        let friendsViewController: FriendsViewController = storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
        navigationController?.pushViewController(friendsViewController, animated: true)
    }

    @objc func refreshButtonPressed() {

        self.view.isUserInteractionEnabled = false;
        self.activityIndicator.startAnimating();
        self.refreshCalButton.startRotating(duration: 0.5, repeatCount: 1, clockwise: true);
        
        self.tabBarController?.tabBar.isUserInteractionEnabled = false;
        self.calendrStatusToast.alpha = 1
        self.calendrStatusToast.isHidden = false;
        self.calendrStatusToast.text = "Syncing calendar...";

        var isRefreshDone: [String: Bool] = [String: Bool]();
        let queryStr = "userId=\(String(self.loggedInUser.userId))";
        HomeService().getSyncGoogleCalendar(queryStr: queryStr, token: self.loggedInUser.token, complete: {(response) in
            //self.activityIndicator.stopAnimating();
            
            isRefreshDone["Google"] = true;
            if (isRefreshDone.count == 3) {
                self.refreshCalButton.stopRotating();
                self.activityIndicator.stopAnimating();
                self.view.isUserInteractionEnabled = true;
                self.tabBarController?.tabBar.isUserInteractionEnabled = true;

                self.refreshHomeScreenData();
                
                self.calendrStatusToast.text  = "Done";
                UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
                    self.calendrStatusToast.alpha = 0.0
                }, completion: {(isCompleted) in
                    self.calendrStatusToast.isHidden = true;
                })
            }
            
        });

        HomeService().getSyncOutlookCalendar(queryStr: queryStr, token: self.loggedInUser.token, complete: {(response) in
            
            isRefreshDone["Outlook"] = true;
            if (isRefreshDone.count == 3) {
                self.refreshCalButton.stopRotating();
                self.activityIndicator.stopAnimating();
                self.view.isUserInteractionEnabled = true;
                self.tabBarController?.tabBar.isUserInteractionEnabled = true;

                self.refreshHomeScreenData();
                
                self.calendrStatusToast.text  = "Done";
                UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
                    self.calendrStatusToast.alpha = 0.0
                }, completion: {(isCompleted) in
                    self.calendrStatusToast.isHidden = true;
                })
            }
        });
        
        var params : [String:Any]
        let eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        let name = "\(String(loggedInUser.name.split(separator: " ")[0]))'s iPhone";
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            
            if (granted) && (error == nil) {
                
                print("granted \(granted)")
                print("error \(error)")
                
                let calendar = Calendar.current
                
                var datecomponent = DateComponents()
                datecomponent.year = 1
                var endDate = calendar.date(byAdding: datecomponent, to: Date())
                
                let calendars = eventStore.calendars(for: .event)
                
                var newCalendar = [EKCalendar]()
                
                for calendar in calendars {
                    if calendar.title == "Work" || calendar.title == "Home"{
                        //      newCalendar.append(calendar)
                    }
                    newCalendar.append(calendar)
                }
                
                
                
                let predicate = eventStore.predicateForEvents(withStart: Date(), end: endDate!, calendars: newCalendar)
                
                let eventArray = eventStore.events(matching: predicate)
                
                if eventArray.count > 0 {
                    
                    var arrayDict = [NSMutableDictionary]()
                    
                    for event  in eventArray {
                        
                        let event = event as EKEvent
                        
                        
                        if (event.isAllDay == true) {
                            continue;
                        }
                        let title = event.title
                        
                        let location = event.location
                        
                        var description = ""
                        if let desc = event.notes{
                            description = desc
                        }
                        
                        let startTime = "\(event.startDate.millisecondsSince1970)"
                        let endTime = "\(event.endDate.millisecondsSince1970)"
                        
                        let nowDateMillis = Date().millisecondsSince1970
                        
                        var postData: NSMutableDictionary = ["title":title!,"description":description,"location":location!,"source":"Apple","createdById":"\(self.loggedInUser.userId!)","timezone":"\(TimeZone.current.identifier)","scheduleAs":"Event","startTime":startTime,"endTime":endTime,"sourceEventId":"\(event.eventIdentifier!)\(startTime)"]
                        
                        if (event.startDate.millisecondsSince1970 < nowDateMillis) {
                            
                            postData["processed"] = "\(1)";
                            arrayDict.append(postData)
                        } else {
                            
                            postData["processed"] = "\(0)";
                            arrayDict.append(postData)
                        }
                        
                    }
                    
                    var params =  [String:Any]();
                    params["data"]  = arrayDict;
                    params["userId"] = self.loggedInUser.userId;
                    params["name"] = name;
                    
                    //Running In Background
                    //DispatchQueue.global(qos: .background).async {
                    // your code here
                    UserService().refreshDeviceEvents(postData: params, token: self.loggedInUser.token, complete: {(response) in
                        print("Device Synced.")
                        
                        isRefreshDone["Apple"] = true;
                        if (isRefreshDone.count == 3) {
                            self.refreshCalButton.stopRotating();
                            self.activityIndicator.stopAnimating();
                            self.view.isUserInteractionEnabled = true;
                            self.tabBarController?.tabBar.isUserInteractionEnabled = true;

                            self.refreshHomeScreenData();
                            
                            self.calendrStatusToast.text  = "Done";
                            UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
                                self.calendrStatusToast.alpha = 0.0
                            }, completion: {(isCompleted) in
                                self.calendrStatusToast.isHidden = true;
                            })
                        }
                        
                    })
                    //}
                }
            }
        }
    }
        /*self.spinnerBtn.startAnimate(spinnerType: SpinnerType.lineSpinFade, spinnercolor: UIColor.red, spinnerSize: 20, complete: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.spinnerBtn.stopAnimate(complete: nil);
            })

        })*/
 
 
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (self.homeDtoList.count > 0) {
            if (self.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                
                
                self.homescreenDto.timeStamp = Int(Date().millisecondsSince1970);
                self.dateDroDownCellProtocolDelegate.updateDate(milliseconds: self.homescreenDto.scrollToMonthStartSectionAtHomeButton[0].timestamp);
                if (self.homeFSCalendarCellProtocol != nil) {
                    self.homeFSCalendarCellProtocol.updateCalendarToTodayMonth();
                }
                /*if (currentDateSectionIndex != 0) {
                    self.dataTableViewCellProtocolDelegate.scrollTableToDesiredIndex(sectionIndex: self.currentDateSectionIndex)
                } else {
                    self.dataTableViewCellProtocolDelegate.scrollTableToDesiredIndex(sectionIndex: self.homescreenDto.scrollToSectionIndex)
                }*/
                self.dataTableViewCellProtocolDelegate.scrollTableToDesiredIndex(sectionIndex: HomeManager().getScrollIndexForTodaysEvent(homeDataList: self.homeDtoList, key: self.homescreenDto.scrollToMonthStartSectionAtHomeButton[0]))
                
                
            } else {
                self.dataTableViewCellProtocolDelegate.reloadTableToTop();
            }
        } else {
            self.homescreenDto.timeStamp = Int(Date().millisecondsSince1970);
            self.dateDroDownCellProtocolDelegate.updateDate(milliseconds: Int(Date().millisecondsSince1970));
            if (self.homeFSCalendarCellProtocol != nil) {
                self.homeFSCalendarCellProtocol.updateCalendarToTodayMonth();
            }
        }
    }
}
