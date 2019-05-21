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
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            dataTableView.refreshControl = refreshControl
        } else {
            dataTableView.addSubview(refreshControl)
        }
        
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
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        //fetchWeatherData()
        newHomeViewControllerDelegate.homescreenDto.calendarData = [HomeData]();
        newHomeViewControllerDelegate.homescreenDto.acceptedGatherings = [HomeData]();
        newHomeViewControllerDelegate.homescreenDto.pendingGatherings = [HomeData]();
        newHomeViewControllerDelegate.homescreenDto.declinedGatherings = [HomeData]();

        newHomeViewControllerDelegate.loadHomeData(pageNumber: 0, offSet: 20);
        newHomeViewControllerDelegate.loadGatheringDataByPullDown(status: "Going", pageNumber: 0, offSet: 20)
        newHomeViewControllerDelegate.loadGatheringDataByPullDown(status: "Pending", pageNumber: 0, offSet: 20)
        newHomeViewControllerDelegate.loadGatheringDataByPullDown(status: "NotGoing", pageNumber: 0, offSet: 20)
        self.refreshControl.endRefreshing()
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

            let event = newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects[indexPath.row];
            
            if (newHomeViewControllerDelegate.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                
                if (event.scheduleAs == "Gathering") {
                    let cell: HomeEventTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "HomeEventTableViewCell") as! HomeEventTableViewCell;
                    
                    cell.title.text = event.title;
                    cell.location.text = event.location;
                    cell.time.text = String(Date(milliseconds: Int(event.startTime)).hmma());
                    let host = event.getEventHostFromMembers();
                    if (host.user != nil) {
                        if (host.user.photo != nil){
                            cell.profileImage.sd_setImage(with: URL(string: host.user.photo), placeholderImage: UIImage(named: "profile_pic_no_image"));
                        }
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
                    return cell;
                } else if (event.scheduleAs == "Holiday") {
                    let cell: HomeHolidayTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "HomeHolidayTableViewCell") as! HomeHolidayTableViewCell;
                    
                    cell.holidayDate.text = Date(milliseconds: Int(event.startTime)).EMMMd();
                    cell.holidayLabel.text = event.title!;
                    return cell;
                }
                
            } else if (newHomeViewControllerDelegate.homescreenDto.headerTabsActive == HomeHeaderTabs.InvitationTab) {
                let cell: GatheringCardTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "GatheringCardTableViewCell") as! GatheringCardTableViewCell;
                
                cell.newHomeViewControllerDelegate = newHomeViewControllerDelegate;
                cell.title.text = event.title;
                cell.location.text = event.location;
                
                let host = event.getEventHostFromMembers();
                if (host.user != nil) {
                    if (newHomeViewControllerDelegate.loggedInUser.userId == host.userId) {
                        cell.ownerLabel.text = "Me";
                    } else {
                        cell.ownerLabel.text = String(host.user.name.split(separator: " ")[0]);
                    }
                    
                    if (host.user.photo != nil){
                        cell.profilePic.sd_setImage(with: URL(string: host.user.photo), placeholderImage: UIImage(named: "profile_pic_no_image"));
                    } else {
                        cell.profilePic.image = UIImage.init(named: "profile_pic_no_image");
                    }
                }
                
                let timeLabel = "\(String(Date(milliseconds: Int(event.startTime)).hmma()))-\(String(Date(milliseconds: Int(event.endTime)).hmma()))"
                cell.timeLabel.text = timeLabel;
                cell.members = event.getEventMembersWithoutHost();
                cell.acceptedMembers = event.getAcceptedEventMembersWithoutHost(loggedInUserId: newHomeViewControllerDelegate.loggedInUser!.userId);
                cell.membersCollectionView.reloadData();
                print(event.title, cell.members.count)
                return cell;
            }
            
        } else {
            let cell: NoGatheringTableViewCell = self.dataTableView.dequeueReusableCell(withIdentifier: "NoGatheringTableViewCell") as! NoGatheringTableViewCell;
            return cell;
        }
        
        return UITableViewCell();
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
                cell.headerLabel.text = self.newHomeViewControllerDelegate.homeDtoList[section].sectionName
                return cell;
        }
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.newHomeViewControllerDelegate.homescreenDto.invitationTabs == HomeInvitationTabs.Pending) {
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
                        pendingEvents.append(event);
                    }
                }
            }
            
            viewController.pendingEvents = pendingEvents;
            viewController.pendingEventIndex = 0;
            self.newHomeViewControllerDelegate.navigationController?.pushViewController(viewController, animated: true);
        } else {
            let event = self.newHomeViewControllerDelegate.homeDtoList[indexPath.section].sectionObjects[indexPath.row];
            if (event.scheduleAs == "Gathering") {
                let viewController = self.newHomeViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "GatheringInvitationViewController") as! GatheringInvitationViewController;
                viewController.event = event;
                    
                    self.newHomeViewControllerDelegate.navigationController?.pushViewController(viewController, animated: true);
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
            print("Gatheinrg COunt : ", gatheringsCount, "total Page COunts", self.newHomeViewControllerDelegate.totalPageCounts)
            if (gatheringsCount < self.newHomeViewControllerDelegate.totalPageCounts) {
                //self.spinner.startAnimating()
                //self.spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                
                //self.dataTableView.tableFooterView = self.spinner
                //self.dataTableView.tableFooterView?.isHidden = false
                
                if (self.newHomeViewControllerDelegate.homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                    
                    self.newHomeViewControllerDelegate.homescreenDto.pageable.calendarDataPageNumber = self.newHomeViewControllerDelegate.homescreenDto.pageable.calendarDataPageNumber + 20;
                    
                    self.newHomeViewControllerDelegate.loadHomeData(pageNumber: self.newHomeViewControllerDelegate.homescreenDto.pageable.calendarDataPageNumber, offSet: self.newHomeViewControllerDelegate.homescreenDto.pageable.calendarDataOffset)
                    
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
        
        
        if (newHomeViewControllerDelegate.homeDtoList.count != 0) {
            
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
                            self.newHomeViewControllerDelegate.homeTableView.reloadData();
                            
                            let queryStr = "event_id=\(eventId!)";
                            HomeService().removeEventFromList(queryStr: queryStr, token: self.newHomeViewControllerDelegate.loggedInUser.token, complete: {(response) in
                                
                                self.newHomeViewControllerDelegate.refreshHomeScreenData();
                            })
                            
                            tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
                            return
                        }
                        deleteButton.backgroundColor = UIColor.red
                        return [deleteButton]
                    } else {
                        let declineButton = UITableViewRowAction(style: .default, title: "Decline") { (action, indexPath) in
                            
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
                        })
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
