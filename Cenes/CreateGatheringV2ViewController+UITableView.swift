//
//  CreateGatheringV2ViewController+UITableView.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

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
                return cell;
            }
            case 1:
                if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] == true) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DatePanelTableViewCell", for: indexPath) as! DatePanelTableViewCell;
                    cell.createGatheringDelegate = self;
                    timePickerDoneDelegate = cell;
                    datePanelTableViewCellDelegate = cell;
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
                    return cell;
                }
            case 4:
                if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] == true) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GatheringInfoTableViewCell", for: indexPath) as! GatheringInfoTableViewCell;
                    cell.createGatheringDelegate = self;
                    gatheringInfoCellDelegate = cell
                    gatheringInfoTableViewCellDelegate = cell;
                    return cell;
                }
            
            default:
                return UITableViewCell();
        }
        
        /*if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] == true) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatePanelTableViewCell", for: indexPath) as! DatePanelTableViewCell;
            cell.createGatheringDelegate = self;
            timePickerDoneDelegate = cell;
            return cell;
        }
        
        if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] == true) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GatheringInfoTableViewCell", for: indexPath) as! GatheringInfoTableViewCell;
            
            return cell;
        }
        
        if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveInfoRow] == true) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PredictiveInfoTableViewCell", for: indexPath) as! PredictiveInfoTableViewCell;
            
            return cell;
        }
        
        if (createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] == true) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PredictiveCalendarCellTableViewCell", for: indexPath) as! PredictiveCalendarCellTableViewCell;
            
            return cell;
        }*/
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
            return CreateGatheringCellHeight.gathInfoHeight;
        
        default :
            return 128;
        }
    }
}
