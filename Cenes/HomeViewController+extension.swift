//
//  HomeViewController+extension.swift
//  Deploy
//
//  Created by Cenes_Dev on 12/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension NewHomeViewController :UITableViewDataSource,UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homescreenDto.homeRowsVisibility.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        /*let event = self.homeDtoList[indexPath.section].sectionObjects[indexPath.row];
        
        if (event.scheduleAs == "Event") {
            let identifier = "HomeCalendarTableViewCell"
            let cell: HomeCalendarTableViewCell! = self.homeTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeCalendarTableViewCell
            cell.calendarType.text = event.source;
            cell.calendarTitle.text = event.title
            return cell;
        } else if (event.scheduleAs == "Gathering") {
            let identifier = "HomeEventTableViewCell"
            let cell: HomeEventTableViewCell! = self.homeTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeEventTableViewCell
                cell.title.text = event.title;
                cell.time.text = Util.hhmma(timeStamp: Date.init(millis: event.startTime).toMillis())
                if (event.location != nil) {
                    cell.location.text = event.location;
                }
            return cell;
        } else if (event.scheduleAs == "Holiday") {
            let identifier = "HomeCalendarTableViewCell"
            let cell: HomeCalendarTableViewCell! = self.homeTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeCalendarTableViewCell
            cell.calendarTitle.text = event.title!
            //cell.calendarTitle.text = event.title
            return cell;
        }*/
        switch indexPath.row {
        case 0:
            if (self.homescreenDto.homeRowsVisibility[HomeRows.TopDateRow] == true) {
                let cell: DateDropDownTableViewCell = self.homeTableView.dequeueReusableCell(withIdentifier: "DateDropDownTableViewCell") as! DateDropDownTableViewCell
                cell.newHomeViewControllerDelegate = self;
                cell.topDate.text = String(Date(milliseconds: Int(self.homescreenDto.fsCalendarCurrentDateTimestamp)).MMMM()!);
                let textWidth = cell.topDate.intrinsicContentSize.width;
                print("textWidth", textWidth);
                cell.topDate.frame = CGRect(x: 0, y: 40/2, width: textWidth, height: 40);
                cell.clanedarToggleArrowVioew.frame = CGRect(x: textWidth+10, y: cell.frame.height/2, width: 26, height: 32);

                if (cell.newHomeViewControllerDelegate.homescreenDto.homeRowsVisibility[HomeRows.CalendarRow] == true) {
                    cell.calendarArrow.image = UIImage.init(named: "open_calendar");
                } else {
                    cell.calendarArrow.image = UIImage.init(named: "close_calendar");
                }
                
                self.dateDroDownCellProtocolDelegate = cell;
                return cell;
            }
        case 1:
            if (self.homescreenDto.homeRowsVisibility[HomeRows.ThreeTabs] == true) {
                let cell: InvitationTabsTableViewCell = self.homeTableView.dequeueReusableCell(withIdentifier: "InvitationTabsTableViewCell") as! InvitationTabsTableViewCell
                cell.newHomeViewControllerDelegate = self;
                cell.activeSelectedTabTab();
                
                return cell;
            }
        case 2:
                let cell: HomeFSCalendarTableViewCell = self.homeTableView.dequeueReusableCell(withIdentifier: "HomeFSCalendarTableViewCell") as! HomeFSCalendarTableViewCell
                cell.newHomeViewProtocolDelegate = self;
                cell.newHomeViewControllerDelegate = self;
                cell.fsCalendar.setCurrentPage(Date(milliseconds: self.homescreenDto.fsCalendarCurrentDateTimestamp), animated: false);
                self.homeFSCalendarCellProtocol = cell;
                self.homeFSCalendarTableViewCellDelegate = cell;
                if (self.homescreenDto.homeRowsVisibility[HomeRows.CalendarRow] == true) {
                    return cell;
                }
        case 3:
            if (self.homescreenDto.homeRowsVisibility[HomeRows.TableRow] == true) {
                    let cell: DataTableViewCell = self.homeTableView.dequeueReusableCell(withIdentifier: "DataTableViewCell") as! DataTableViewCell
                    cell.newHomeViewControllerDelegate = self;
                    self.dataTableViewCellProtocolDelegate = cell;
                
                    if (homescreenDto.headerTabsActive == HomeHeaderTabs.CalendarTab) {
                        dataTableViewCellProtocolDelegate.addRemoveSubViewOnHeaderTabSelected(selectedTab: HomeHeaderTabs.CalendarTab)
                    } else {
                        dataTableViewCellProtocolDelegate.addRemoveSubViewOnHeaderTabSelected(selectedTab: HomeHeaderTabs.InvitationTab)
                    }
                
                    cell.dataTableView.reloadData();
                    return cell;
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell();
    }
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionTitle = self.homeDtoList[section].sectionName as! String
        
        print(sectionTitle);
        
        let identifier = "HomeEventHeaderViewCell"
        let cell: HomeEventHeaderViewCell! = self.homeTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeEventHeaderViewCell
        
        cell.headerLabel.text = sectionTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0;
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            if (self.homescreenDto.homeRowsVisibility[HomeRows.TopDateRow] == true) {
                return HomeRowsHeight.TopDateRowHeight;
            }
            return 0;
        case 1:
            if (self.homescreenDto.homeRowsVisibility[HomeRows.ThreeTabs] == true) {
                return HomeRowsHeight.ThreeTabsRowHeight;
            }
            return 0;
        case 2:
            if (self.homescreenDto.homeRowsVisibility[HomeRows.CalendarRow] == true) {
                return HomeRowsHeight.CalendarRowHeight;
            }
            return 0;
        case 3:
            var finalDataTableViewHeight = self.view.bounds.height - ((self.tabBarController?.tabBar.bounds.height)! + (self.navigationController?.navigationBar.bounds.height)! + 40);
            
                if (self.homescreenDto.homeRowsVisibility[HomeRows.CalendarRow] == true) {
                    finalDataTableViewHeight = finalDataTableViewHeight - HomeRowsHeight.CalendarRowHeight;
                }
                if (self.homescreenDto.homeRowsVisibility[HomeRows.ThreeTabs] == true) {
                    finalDataTableViewHeight = finalDataTableViewHeight - HomeRowsHeight.ThreeTabsRowHeight;
                }
            return finalDataTableViewHeight;
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 0) {
            if (self.homescreenDto.homeRowsVisibility[HomeRows.CalendarRow] == true) {
                self.homescreenDto.homeRowsVisibility[HomeRows.CalendarRow] = false;
            } else {
                self.homescreenDto.homeRowsVisibility[HomeRows.CalendarRow] = true;
            }
            
            self.homeTableView.reloadData();
        }
    }
}
