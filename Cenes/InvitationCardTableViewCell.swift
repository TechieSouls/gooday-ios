//
//  InvitationCardTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 24/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class InvitationCardTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var evntTitle: UILabel!
    
    @IBOutlet weak var eventTime: UILabel!
    
    
    @IBOutlet weak var guestListView: UIView!
    
    @IBOutlet weak var locationView: UIView!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var chatProfilePic: UIImageView!
    @IBOutlet weak var descriptionUILabelHolder: UIView!
    @IBOutlet weak var descriptionUILabel: UILabel!
    
    @IBOutlet weak var eventPicture: UIImageView!
    
    @IBOutlet weak var descViewMessageIcon: UIImageView!
    
    @IBOutlet weak var locationViewLocationIcon: UIImageView!
    
    var gatheringInvitaionViewControllerDelegate: GatheringInvitationViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePic.roundedView();
        guestListView.roundedView();
        locationView.roundedView();
        descriptionView.roundedView();
        shareView.roundedView();
        descriptionUILabelHolder.layer.cornerRadius = 10;
        chatProfilePic.roundedView();
        chatProfilePic.layer.borderWidth = 2;
        chatProfilePic.layer.borderColor = UIColor.white.cgColor;
        
        let guestListViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("guestListViewPressed"));
        guestListView.addGestureRecognizer(guestListViewTapGesture);
        
        let locationViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("locationViewPressed"));
        locationView.addGestureRecognizer(locationViewTapGesture);
        
        let descriptionViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("descriptionViewPressed"));
        descriptionView.addGestureRecognizer(descriptionViewTapGesture);
        
        let shareViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("shareViewPressed"));
        shareView.addGestureRecognizer(shareViewTapGesture);
        
        let imageViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("eventImageTapped"));
        eventPicture.addGestureRecognizer(imageViewTapGesture);
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func locationViewPressed() {
        
        self.processAlreadyCheckedBubble(selectedBubble: "location");
        
        gatheringInvitaionViewControllerDelegate.trackCheckdeBubble = "location";
        self.locationViewLocationIcon.image = UIImage.init(named: "location_on_icon")
        self.locationView.backgroundColor = UIColor.white;
        
        if gatheringInvitaionViewControllerDelegate.event.latitude != nil {
            
            let alert = UIAlertController(title: nil, message: gatheringInvitaionViewControllerDelegate.event.location, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Get Directions", style: .default, handler: {(resp) in
                self.locationView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.locationViewLocationIcon.image = UIImage.init(named: "location_off_icon")
                
                
                //Working in Swift new versions.
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {UIApplication.shared.openURL(NSURL(string:"comgooglemaps://?saddr=&daddr=\(Float(String(self.gatheringInvitaionViewControllerDelegate.event.latitude!))),\(Float(String(self.gatheringInvitaionViewControllerDelegate.event.longitude!)))&directionsmode=driving")! as URL)
                } else {
                    NSLog("Can't use com.google.maps://");
                    if (UIApplication.shared.canOpenURL(NSURL(string:"https://maps.google.com")! as URL))  {
                        
                        let url: String = String("https://maps.google.com?daddr=\(String(self.gatheringInvitaionViewControllerDelegate.event.location).replacingOccurrences(of: " ", with: "+"))&center=\(String(self.gatheringInvitaionViewControllerDelegate.event.latitude)),\(String(self.gatheringInvitaionViewControllerDelegate.event.longitude))&zoom=15");
                        
                        print(url)
                        let finalURL: URL = NSURL(string: url)! as URL;
                        UIApplication.shared.open(finalURL, options: [:], completionHandler: nil);
                        
                    }
                }
            }))
            gatheringInvitaionViewControllerDelegate.present(alert, animated: true) {
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            }
        } else {
            let alert = UIAlertController(title: "Location", message: "\(String(gatheringInvitaionViewControllerDelegate.event.location))", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(resp) in
                self.locationView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.locationViewLocationIcon.image = UIImage.init(named: "location_off_icon")
            }))
            gatheringInvitaionViewControllerDelegate.present(alert, animated: true)
        }
    }
    
    @objc func alertControllerBackgroundTapped(){
        self.locationView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
        self.locationViewLocationIcon.image = UIImage.init(named: "location_off_icon")
        gatheringInvitaionViewControllerDelegate.dismiss(animated: true, completion: nil)
    }
    
    @objc func descriptionViewPressed() {
        
        self.processAlreadyCheckedBubble(selectedBubble: "description");
        
        self.descriptionView.backgroundColor = UIColor.white;
        self.descViewMessageIcon.image = UIImage.init(named: "message_on_icon");
        
        if (gatheringInvitaionViewControllerDelegate.event.description != nil && gatheringInvitaionViewControllerDelegate.event.description != "") {
            gatheringInvitaionViewControllerDelegate.trackCheckdeBubble = "description";
            
            self.descriptionView.backgroundColor = UIColor.white;
            self.descriptionUILabel.text = gatheringInvitaionViewControllerDelegate.event.description;
            if (self.descriptionUILabelHolder.isHidden) {
                
                self.descriptionUILabelHolder.isHidden = false;
                let height = self.heightForView(text:gatheringInvitaionViewControllerDelegate.event.description, font: self.descriptionUILabel.font, width: self.descriptionUILabel.frame.width);
                
                
                //160 is the destance from bottom
                //40 is the total padding from uilabel(20 top , 20 bottom)
                //so y will be total height of screen - bottom space(160) - height of uilabel(height) - total padding(top + bottom)
                self.descriptionUILabelHolder.frame =  CGRect(self.descriptionUILabelHolder.frame.origin.x, gatheringInvitaionViewControllerDelegate.view.frame.height - (160 + height + 40) , self.descriptionUILabelHolder.frame.width, height + 40);
                
                self.chatProfilePic.isHidden = false;
                
            } else {
                self.descriptionView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.descriptionUILabelHolder.isHidden = true;
                self.chatProfilePic.isHidden = true;
                self.descViewMessageIcon.image = UIImage.init(named: "message_off_icon");
            }
        } else {
            let alert = UIAlertController(title: "Alert!", message: "Description Not Available.", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(resp) in
                self.descriptionView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.descViewMessageIcon.image = UIImage.init(named: "message_off_icon");
            }))
            gatheringInvitaionViewControllerDelegate.present(alert, animated: true)
        }
    }
    
    
    
    
    @objc func shareViewPressed() {
        
        self.processAlreadyCheckedBubble(selectedBubble: "share");
        gatheringInvitaionViewControllerDelegate.trackCheckdeBubble = "share";
        
        if (gatheringInvitaionViewControllerDelegate.event.eventId == nil) {
            let alert = UIAlertController(title: "Alert!", message: "Event cannot be shared this time.", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
            gatheringInvitaionViewControllerDelegate.present(alert, animated: true)
        } else {
            
            var text: String = "\(gatheringInvitaionViewControllerDelegate.eventOwner.user.name!) invites you to \(gatheringInvitaionViewControllerDelegate.event.title!). RSVP through the Cenes app. Link below: \n";
            text = text + String("\(shareEventUrl)\(String(gatheringInvitaionViewControllerDelegate.event.key))");
            
            // set up activity view controller
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = gatheringInvitaionViewControllerDelegate.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            // present the view controller
            gatheringInvitaionViewControllerDelegate.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @objc func eventImageTapped() {
        //print("Tapped")
        
        self.descriptionView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
        self.descriptionUILabelHolder.isHidden = true;
        self.chatProfilePic.isHidden = true;
        self.descViewMessageIcon.image = UIImage.init(named: "message_off_icon");
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(0, 0, self.descriptionUILabel.frame.width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func processAlreadyCheckedBubble(selectedBubble: String) {
        
        if (gatheringInvitaionViewControllerDelegate.trackCheckdeBubble != selectedBubble) {
            
            if (gatheringInvitaionViewControllerDelegate.trackCheckdeBubble == "description") {
                self.descriptionView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.descriptionUILabelHolder.isHidden = true;
                self.chatProfilePic.isHidden = true;
                self.descViewMessageIcon.image = UIImage.init(named: "message_off_icon");
            }
        }
    }
    
    @objc func guestListViewPressed() {
        
        self.processAlreadyCheckedBubble(selectedBubble: "guestList");
        
        gatheringInvitaionViewControllerDelegate.trackCheckdeBubble = "guestList";
        
        let guestListViewController: GuestListViewController = gatheringInvitaionViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "GuestListViewController") as! GuestListViewController;
        guestListViewController.eventMembers = gatheringInvitaionViewControllerDelegate.event.eventMembers;
        gatheringInvitaionViewControllerDelegate.present(guestListViewController, animated: true, completion: nil);
    }
    
    
    func populateCardDetails () {
        
        for eventMember in gatheringInvitaionViewControllerDelegate.event.eventMembers {
            //We have to check user id, because there may be users which are non cenes users
            if (eventMember.userId != nil && gatheringInvitaionViewControllerDelegate.event.createdById == eventMember.userId) {
                gatheringInvitaionViewControllerDelegate.eventOwner = eventMember;
                break;
            }
        }
        
        if (gatheringInvitaionViewControllerDelegate.eventOwner == nil) {
            gatheringInvitaionViewControllerDelegate.eventOwner = Event().getLoggedInUserAsEventMember();
        }
        
        if (gatheringInvitaionViewControllerDelegate.eventOwner != nil) {
            if (gatheringInvitaionViewControllerDelegate.eventOwner.user != nil && gatheringInvitaionViewControllerDelegate.eventOwner.user.photo != nil) {
                chatProfilePic.sd_setImage(with: URL(string: gatheringInvitaionViewControllerDelegate.eventOwner.user.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
                profilePic.sd_setImage(with: URL(string: gatheringInvitaionViewControllerDelegate.eventOwner.user.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
            }
            
            if (gatheringInvitaionViewControllerDelegate.eventOwner.userId == gatheringInvitaionViewControllerDelegate.loggedInUser.userId) {
                gatheringInvitaionViewControllerDelegate.isLoggedInUserAsOwner = true;
            }
            
        }
        
        if (gatheringInvitaionViewControllerDelegate.event.eventId != nil) {
            if (gatheringInvitaionViewControllerDelegate.event.eventPicture != nil) {
                eventPicture.sd_setImage(with: URL(string: gatheringInvitaionViewControllerDelegate.event.eventPicture));
            }
        } else {
            if (gatheringInvitaionViewControllerDelegate.event.imageToUpload != nil) {
                eventPicture.image = gatheringInvitaionViewControllerDelegate.event.imageToUpload;
            }
        }
        
        evntTitle.text = gatheringInvitaionViewControllerDelegate.event.title;
        
        let dateOfEvent = Date(milliseconds: Int(gatheringInvitaionViewControllerDelegate.event!.startTime)).EMMMd()!;
        
        let timeOfEvent = "\(Date(milliseconds: Int(gatheringInvitaionViewControllerDelegate.event!.startTime)).hmma())-\(Date(milliseconds: Int(gatheringInvitaionViewControllerDelegate.event!.endTime)).hmma())"
        
        eventTime.text = "\(dateOfEvent), \(timeOfEvent)";
        
        /*if (imageCard != nil) {
            imageCard.setNeedsDisplay();
        }*/
    }
}
