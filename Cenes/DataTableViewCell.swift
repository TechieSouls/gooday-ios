//
//  DataTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 27/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import SwipeCellKit

class DataTableViewCell: UITableViewCell, DataTableViewCellProtocol {
    
    private let refreshControl = UIRefreshControl()

    @IBOutlet weak var dataTableView: UITableView!
    
    var newHomeViewControllerDelegate: NewHomeViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerTableCells();
       
        
        refreshControl.tag = 1001;
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerTableCells() ->Void {
        dataTableView.register(UINib(nibName: "GatheringCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringCardTableViewCell");
        dataTableView.register(UINib(nibName: "HomeEventTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeEventTableViewCell");

        dataTableView.register(UINib(nibName: "GatheringCardHeaderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringCardHeaderTableViewCell");
        
        dataTableView.register(UINib(nibName: "NoGatheringTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NoGatheringTableViewCell");
        
        dataTableView.register(UINib(nibName: "HomeCalendarTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeCalendarTableViewCell");
        dataTableView.register(UINib(nibName: "HomeHolidayTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeHolidayTableViewCell");
        
        dataTableView.register(UINib(nibName: "MonthSeparatorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MonthSeparatorTableViewCell");
        
        
        //homeTableView.register(UINib(nibName: "InvitationTabsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InvitationTabsTableViewCell");
        
        //homeTableView.register(UINib(nibName: "DataTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DataTableViewCell");
        //dataTableView.scrollsToTop = true;
    }
    
    func reloadTableToTop() {
        //dataTableView.scrollsToTop = true;
        if (newHomeViewControllerDelegate.homeDtoList.count > 0) {
            let indexPath = IndexPath(row: 0, section: 0)
            dataTableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        }
    }
    
    func adjustInsets() {
        
        let tableHeight = self.dataTableView.frame.height + 20
        let table40pcHeight = tableHeight / 100 * 40
        
        let bottomInset = tableHeight - table40pcHeight - 90
        let topInset = table40pcHeight
        
        self.dataTableView.contentInset = UIEdgeInsetsMake(topInset, 0, bottomInset, 0)
    }

    func reloadTableToDesiredSection(rowsToAdd: Int, sectionIndex: Int) {
        //dataTableView.scrollsToTop = true;
            if (newHomeViewControllerDelegate.homeDtoList.count > 0) {
            
            /*
            guard case self.dataTableView = self.dataTableView else {
                return
            }
            let currentOffset = self.dataTableView.contentOffset
            let yOffset = CGFloat(rowsToAdd) * 10 // MAKE SURE YOU SET THE ROW HEIGHT OTHERWISE IT WILL BE ZERO!!!
            let newOffset = CGPoint(x: currentOffset.x, y: currentOffset.y + yOffset)
            self.dataTableView.reloadData()
            self.dataTableView.setContentOffset(newOffset, animated: false)
            */
            self.dataTableView.delegate = self;
            self.dataTableView.reloadData()
            self.dataTableView.layoutIfNeeded()
                
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: 0, section: sectionIndex)
                self.dataTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    func refreshInnerTable() {
        dataTableView.reloadData();
    }
    
    func scrollTableToDesiredIndex(sectionIndex: Int) {
        let indexPath = IndexPath(row: 0, section: sectionIndex)
        dataTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func addRemoveSubViewOnHeaderTabSelected(selectedTab: String) {
    
        if (selectedTab == HomeHeaderTabs.CalendarTab) {
            for subView in dataTableView.subviews {
                if (subView.tag == 1001) {
                    subView.removeFromSuperview();
                }
            }
        } else {
            // Add Refresh Control to Table View
            dataTableView.addSubview(refreshControl)

/*            if #available(iOS 10.0, *) {
                dataTableView.refreshControl = refreshControl
            } else {
                dataTableView.addSubview(refreshControl)
            }*/
        }
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        //fetchWeatherData()
        newHomeViewControllerDelegate.homescreenDto.acceptedGatherings = [HomeData]();
        newHomeViewControllerDelegate.homescreenDto.pendingGatherings = [HomeData]();
        newHomeViewControllerDelegate.homescreenDto.declinedGatherings = [HomeData]();

        newHomeViewControllerDelegate.loadGatheringDataByPullDown(status: "Going", pageNumber: 0, offSet: 20)
        newHomeViewControllerDelegate.loadGatheringDataByPullDown(status: "Pending", pageNumber: 0, offSet: 20)
        newHomeViewControllerDelegate.loadGatheringDataByPullDown(status: "NotGoing", pageNumber: 0, offSet: 20)
        self.refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.newHomeViewControllerDelegate.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab && self.newHomeViewControllerDelegate.homeDtoList.count > 0) {
            let tableView = scrollView as! UITableView;
            
            let indexPath = tableView.indexPathsForVisibleRows![0];
            let homeDto = self.newHomeViewControllerDelegate.homeDtoList[indexPath.section];
            if (tableView.indexPathsForVisibleRows!.count > 0) {
                
                if (homeDto.sectionObjects[0].scheduleAs != "MonthSeparator") {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "E MMMM d yyyy";
                    let dateObj = dateFormatter.date(from: homeDto.sectionNameWithYear);
                    
                    let monthDateFormatter = DateFormatter()
                    monthDateFormatter.dateFormat = "MMMM";
                    let monthstr = monthDateFormatter.string(from: dateObj!);
                    
                    let yearDateFormatter = DateFormatter()
                    yearDateFormatter.dateFormat = "yyyy";
                    let yearStr = yearDateFormatter.string(from: dateObj!);
                    
                    var topDatekey = "";
                    for (key, value) in self.newHomeViewControllerDelegate.homescreenDto.topHeaderDateIndex {
                        if (key.contains(monthstr) && key.contains(yearStr)) {
                            topDatekey = key;
                            break;
                        }
                    }
                    
                    if (topDatekey != "" && self.newHomeViewControllerDelegate.homescreenDto.topHeaderDateIndex[topDatekey] != nil) {
                        //print("Hehahahah ahahahah ahahha ahahahaha  hhhh",homeDto.sectionName!);
                        var monthDto = self.newHomeViewControllerDelegate.homescreenDto.topHeaderDateIndex[topDatekey];
                        if (monthDto != nil) {
                           
                            
                            
                            let componentsForScrollDate = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: monthDto!.timestamp));
                            
                           let componentsForTopHeaderDate =  Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: self.newHomeViewControllerDelegate.homescreenDto.timestampForTopHeader));
                           
                            //This condition is needed, becuse theer may be multiple headres for that months and
                            //after page scroll, a header may give same month and upddate top header date again.
                            if (componentsForScrollDate.month != componentsForTopHeaderDate.month) {
                            self.newHomeViewControllerDelegate.dateDroDownCellProtocolDelegate.updateDate(milliseconds: monthDto!.timestamp);
                                
                                self.newHomeViewControllerDelegate.homescreenDto.timestampForTopHeader = monthDto!.timestamp;
                            }
                            

                        }
                    }
                }

            }
            
                        
        }
    }
    
    @objc func profilePicTapped(sender: UITapGestureRecognizer) {
        
        let viewContro = self.newHomeViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "ImagePanableViewController") as! ImagePanableViewController;
        viewContro.profilePicEnlargedTemp = sender.view as! UIImageView;
        self.newHomeViewControllerDelegate.present(viewContro, animated: true, completion: nil);
        
    }
}

extension DataTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (newHomeViewControllerDelegate.homeDtoList.count == 0) {
            return 1;
        }
        return newHomeViewControllerDelegate.homeDtoList.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (newHomeViewControllerDelegate.homeDtoList.count == 0) {
            return 1;
        }
        return newHomeViewControllerDelegate.homeDtoList[section].sectionObjects.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (newHomeViewControllerDelegate.homeDtoList.count != 0) {

            //print("section", indexPath.section, "Row: ",indexPath.row)
            
            let totalRows = self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects.count;
           let event = self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects[indexPath.row];
            print(event);
            if (newHomeViewControllerDelegate.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                
                if (event.scheduleAs == "Gathering") {
                    let cell: HomeEventTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "HomeEventTableViewCell") as! HomeEventTableViewCell;
                    
                    print(event.title);
                    cell.title.text = event.title;
                    cell.location.text = event.location;
                    cell.time.text = String(Date(milliseconds: Int(event.startTime)).hmma());
                    
                    var host = EventMember();
                    if (event.eventMembers != nil && event.eventMembers.count > 0) {
                        print("Event Member Counts : ",event.eventMembers!.count);
                        for eventMem in event.eventMembers {
                            if (eventMem.userId != nil && eventMem.userId == event.createdById) {
                                host = eventMem;
                                break;
                            }
                        }
                    }

                    if (host.user != nil) {
                        if (host.user!.photo != nil) {
                            cell.profileImage.sd_setImage(with: URL(string: host.user!.photo!), placeholderImage: UIImage(named: "profile_pic_no_image"));
                        } else {
                            cell.profileImage.image = UIImage(named: "profile_pic_no_image");
                        }
                    }
                    
                    let imageTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(profilePicTapped(sender:)));
                    cell.profileImage.isUserInteractionEnabled = true;
                    cell.profileImage.addGestureRecognizer(imageTapGesture);
                    
                    if (totalRows > 1 && indexPath.row == (totalRows - 2)) {
                        
                        let eventTemp = self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects[indexPath.row + 1];
                        if (eventTemp.scheduleAs == "MonthSeparator") {
                            cell.separator.isHidden = true;
                        } else {
                            cell.separator.isHidden = false;
                        }
                        
                    } else if (indexPath.row == (totalRows - 1)) {
                        cell.separator.isHidden = true;
                    } else {
                        cell.separator.isHidden = false;
                    }
                    return cell;
                } else if (event.scheduleAs == "Event") {
                    let cell: HomeCalendarTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "HomeCalendarTableViewCell") as! HomeCalendarTableViewCell;
                    
                    cell.calendarTitle.text = event.title!;
                    cell.calendarTime.text = String(Date(milliseconds: Int(event.startTime)).hmma());
                    if (event.source == "Google") {
                        cell.calendarType.text = "Google"
                        cell.roundedViewLabel.text = "G";
                    } else if (event.source == "Outlook") {
                        cell.calendarType.text = "Outlook"
                        cell.roundedViewLabel.text = "O";
                    } else if (event.source == "Apple") {
                        cell.calendarType.text = "Apple"
                        cell.roundedViewLabel.text = "A";
                    }
                    
                    if (totalRows > 1 && indexPath.row == (totalRows - 2)) {
                        
                        let eventTemp = self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects[indexPath.row + 1];
                        if (eventTemp.scheduleAs == "MonthSeparator") {
                            cell.separator.isHidden = true;
                        } else {
                            cell.separator.isHidden = false;
                        }
                        
                    } else if (indexPath.row == (totalRows - 1)) {
                        cell.separator.isHidden = true;
                    } else {
                        cell.separator.isHidden = false;
                    }
                    return cell;
                } else if (event.scheduleAs == "Holiday") {
                    let cell: HomeHolidayTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "HomeHolidayTableViewCell") as! HomeHolidayTableViewCell;
                    
                    cell.holidayLabel.text = event.title!;
                    return cell;
                }  else if (event.scheduleAs == "MonthSeparator") {
                    let cell: MonthSeparatorTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "MonthSeparatorTableViewCell") as! MonthSeparatorTableViewCell;
                    
                    cell.monthSeparatorLabel.text = event.title!;
                    return cell;
                }
                
            } else if (newHomeViewControllerDelegate.homescreenDto.headerTabsActive == HomeHeaderTabs.InvitationTab) {
                let cell: GatheringCardTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "GatheringCardTableViewCell") as! GatheringCardTableViewCell;
                
                cell.newHomeViewControllerDelegate = newHomeViewControllerDelegate;
                cell.title.text = event.title;
                cell.location.text = event.location;
                
                var host: EventMember!;
                if (event.eventMembers != nil) {
                    for eventMem in event.eventMembers! {
                        if (eventMem.userId != nil && eventMem.userId != 0 && eventMem.userId == event.createdById) {
                            host = eventMem;
                            break;
                        }
                    }

                }

                if (host != nil && host.user != nil) {
                    if (newHomeViewControllerDelegate.loggedInUser.userId == host.userId) {
                        cell.ownerLabel.text = "Me";
                    } else {
                        if (host.user != nil && host.user!.name != nil) {
                            cell.ownerLabel.text = String(host.user!.name!.split(separator: " ")[0]);
                        } else {
                            cell.ownerLabel.text = String(host.name!.split(separator: " ")[0]);
                        }
                    }
                    
                    if (host.user!.photo != nil){
                        cell.profilePic.sd_setImage(with: URL(string: host.user!.photo!), placeholderImage: UIImage(named: "profile_pic_no_image"));
                    } else {
                        cell.profilePic.image = UIImage.init(named: "profile_pic_no_image");
                    }
                }
                
                let timeLabel = "\(String(Date(milliseconds: Int(event.startTime)).hmma()))-\(String(Date(milliseconds: Int(event.endTime)).hmma()))"
                cell.timeLabel.text = timeLabel;
                
                var eventMembersWithoutHost: [EventMember] = [EventMember]();
                if (event.eventMembers != nil) {
                    for eventMem in event.eventMembers! {
                        
                        if (eventMem.userId != nil && eventMem.userId != 0 && eventMem.userId != event.createdById) {
                            eventMembersWithoutHost.append(eventMem);
                        }
                    }

                }
                cell.members = eventMembersWithoutHost;
                
                var acceptedMembers = [EventMember]();
                //Addding all event members without logged in user
                if (event.eventMembers != nil) {
                    for eventMem in event.eventMembers! {
                        if (eventMem.userId != nil && eventMem.userId != 0 && eventMem.userId != event.createdById && eventMem.userId != newHomeViewControllerDelegate.loggedInUser.userId && eventMem.status == "Going") {
                            acceptedMembers.append(eventMem);
                        }
                    }
                    
                    //Adding Logged in event member at last
                    for eventMem in event.eventMembers! {
                        if (eventMem.userId != nil && eventMem.userId != 0 && eventMem.userId != event.createdById && eventMem.userId == newHomeViewControllerDelegate.loggedInUser.userId && eventMem.status == "Going") {
                            acceptedMembers.append(eventMem);
                        }
                    }
                }
                cell.acceptedMembers = acceptedMembers;
                cell.membersCollectionView.reloadData();
                print(event.title, cell.members.count)
                return cell;
            }
            
        } else {
            if (newHomeViewControllerDelegate.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                let cell: NoGatheringTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "NoGatheringTableViewCell") as! NoGatheringTableViewCell;
                cell.newHomeViewControllerDelegate = newHomeViewControllerDelegate;
                return cell;
            }
            
        }
        
        var noCell = UITableViewCell();
        noCell.selectionStyle = .none;
        return noCell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (newHomeViewControllerDelegate.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
            return 90;
        }
        return 200;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return newHomeViewControllerDelegate.homeDtoList[section].sectionName;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.newHomeViewControllerDelegate != nil && self.newHomeViewControllerDelegate.homeDtoList.count > 0) {
            let cell: GatheringCardHeaderTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "GatheringCardHeaderTableViewCell") as! GatheringCardHeaderTableViewCell;
            
            let event = self.newHomeViewControllerDelegate.homeDtoList[section].sectionObjects[0];
            if (event.scheduleAs == "MonthSeparator") {
                cell.headerLabel.text = "";

            } else {
                cell.headerLabel.text = self.newHomeViewControllerDelegate.homeDtoList[section].sectionName

            }
                return cell;
        }
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (self.newHomeViewControllerDelegate != nil && self.newHomeViewControllerDelegate.homeDtoList.count > 0) {
            let event = self.newHomeViewControllerDelegate.homeDtoList[section].sectionObjects[0];
            if (event.scheduleAs == "MonthSeparator") {
                return 0;
            }
        }
        return 30;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.newHomeViewControllerDelegate.homescreenDto.headerTabsActive == HomeHeaderTabs.InvitationTab &&  self.newHomeViewControllerDelegate.homescreenDto.invitationTabs == HomeInvitationTabs.Pending &&  self.newHomeViewControllerDelegate.homeDtoList.count > 0) {
            let viewController = self.newHomeViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "GatheringInvitationViewController") as! GatheringInvitationViewController;
            let eventObjectSelected = self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects[indexPath.row];
            
            var pendingEvents = [Event]();
            var isEventFound = false;
            for homeData in self.newHomeViewControllerDelegate.homeDtoList {
                for event in homeData.sectionObjects {
                    if (event.eventId == eventObjectSelected.eventId) {
                        isEventFound = true
                    }
                    if (isEventFound == true) {
                        pendingEvents.append(event);
                    }
                }
            }
            
            isEventFound = false;
            for homeData in self.newHomeViewControllerDelegate.homeDtoList {
                for event in homeData.sectionObjects {
                    if (event.eventId == eventObjectSelected.eventId) {
                        isEventFound = true
                        break;
                    }
                    if (isEventFound == false) {
                        event.eventClickedFrom = EventClickedFrom.Gathering;
                        pendingEvents.append(event);
                    }
                }
            }
            
            viewController.pendingEvents = pendingEvents;
            viewController.pendingEventIndex = 0;
            viewController.newHomeViewControllerDeglegate = self.newHomeViewControllerDelegate
            self.newHomeViewControllerDelegate.navigationController?.pushViewController(viewController, animated: true);
        } else {
            if (self.newHomeViewControllerDelegate.homeDtoList.count > 0) {
                let event = self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects[indexPath.row];
                if (event.scheduleAs == "Gathering") {
                    
                    event.eventClickedFrom = EventClickedFrom.Gathering;
                    
                    /*if (event.expired == true) {
                        
                        let viewController = self.newHomeViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "GatheringExpiredViewController") as! GatheringExpiredViewController;
                        self.newHomeViewControllerDelegate.navigationController?.pushViewController(viewController, animated: true);
                        //self.newHomeViewControllerDelegate.present(viewController, animated: true, completion: nil);
                        
                    } else {*/
                        let viewController = self.newHomeViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "GatheringInvitationViewController") as! GatheringInvitationViewController;
                        
                        viewController.event = Event().copyDataToNewEventObject(event: event);
                        if (viewController.event.eventMembers != nil && viewController.event.eventMembers.count > 0) {
                            for eventMem in viewController.event.eventMembers {
                                print(eventMem.name);
                            }
                        }
                    //viewController.event = EventModel().copyDataToNewEventObject(event: event, context: self.newHomeViewControllerDelegate.context!);
                        viewController.newHomeViewControllerDeglegate = self.newHomeViewControllerDelegate;
                        self.newHomeViewControllerDelegate.navigationController?.pushViewController(viewController, animated: true);
                    //}
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            
            // print("this is the last cell")
            var gatheringsCount: Int = 0;
            for homeData in self.newHomeViewControllerDelegate.homeDtoList {
                gatheringsCount = gatheringsCount + homeData.sectionObjects.count;
            };
            print("Gatheinrg Count : ", gatheringsCount, "total Page Counts", self.newHomeViewControllerDelegate.totalPageCounts)
            if (gatheringsCount < self.newHomeViewControllerDelegate.totalPageCounts) {
                //self.spinner.startAnimating()
                //self.spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                
                //self.dataTableView.tableFooterView = self.spinner
                //self.dataTableView.tableFooterView?.isHidden = false
                
                if (self.newHomeViewControllerDelegate.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                                        
                    self.newHomeViewControllerDelegate.loadHomeData(pageNumber: self.newHomeViewControllerDelegate.homescreenDto.pageable.calendarDataPageNumber, offSet: self.newHomeViewControllerDelegate.homescreenDto.pageable.calendarDataOffset)
                    
                    /*let newDate = Calendar.current.date(byAdding: .month, value: self.newHomeViewControllerDelegate.homescreenDto.pageableMonthToAdd, to: Date(milliseconds: self.newHomeViewControllerDelegate.homescreenDto.pageableMonthTimestamp))!;
                    
                    let dateComponentsOfPageableMonth = Calendar.current.dateComponents(in: TimeZone.current, from: newDate)
                    let startTimestamp: Int = Int(newDate.startOfMonth().millisecondsSince1970);
                    let endTimestamp: Int = Int(newDate.endOfMonth().millisecondsSince1970);
                    
                    self.newHomeViewControllerDelegate.homescreenDto.pageableMonthToAdd = 1;
                    self.newHomeViewControllerDelegate.homescreenDto.pageableMonthTimestamp = startTimestamp;
                    self.newHomeViewControllerDelegate.getMonthPageEvents(compos: dateComponentsOfPageableMonth, startimeStamp: startTimestamp, endtimeStamp: endTimestamp, scrollType: HomeScrollType.PAGESCROLL);*/
                } else {
                    
                    if (self.newHomeViewControllerDelegate.homescreenDto.invitationTabs == HomeInvitationTabs.Accepted) {
                        
                        self.newHomeViewControllerDelegate.homescreenDto.pageable.acceptedGathetingPageNumber = self.newHomeViewControllerDelegate.homescreenDto.pageable.acceptedGathetingPageNumber + 20;
                        
                        self.newHomeViewControllerDelegate.loadGatheringDataByStatus(status: "Going", pageNumber: self.newHomeViewControllerDelegate.homescreenDto.pageable.acceptedGathetingPageNumber, offSet: self.newHomeViewControllerDelegate.homescreenDto.pageable.acceptedGatheringOffset);
                        
                    } else if (self.newHomeViewControllerDelegate.homescreenDto.invitationTabs == HomeInvitationTabs.Pending) {
                        
                        self.newHomeViewControllerDelegate.homescreenDto.pageable.pendingGathetingPageNumber = self.newHomeViewControllerDelegate.homescreenDto.pageable.pendingGathetingPageNumber + 20;
                        
                        self.newHomeViewControllerDelegate.loadGatheringDataByStatus(status: "Pending", pageNumber: self.newHomeViewControllerDelegate.homescreenDto.pageable.pendingGathetingPageNumber, offSet: self.newHomeViewControllerDelegate.homescreenDto.pageable.pendingGatheringOffset);
                        
                    } else if (self.newHomeViewControllerDelegate.homescreenDto.invitationTabs == HomeInvitationTabs.Declined) {
                        
                        self.newHomeViewControllerDelegate.homescreenDto.pageable.declinedGathetingPageNumber = self.newHomeViewControllerDelegate.homescreenDto.pageable.declinedGathetingPageNumber + 20;
                        
                        
                        self.newHomeViewControllerDelegate.loadGatheringDataByStatus(status: "NotGoing", pageNumber: self.newHomeViewControllerDelegate.homescreenDto.pageable.declinedGathetingPageNumber, offSet: self.newHomeViewControllerDelegate.homescreenDto.pageable.declinedGatheringOffset);
                    }
                    
                } //Invitation tab flow ends
            
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if (newHomeViewControllerDelegate.homeDtoList.count != 0 && Connectivity.isConnectedToInternet) {
            
            let event = newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects[indexPath.row];
            
            if (newHomeViewControllerDelegate.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                
                if (event.scheduleAs == "Gathering") {
                    
                    if (newHomeViewControllerDelegate.loggedInUser.userId == event.createdById) {
                        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
                            
                            let eventId = event.eventId;
                            
                            var sectionEvents = self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects;
                            sectionEvents.remove(at: indexPath.row);
                            if (sectionEvents.count == 0) {
                                self.newHomeViewControllerDelegate.homeDtoList.remove(at: indexPath.section);
                            } else {
                                self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects = sectionEvents;
                            }
                            
                            EventModel().deleteEventByEventId(eventId: eventId!);                      EventMemberModel().deleteEventMemberMOModelByEventId(eventId: eventId!);
                            NotificationModel().deleteNotificationByNotificationId(eventId: eventId!);

                            let eventMoTemp = EventModel().fetchOfflineEventByEventId(eventId: eventId!);
                            print(eventMoTemp.description)
                            self.newHomeViewControllerDelegate.homeTableView.reloadData();
                            
                            let queryStr = "event_id=\(eventId!)";
                            HomeService().removeEventFromList(queryStr: queryStr, token: self.newHomeViewControllerDelegate.loggedInUser.token, complete: {(response) in
                                
                                self.newHomeViewControllerDelegate.refreshHomeScreenData();
                            });
                            
                            
                            tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
                            return
                        }
                        deleteButton.backgroundColor = UIColor.red
                        return [deleteButton]
                    } else {
                        let declineButton = UITableViewRowAction(style: .default, title: "Decline") { (action, indexPath) in
                            
                            EventMemberModel().updateEventMemberStatus(eventId: event.eventId, userId: self.newHomeViewControllerDelegate.loggedInUser.userId, status: "NotGoing");
                            
                            let queryStr = "eventId=\(String(event.eventId))&userId=\(String(self.newHomeViewControllerDelegate.loggedInUser.userId))&status=NotGoing";
                            GatheringService().updateGatheringStatus(queryStr: queryStr, token: self.newHomeViewControllerDelegate.loggedInUser.token, complete: {(response) in
                                self.newHomeViewControllerDelegate.refreshHomeScreenData()                            })
                            var sectionEvents = self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects;
                            sectionEvents.remove(at: indexPath.row);
                            if (sectionEvents.count == 0) {
                                self.newHomeViewControllerDelegate.homeDtoList.remove(at: indexPath.section);
                            } else {
                                self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects = sectionEvents;
                            }
                            self.newHomeViewControllerDelegate.homeTableView.reloadData();
                            
                            tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
                            return
                        }
                        declineButton.backgroundColor = UIColor.red
                        return [declineButton]
                    }
                    
                    
                } else if (event.scheduleAs == "Event") {
                    
                    let deleteButton = UITableViewRowAction(style: .default, title: "Hide") { (action, indexPath) in
                        
                        let queryStr = "event_id=\(String(event.eventId))";
                        HomeService().removeEventFromList(queryStr: queryStr, token: self.newHomeViewControllerDelegate.loggedInUser.token, complete: {(response) in
                            
                            self.newHomeViewControllerDelegate.refreshHomeScreenData();
                        });
                        var sectionEvents = self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects;
                        sectionEvents.remove(at: indexPath.row);
                        if (sectionEvents.count == 0) {
                            self.newHomeViewControllerDelegate.homeDtoList.remove(at: indexPath.section);
                        } else {
                            self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects = sectionEvents;
                        }
                        self.newHomeViewControllerDelegate.homeTableView.reloadData();
                        tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
                        return
                    }
                    deleteButton.backgroundColor = UIColor.red
                    return [deleteButton]
                    
                }
            }
        }
        
        return [UITableViewRowAction]();
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {

        }
    }
}
