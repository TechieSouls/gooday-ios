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
            identifier = "GatheringTableViewCellTwo"
            let cell: GatheringTableViewCellTwo = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringTableViewCellTwo)!
            cell.gatheringView = self
            
            if self.eventName == "" {
                cell.eventTitleTextField.text = ""
            }else{
                cell.eventTitleTextField.text = self.eventName
            }
            
            if self.summaryBool{
                cell.eventTitleTextField.isUserInteractionEnabled = false
            }else{
                cell.eventTitleTextField.isUserInteractionEnabled = true
            }
            
            return cell
        case 2:
            print("")
            identifier = "GatheringTableViewCellThree"
            let cell: GatheringTableViewCellThree = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringTableViewCellThree)!
            
            cell.createGatheringView = self
            cell.setShowArray()
            if self.selectedFriends.count > 0 {
                cell.lowerView.isHidden = false
            }else{
                cell.lowerView.isHidden = true
            }
            cell.reloadFriends()
            return cell
            
        case 3:
            print("")
            
            
            
            identifier = "GatheringTableViewCellFive"
            let cell: GatheringTableViewCellFive = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringTableViewCellFive)!
            
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
            
            
            return cell
        case 4:
            print("")
            identifier = "GatheringTableViewCellOne"
            let cell: GatheringTableViewCellOne = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringTableViewCellOne)!
            
            
            if self.selectedLocation != nil {
                cell.locationTitle.text = self.selectedLocation.locationName
            }else{
                cell.locationTitle.text = "Add Location"
            }
            
            if self.editSummary == true {
                if self.locationName == "No Location for event"{
                    cell.locationTitle.text = "Add location"
                    self.locationName = ""
                }
            }
            
            
            return cell
        case 5:
            print("")
            identifier = "GAtheringTableViewCellFour"
            let cell: GAtheringTableViewCellFour = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GAtheringTableViewCellFour)!
            cell.gatheringView = self
            
            if self.eventDetails == "" {
                cell.eventDetailsField.text = ""
            }else{
                cell.eventDetailsField.text = self.eventDetails
            }
            
            if self.summaryBool{
                cell.eventDetailsField.isUserInteractionEnabled = false
            }else{
                cell.eventDetailsField.isUserInteractionEnabled = true
            }
            
            return cell
            
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
            if self.selectedFriends.count > 0 {
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
            
            if !self.summaryBool{
                self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
                
                let inviteFriends = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inviteFriends") as? InviteFriendViewController
                
                //inviteFriends?.gatheringView = self
                inviteFriends?.selectedFriendsDelegate = self;
                self.navigationController?.pushViewController(inviteFriends!, animated: true)
                //                self.modalPresentationStyle = .overCurrentContext
                //                self.present(inviteFriends!, animated: true, completion: nil)
            }
            
        case 3:
            print("")
        case 4:
            print("")
            
            //            if self.cellHeightTime == CellHeight.Third {
            //            self.cellHeightTime = CellHeight.Fourth
            //                self.gatheringTableView.reloadData()
            //            }
            if !self.summaryBool{
                self.performSegue(withIdentifier: "showLocation", sender: nil)
            }
        case 5:
            print("")
            
        default:
            print("")
            
        }
    }
}
