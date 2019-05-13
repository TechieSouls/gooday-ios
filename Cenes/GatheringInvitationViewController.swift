//
//  GatheringInvitationViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GatheringInvitationViewController: UIViewController {

    
    @IBOutlet weak var acceptedImageView: UIImageView!
    
    @IBOutlet weak var rejectedImageiew: UIImageView!
    
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
    
    @IBOutlet weak var nextScreenArrow: UIImageView!
    
    
    var divisor : CGFloat!;
    var event: Event!;
    var eventOwner: EventMember!;
    var loggedInUser: User!;
    var trackCheckdeBubble: String!;
    var isLoggedInUserAsOwner = false;
    var pendingEvents: [Event] = [Event]();
    var pendingEventIndex: Int = 0;
    var imageCard: UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1);
        profilePic.roundedView();
        guestListView.roundedView();
        locationView.roundedView();
        descriptionView.roundedView();
        shareView.roundedView();
        descriptionUILabelHolder.layer.cornerRadius = 10;
        chatProfilePic.roundedView();
        chatProfilePic.layer.borderWidth = 2;
        chatProfilePic.layer.borderColor = UIColor.white.cgColor;

        acceptedImageView.alpha = 0;
        rejectedImageiew.alpha = 0;
        nextScreenArrow.alpha = 0;
        
        //35 degree angle from center
        divisor = ((self.view.frame.width / 2) / 0.56)
        // Do any additional setup after loading the view.
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        navigationController?.navigationBar.isHidden = true;
        tabBarController?.tabBar.isHidden = true;
        
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
        
        
        if (pendingEvents.count > 0) {
            event = pendingEvents[pendingEventIndex];
        }
        
        populateCardDetails();
        
        
        /*if (isLoggedInUserAsOwner == true) {
            acceptedImageView.isHidden = true;
            rejectedImageiew.isHidden = true;
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        acceptedImageView.alpha = 0;
        rejectedImageiew.alpha = 0;
        nextScreenArrow.alpha = 0;
    }
    
    @IBAction func panToImageView(_ sender: UIPanGestureRecognizer) {
        
        imageCard = sender.view!;
        
        let point = sender.translation(in: view);
        let xFromCenter = imageCard.center.x - self.view.center.x;
        let yFromCenter = imageCard.center.y - self.view.center.y;
        //print("Image Card Y - height of screen ", (imageCard.frame.origin.y))
        
        //print("X From Center : ",xFromCenter, "y From Center : ", imageCard.center.y - self.view.center.y)
        
        imageCard.center = CGPoint(x: view.center.x+point.x, y: view.center.y+point.y);
        
        
        //If the card is moved more that 50 y axis upwards, then we will show the up arrow
        if (imageCard.frame.origin.y < -50) {
            let rejectedAlpha = abs(imageCard.frame.origin.y) / 100;
            print("Alpha : ",rejectedAlpha);
            nextScreenArrow.alpha = rejectedAlpha;
        } else if (yFromCenter > -30) { // 180 degree = 3.14 radian. We want 35 decree inclinition
            if (xFromCenter < 0) {
                imageCard.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor);
                let rejectedAlpha = abs(xFromCenter) / self.view.center.x;
                rejectedImageiew.alpha = rejectedAlpha;
            } else {
                imageCard.transform = CGAffineTransform(rotationAngle:xFromCenter/divisor);
                let acceptedAlpha = abs(xFromCenter) / self.view.center.x;
                acceptedImageView.alpha = acceptedAlpha;
            }
        } else {
            imageCard.transform = .identity;
        }
        
        //The inviation card will move to center when the finger is up
        if (sender.state == UIGestureRecognizerState.ended) {
            
            //We will check if user swiped the card upto 200 Y axis
            //Then we will either bring the new card or popup to previous screen.
            if (imageCard.frame.origin.y < -200) {
                //self.navigationController?.popViewController(animated: false);
                pendingEventIndex = pendingEventIndex + 1;
                if (pendingEventIndex < pendingEvents.count) {
                    event = pendingEvents[pendingEventIndex]
                    populateCardDetails();
                    imageCard.center = self.view.center;
                } else {
                    self.navigationController?.popViewController(animated: false);
                }
                
            } else if (imageCard.center.x < 75) {
                //If user move the card to left for declining, then we will decline it.
                //Move card to left side
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageCard.center = CGPoint(x: self.imageCard.center.x - 200, y: self.imageCard.center.y);
                    self.imageCard.alpha = 0
                    
                    //Decline invitation
                    if (self.isLoggedInUserAsOwner == false) {
                        let acceptQueryStr = "eventId=\(String(self.event.eventId))&userId=\(String(self.loggedInUser.userId))&status=NotGoing";
                        GatheringService().updateGatheringStatus(queryStr: acceptQueryStr, token: self.loggedInUser.token, complete: {(response) in
                            
                        });
                        
                        self.pendingEventIndex = self.pendingEventIndex + 1;
                        if (self.pendingEventIndex < self.pendingEvents.count) {
                            self.event = self.pendingEvents[self.pendingEventIndex]
                            UIView.animate(withDuration: 0.2, animations: {
                                self.imageCard.center = self.view.center;
                                self.imageCard.transform = .identity
                                self.acceptedImageView.alpha = 0;
                                self.rejectedImageiew.alpha = 0;
                            });
                            self.imageCard.alpha = 1;
                            self.populateCardDetails();
                        } else {
                            self.navigationController?.popViewController(animated: false);
                        }

                    } else {
                        self.navigationController?.popViewController(animated: false);

                    }
                    
                });
                return;
            } else if (imageCard.center.x > (view.frame.width - 75)) {
                //Move card to right side
                print("Inside right gesture...")
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageCard.center = CGPoint(x: self.imageCard.center.x + 200, y: self.imageCard.center.y);
                    self.imageCard.alpha = 0;
                    
                    //For other users accept gathering
                    if (self.isLoggedInUserAsOwner == false) {
                        let acceptQueryStr = "eventId=\(String(self.event.eventId))&userId=\(String(self.loggedInUser.userId))&status=Going";
                        GatheringService().updateGatheringStatus(queryStr: acceptQueryStr, token: self.loggedInUser.token, complete: {(response) in
                            
                        });
                        self.pendingEventIndex = self.pendingEventIndex + 1;
                        if (self.pendingEventIndex < self.pendingEvents.count) {
                            self.event = self.pendingEvents[self.pendingEventIndex]
                            self.populateCardDetails();
                            UIView.animate(withDuration: 0.2, animations: {
                                self.imageCard.center = self.view.center;
                                self.imageCard.transform = .identity
                                self.acceptedImageView.alpha = 0;
                                self.rejectedImageiew.alpha = 0;
                            })
                            self.imageCard.alpha = 1
                        } else {
                            self.navigationController?.popViewController(animated: false);
                        }
                        //self.navigationController?.popToRootViewController(animated: true);

                    } else {
                        
                        //If owner is looking at the event and,
                        //its an existging event then we will popup this controller
                        if (self.event.eventId != nil) {
                            self.navigationController?.popViewController(animated: false);

                        } else {
                            //For owner, if its a new event, create new event
                            DispatchQueue.global(qos: .background).async {
                                let imageToUpload = self.event.imageToUpload;
                                GatheringService().createGathering(uploadDict: self.event.toDictionary(event: self.event), complete: {(response) in
                                    print("Saved Successfully...")
                                    let error = response.value(forKey: "Error") as! Bool;
                                    if (error == false) {
                                        let dataDict = response.value(forKey: "data") as! NSDictionary;
                                        let eventId = dataDict.value(forKey: "eventId") as! Int32
                                        GatheringService().uploadEventImageV2(image: imageToUpload, eventId: eventId, loggedInUser: self.loggedInUser, complete: {(resp) in
                                            print("Saved Uploaded...")
                                            
                                        });
                                    }
                                    //self.navigationController?.popToRootViewController(animated: true);
                                    //self.dismiss(animated: true, completion: nil)
                                    
                                });
                                
                                DispatchQueue.main.async {
                                    // Go back to the main thread to update the UI.
                                    self.navigationController?.popToRootViewController(animated: false);
                                }
                            }
                        }
                        
                        //self.dismiss(animated: true, completion: nil)
                    }
                });
                return;
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.imageCard.center = self.view.center;
                    self.imageCard.transform = .identity
                    self.acceptedImageView.alpha = 0;
                    self.rejectedImageiew.alpha = 0;
                })
            }
        }
       
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @objc func guestListViewPressed() {
        
        self.processAlreadyCheckedBubble(selectedBubble: "guestList");

        self.trackCheckdeBubble = "guestList";
        
        let guestListViewController: GuestListViewController = storyboard?.instantiateViewController(withIdentifier: "GuestListViewController") as! GuestListViewController;
        guestListViewController.eventMembers = event.eventMembers;
        self.present(guestListViewController, animated: true, completion: nil);
    }
    
    @objc func locationViewPressed() {
        
        self.processAlreadyCheckedBubble(selectedBubble: "location");

        self.trackCheckdeBubble = "location";
        self.locationViewLocationIcon.image = UIImage.init(named: "location_on_icon")
        self.locationView.backgroundColor = UIColor.white;
        
        if event.latitude != nil {

            let alert = UIAlertController(title: nil, message: event.location, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Get Directions", style: .default, handler: {(resp) in
                self.locationView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.locationViewLocationIcon.image = UIImage.init(named: "location_off_icon")

                
                //Working in Swift new versions.
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {UIApplication.shared.openURL(NSURL(string:"comgooglemaps://?saddr=&daddr=\(Float(String(self.event.latitude!))),\(Float(String(self.event.longitude!)))&directionsmode=driving")! as URL)
                } else {
                    NSLog("Can't use com.google.maps://");
                    if (UIApplication.shared.canOpenURL(NSURL(string:"https://maps.google.com")! as URL))  {
                        
                        let url: String = String("https://maps.google.com?daddr=\(String(self.event.location))&center=\(String(self.event.latitude)),\(String(self.event.longitude))&zoom=15");
                        
                        print(url)
                        UIApplication.shared.open(URL(string: String(url as! String))! , options: [:], completionHandler: nil);
                    }
                }
            }))
            self.present(alert, animated: true) {
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            }
        } else {
            let alert = UIAlertController(title: "Location", message: "\(String(event.location))", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(resp) in
                self.locationView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.locationViewLocationIcon.image = UIImage.init(named: "location_off_icon")
            }))
            self.present(alert, animated: true)
        }
    }
    
    @objc func alertControllerBackgroundTapped(){
        self.locationView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
        self.locationViewLocationIcon.image = UIImage.init(named: "location_off_icon")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func descriptionViewPressed() {
        
        self.processAlreadyCheckedBubble(selectedBubble: "description");

        self.descriptionView.backgroundColor = UIColor.white;
        self.descViewMessageIcon.image = UIImage.init(named: "message_on_icon");

        if (event.description != nil && event.description != "") {
            self.trackCheckdeBubble = "description";
            
            self.descriptionView.backgroundColor = UIColor.white;
            self.descriptionUILabel.text = event.description;
            if (self.descriptionUILabelHolder.isHidden) {
                
                self.descriptionUILabelHolder.isHidden = false;
                let height = self.heightForView(text:event.description, font: self.descriptionUILabel.font, width: self.descriptionUILabel.frame.width);
                
                
                //160 is the destance from bottom
                //40 is the total padding from uilabel(20 top , 20 bottom)
                //so y will be total height of screen - bottom space(160) - height of uilabel(height) - total padding(top + bottom)
                self.descriptionUILabelHolder.frame =  CGRect(self.descriptionUILabelHolder.frame.origin.x, self.view.frame.height - (160 + height + 40) , self.descriptionUILabelHolder.frame.width, height + 40);
                
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
            self.present(alert, animated: true)
        }
    }

    
    
    
    @objc func shareViewPressed() {
        
        self.processAlreadyCheckedBubble(selectedBubble: "share");
        self.trackCheckdeBubble = "share";

        if (self.event.eventId == nil) {
            let alert = UIAlertController(title: "Alert!", message: "Event cannot be shared this time.", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
            self.present(alert, animated: true)
        } else {
            
            var text: String = "\(eventOwner.user.name!) invites you to \(event.title!). RSVP through the Cenes app. Link below: \n";
            text = text + String("\(shareEventUrl)\(String(event.key))");
            
            // set up activity view controller
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
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
        
        if (self.trackCheckdeBubble != selectedBubble) {
            
            if (self.trackCheckdeBubble == "description") {
                self.descriptionView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.descriptionUILabelHolder.isHidden = true;
                self.chatProfilePic.isHidden = true;
                self.descViewMessageIcon.image = UIImage.init(named: "message_off_icon");
            }
        }
    }
    
    func populateCardDetails () {
        
        for eventMember in self.event.eventMembers {
            //We have to check user id, because there may be users which are non cenes users
            if (eventMember.userId != nil && event.createdById == eventMember.userId) {
                eventOwner = eventMember;
                break;
            }
        }
        
        if (eventOwner == nil) {
            eventOwner = Event().getLoggedInUserAsEventMember();
        }
        
        if (eventOwner != nil) {
            if (eventOwner.user != nil && eventOwner.user.photo != nil) {
                chatProfilePic.sd_setImage(with: URL(string: eventOwner.user.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
                profilePic.sd_setImage(with: URL(string: eventOwner.user.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
            }
            
            if (eventOwner.userId == loggedInUser.userId) {
                isLoggedInUserAsOwner = true;
            }
            
        }
        
        if (event.eventId != nil) {
            if (event.eventPicture != nil) {
                eventPicture.sd_setImage(with: URL(string: event.eventPicture));
            }
        } else {
            if (event.imageToUpload != nil) {
                eventPicture.image = event.imageToUpload;
            }
        }
        
        evntTitle.text = event.title;
        
        let dateOfEvent = Date(milliseconds: Int(event!.startTime)).EMMMd()!;
        
        let timeOfEvent = "\(Date(milliseconds: Int(event!.startTime)).hmma())-\(Date(milliseconds: Int(event!.endTime)).hmma())"
        
        eventTime.text = "\(dateOfEvent), \(timeOfEvent)";
        
        if (imageCard != nil) {
            imageCard.setNeedsDisplay();
        }
    }
    
}
