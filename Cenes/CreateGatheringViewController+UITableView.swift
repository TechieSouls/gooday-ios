//
//  CreateGatheringViewController+UITableView.swift
//  Deploy
//
//  Created by Macbook on 19/12/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//
import Foundation

extension CreateGatheringViewController :UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.editSummary == true{
            return 7
        }
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var identifier = "TableViewCell"
        
        switch indexPath.row {
        case 0:
            print("")
            identifier = "GatheringEventTableViewCell"
            let cell: GatheringEventTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringEventTableViewCell)!
            cell.imageDelegate  = self
            cell.indexPathCell = indexPath
            cell.gView = self
            if (self.gatheringImageURL != nil && self.gatheringImage == nil) {
                cell.loadImage()
            }
            return cell
            
        case 1:
            print("")
            identifier = "GatheringTitleTableViewCell"
            /*let cell: GatheringTitleTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringTitleTableViewCell)!
            cell.gatheringView = self
            
            if self.eventName == "" {
                cell.eventTitleTextField.text = ""
            }else{
                cell.eventTitleTextField.text = self.event.title;
            //}
            
            if self.summaryBool{
                cell.eventTitleTextField.isUserInteractionEnabled = false
            }else{
                cell.eventTitleTextField.isUserInteractionEnabled = true
            }
            
            return cell*/
        case 2:
            print("")
            identifier = "GatheringPeopleTableViewCell"
             /*let cell: GatheringPeopleTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringPeopleTableViewCell)!
            
            cell.createGatheringView = self
            cell.setShowArray()
            if self.event.eventMembers != nil && self.event.eventMembers.count > 0 {
                cell.lowerView.isHidden = false
            }else{
                cell.lowerView.isHidden = true
            }
            cell.reloadFriends()
            return cell*/
            
        case 3:
            print("")
            
            
            
            identifier = "GatheringDateTableViewCell"
            /*let cell: GatheringDateTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringDateTableViewCell)!
            
            cell.cellDelegate = self
            cell.gatheringView = self
            
            cell.cellIndex = indexPath
            
            cell.setFirstDateSecondDate()
            
            switch cellHeightTime! {
            case CellHeight.First:
                cell.setFirstCase()
                
            case CellHeight.Second:
                cell.setSecondCase()
                
            case CellHeight.Third :
                cell.setThirdCase()
                
            case CellHeight.Fourth :
                cell.setFourthCase()
                
            case CellHeight.Fifth  :
                cell.setFifthCase()
            default:
                print("Height fails")
            }
            
            if self.loadSummary == true {
                cell.loadSummary(startTime: self.startTime!, endTime: self.endTime!)
            }
 
            
            return cell*/
        case 4:
            print("")
            identifier = "GatheringLocationTableViewCell"
            /*let cell: GatheringLocationTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringLocationTableViewCell)!
            
            
            if self.event.location != nil {
                cell.locationTitle.text = self.event.location;
            }else{
                cell.locationTitle.text = "Add Location"
            }
            
            if self.editSummary == true {
                if self.locationName == "No Location for event"{
                    cell.locationTitle.text = "Add location"
                    self.locationName = ""
                }
            }
            return cell*/
        case 5:
            print("")
            identifier = "GatheringDescTableViewCell"
            /*let cell: GatheringDescTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringDescTableViewCell)!
            cell.gatheringView = self
            
            /*if self.eventDetails == "" {
                cell.eventDetailsField.text = ""
            }else{*/
                cell.eventDetailsField.text = self.event.description
            //}
            
            if self.summaryBool{
                cell.eventDetailsField.isUserInteractionEnabled = false
            }else{
                cell.eventDetailsField.isUserInteractionEnabled = true
            }
            
            return cell*/
            
        case 6:
            print("delte cell")
            identifier = "DeleteCell"
            let cell: DeleteCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? DeleteCell)!
            cell.gatheringView = self
            return cell
        default:
            print("")
            return UITableViewCell()
        }
        return UITableViewCell()

    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 127
        case 1:
            return 60
        case 2:
            if self.event.eventMembers != nil && self.event.eventMembers.count > 0 {
                return 146
            }else{
                return 64
            }
            
            
        case 3:
            return cellHeightTime!.rawValue
        case 4:
            return 76
        case 5:
            return 44 //632
        case 6 :
            return 64
        default:
            print("")
            return 100
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        case 0:
            print("")
        case 1:
            print("")
        case 2:
            print("")
            
            self.performSegue(withIdentifier: "inviteFriends", sender: nil)

        case 3:
            print("")
        case 4:
            print("")
            
            self.performSegue(withIdentifier: "showLocation", sender: nil)
            
        case 5:
            print("")
            
        default:
            print("")
            
        }
    }
}
