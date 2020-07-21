//
//  CreateGatheringV2ViewController+UITableView.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import GoogleMaps

extension CreateGatheringV2ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 5;
        /*if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] == true) {
            numberOfRows = numberOfRows + 1;
        }
        if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] == true) {
            numberOfRows = numberOfRows + 1;
        }
        if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveInfoRow] == true) {
            numberOfRows = numberOfRows + 1;
        }
        if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] == true) {
            numberOfRows = numberOfRows + 1;
        }*/
        return numberOfRows;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            case 0:
            if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.friendsCollectionRow] == true) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedFriendsCollectionTableViewCell", for: indexPath) as! SelectedFriendsCollectionTableViewCell;
                cell.createGatheringDelegate = self;
                cell.selectedFriendsColView.reloadData();
                return cell;
            }
            case 1:
                if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] == true) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DatePanelTableViewCell", for: indexPath) as! DatePanelTableViewCell;
                    cell.createGatheringDelegate = self;
                    timePickerDoneDelegate = cell;
                    datePanelTableViewCellDelegate = cell;
                
                    if (event.eventId != nil && event.eventId != 0) {
                        cell.startTimeLabel.isHidden = false;
                        cell.startTimeLabel.text = Date(milliseconds: Int(event.startTime)).hmma();
                        
                        
                        cell.endTimeLabel.isHidden = false;
                        cell.endTimeLabel.text = Date(milliseconds: Int(event.endTime)).hmma();
                        
                        let currentYearComponent = Calendar.current.component(.year, from: Date());
                        
                        let startDateYearComponent = Calendar.current.component(.year, from: Date(milliseconds: Int(event.startTime)));
                        cell.dateLabel.isHidden = false;
                        if (currentYearComponent > startDateYearComponent || currentYearComponent < startDateYearComponent) {
                            cell.dateLabel.text = String(Date(milliseconds: Int(event.startTime)).EMMMMdyyyy()!);
                        } else {
                            cell.dateLabel.text = String(Date(milliseconds: Int(event.startTime)).EMMMd()!);
                        }
                    }

                    return cell;
                }
            case 2:
                if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveInfoRow] == true) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PredictiveInfoTableViewCell", for: indexPath) as! PredictiveInfoTableViewCell;
                    
                    return cell;
                }
            case 3:
                if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] == true) {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PredictiveCalendarCellTableViewCell", for: indexPath) as! PredictiveCalendarCellTableViewCell;
            
                    cell.createGatheringDelegate = self;
                    cell.dateClickedProtocolDelegate = datePanelTableViewCellDelegate;
                    predictiveCalendarViewTableViewCellDelegate = cell;
                    return cell;
                }
            case 4:
                if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] == true) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GatheringInfoTableViewCell", for: indexPath) as! GatheringInfoTableViewCell;
                    cell.createGatheringDelegate = self;
                    gatheringInfoCellDelegate = cell
                    gatheringInfoTableViewCellDelegate = cell;
                    
                    if (event.eventId != nil && event.eventId != 0) {
                        
                        cell.locationLabel.isHidden = false;
                        cell.locationLabel.text = event.location;
                        
                        cell.messageLabel.isHidden = false;
                        if (event.description != nil && event.description != "") {
                            cell.messageLabel.text = "Saved";
                        } else {
                            cell.messageLabel.text = "";
                        }
                        
                        if (event.eventPicture != nil && event.eventPicture != "") {
                            cell.imageLabel.isHidden = false;
                            cell.imageLabel.text = "Uploaded";
                        }
                    }
                    
                    cell.locationMap.delegate = self;
                    //Let disbale the location arrow button if location is not selected
                    //Or Location is custom location.
                    if (event.location == nil || event.location == "" || event.location.contains("[CL]")) {
                        cell.locationArrowBtn.isUserInteractionEnabled = false;
                    } else {
                        cell.locationArrowBtn.isUserInteractionEnabled = true;
                    }
                    
                    if (createGathDto.isCovidMapOpened == true) {
                        
                        if (loggedInUser.showCovidLocationData == true) {
                            
                            cell.showCovidDataLabelView.isHidden = true;
                            cell.covidInfoContainerView.isHidden = false;

                            //153 default height of Map
                            //136 Default height of covid data info
                            let heightToAdd = 153.0 + CGFloat((self.view.frame.width*80)/100 - 153)
                            cell.locationMap.frame = CGRect.init(x: cell.locationMap.frame.origin.x, y: cell.locationMap.frame.origin.y, width: cell.locationMap.frame.width, height: heightToAdd);
                            
                            cell.covidInfoContainerView.frame = CGRect.init(x: cell.covidInfoContainerView.frame.origin.x, y: cell.locationBar.frame.origin.y + cell.locationBar.frame.height + 15, width: cell.covidInfoContainerView.frame.width, height: cell.covidLocationDataInfoView.frame.origin.y + cell.covidLocationDataInfoView.frame.height);
                            
                            cell.covidInfoContainerBottomSeparator.frame = CGRect.init(x: self.view.frame.origin.x, y: cell.covidInfoContainerView.frame.origin.y + cell.covidInfoContainerView.frame.height + 5, width: self.view.frame.width, height: 1);

                            cell.messageBar.frame = CGRect.init(x: cell.messageBar.frame.origin.x, y: cell.covidInfoContainerBottomSeparator.frame.origin.y + cell.covidInfoContainerBottomSeparator.frame.height + 20, width: cell.messageBar.frame.width, height: cell.messageBar.frame.height);
                            
                            cell.imageBar.frame = CGRect.init(x: cell.imageBar.frame.origin.x, y: cell.messageBar.frame.origin.y + cell.messageBar.frame.height + 15, width: cell.imageBar.frame.width, height: cell.imageBar.frame.height);
                            
                        } else {
                            
                            cell.showCovidDataLabelView.isHidden = false;
                            cell.covidInfoContainerView.isHidden = true;

                            cell.showCovidDataLabelView.frame = CGRect.init(x: 0, y: cell.locationBar.frame.origin.y + cell.locationBar.frame.height + 15, width: cell.showCovidDataLabelView.frame.width, height: cell.showCovidDataLabelView.frame.height)
                                     
                             cell.messageBar.frame = CGRect.init(x: cell.messageBar.frame.origin.x, y: cell.showCovidDataLabelView.frame.origin.y + cell.showCovidDataLabelView.frame.height  + 15, width: cell.messageBar.frame.width, height: cell.messageBar.frame.height);
                             
                             cell.imageBar.frame = CGRect.init(x: cell.imageBar.frame.origin.x, y: cell.messageBar.frame.origin.y + cell.messageBar.frame.height + 15, width: cell.imageBar.frame.width, height: cell.imageBar.frame.height);
                            
                        }
                        
                    } else {
                        
                        cell.showCovidDataLabelView.isHidden = true;
                        cell.covidInfoContainerView.isHidden = true;

                        cell.messageBar.frame = CGRect.init(x: cell.messageBar.frame.origin.x, y: cell.locationBar.frame.origin.y + cell.locationBar.frame.height + 15, width: cell.messageBar.frame.width, height: cell.messageBar.frame.height);
                        
                        cell.imageBar.frame = CGRect.init(x: cell.imageBar.frame.origin.x, y: cell.messageBar.frame.origin.y + cell.messageBar.frame.height + 15, width: cell.imageBar.frame.width, height: cell.imageBar.frame.height);
                    }
                    
                    return cell;
                }
            
            default:
                return UITableViewCell();
        }
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.friendsCollectionRow] == false) {
                return 0;
            }
            return CreateGatheringCellHeight.friendCollectionViewHeight;
        case 1:
            if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] == false) {
                return 0;
            }
            return CreateGatheringCellHeight.datePanelHeight;
        case 2:
            if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveInfoRow] == false) {
                return 0;
            }
            return CreateGatheringCellHeight.predictiveInfoHeight;
        case 3:
            if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] == false) {
                return 0;
            }
            return CreateGatheringCellHeight.calendarPanelHeight;
        case 4:
            if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] == false) {
                return 0;
            }
            
            if (createGathDto.isCovidMapOpened == true) {
                if (loggedInUser.showCovidLocationData == true) {
                    let heightToAdd = (self.view.frame.width*80)/100 - 153
                    return CreateGatheringCellHeight.gathInfoHeightWithCovid + heightToAdd;
                } else {
                    return CreateGatheringCellHeight.gathInfoHeightWithCovidShowMessage;
                }
            }
            return CreateGatheringCellHeight.gathInfoHeight;
        
        default :
            return 128;
        }
    }
}
