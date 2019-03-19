//
//  GatheringPreviewController+UITableView.swift
//  Deploy
//
//  Created by Cenes_Dev on 23/02/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension GatheringPreviewController :UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.returnNumberOfRows();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print(Event().toDictionary(event: self.event!));
        switch indexPath.row {
            case 0:
                let cell: GatheringPreviewImageTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "GatheringPreviewImageTableViewCell") as? GatheringPreviewImageTableViewCell)!
                
                cell.hostName.text = self.host.name;
                if (self.host.photo != nil) {
                    self.loadImage(url: self.host.photo, imageView: cell.hostImage, placeholder: "profile_icon.png");
                }
                
                if (self.event?.eventPicture != nil) {
                    self.loadImage(url: self.event!.eventPicture!, imageView: cell.gatImage, placeholder: "gath_upload_img.png");
                } else {
                    cell.gatImage.isHidden = true;
                }
                
                return cell;
            
            case 1:
                let cell: GatheringPreviewTitleTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "GatheringPreviewTitleTableViewCell") as? GatheringPreviewTitleTableViewCell)!
                cell.gathTitle.text = self.event?.title;
                return cell;
            case 2:
                let cell: GatheringPreviewDescTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "GatheringPreviewDescTableViewCell") as? GatheringPreviewDescTableViewCell)!
                cell.gathDescription.text = self.event?.description;
                return cell;
            case 3:
                let cell: GatheringDayTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "GatheringDayTableViewCell") as? GatheringDayTableViewCell)!
                cell.gatheringDay.text = "\(Util.getddMMMEEEE(timeStamp: (self.event?.startTime)!))";
                return cell;
            case 4:
                let cell: GatheringTimeTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "GatheringTimeTableViewCell") as? GatheringTimeTableViewCell)!;
                cell.gatheringTime.text = "\(Util.hhmma(timeStamp: (self.event?.startTime)!))-\(Util.hhmma(timeStamp: ((self.event?.endTime)!)))";
                return cell;
            
            case 5: //Gathering Location
                let cell: GatheringLocTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "GatheringLocTableViewCell") as? GatheringLocTableViewCell)!;
                if (self.event?.location != nil) {
                    cell.gatheringLocationView.isHidden = false
                    cell.gatheringLocation.text = self.event?.location;
                } else {
                    cell.gatheringLocationView.isHidden = true
                }
                return cell;
        case 6: //Gathering Guests
            let cell: GatheringGuestTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "GatheringGuestTableViewCell") as? GatheringGuestTableViewCell)!;
                if (self.event?.eventMembers == nil) {
                    cell.gatheringGuestsView.isHidden = true
                } else {
                    cell.gatheringGuestsView.isHidden = false
                }
                return cell;
            default:
                print("")
                return UITableViewCell();
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0: //Image
                if (self.event?.eventPicture != nil) {
                    return 300
                } else {
                    return 250;
                }
            case 1: //Title
                return 44
            case 2: //Description
                if (self.event?.description == nil) {
                    return 0;
                }
                return 90
            
            case 3: //Gathering Day
                return 52;
            
            case 4: //Gathering Time
                return 52;
            
            case 5: //Gathering Location
                if (self.event?.location == nil) {
                    return 0;
                }
                return 52;
            
            case 6: //Gathering Guests
                if (self.event?.eventMembers == nil) {
                    return 0;
                }
                return 52;
            default:
                print("")
                return 100
        }
    }
}
