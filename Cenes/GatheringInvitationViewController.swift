//
//  GatheringInvitationViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import MessageUI
import Messages

class GatheringInvitationViewController: UIViewController, UIGestureRecognizerDelegate, MFMessageComposeViewControllerDelegate {

    
    @IBOutlet weak var acceptedImageView: UIImageView!
    
    @IBOutlet weak var rejectedImageiew: UIImageView!
    
    @IBOutlet weak var editImageView: UIImageView!
    
    @IBOutlet weak var deleteImageView: UIImageView!
    
    @IBOutlet weak var nextScreenArrow: UIImageView!
    
    @IBOutlet weak var swipeCardView: UIView!
    
    @IBOutlet weak var invitationCardTableView: UITableView!
    
    var divisor : CGFloat!;
    var event: Event!;
    var eventOwner: EventMember!;
    var loggedInUser: User!;
    var trackCheckdeBubble: String!;
    var isLoggedInUserAsOwner = false;
    var pendingEvents: [Event] = [Event]();
    var pendingEventIndex: Int = 0;
    var imageCard: UIView!;
    var leftToRightGestureEnabled = true;
    var rightToLeftGestureEnabled = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1);
        self.invitationCardTableView.backgroundColor = themeColor;
        self.invitationCardTableView.register(UINib.init(nibName: "InvitationCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InvitationCardTableViewCell")
        self.invitationCardTableView.register(UINib.init(nibName: "NextCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NextCardTableViewCell")

        self.invitationCardTableView.frame = self.view.bounds;
        
        acceptedImageView.alpha = 0;
        rejectedImageiew.alpha = 0;
        deleteImageView.alpha = 0;
        nextScreenArrow.alpha = 0;
        
        //35 degree angle from center
        divisor = ((self.view.frame.width / 2) / 0.34)
        // Do any additional setup after loading the view.
        
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        let swipeleftGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panRecognizer))
        swipeCardView.addGestureRecognizer(swipeleftGesture)
    
        let deleteGesture = UITapGestureRecognizer.init(target: self, action: #selector(deleteGatheringPressed))
        deleteImageView.addGestureRecognizer(deleteGesture)

        let editGesture = UITapGestureRecognizer.init(target: self, action: #selector(editButtonPressed))
        editImageView.addGestureRecognizer(editGesture)

        if (pendingEvents.count > 0) {
            event = pendingEvents[pendingEventIndex];
        }
        
        //populateCardDetails();
        
        
        /*if (isLoggedInUserAsOwner == true) {
            acceptedImageView.isHidden = true;
            rejectedImageiew.isHidden = true;
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        acceptedImageView.alpha = 0;
        rejectedImageiew.alpha = 0;
        nextScreenArrow.alpha = 0;
        navigationController?.navigationBar.isHidden = true;
        tabBarController?.tabBar.isHidden = true;

    }
    
    @objc func panRecognizer(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        let xFromCenter = swipeCardView.center.x - self.view.center.x;

        print("State : ", sender.state.rawValue);
        if (sender.state == UIGestureRecognizerState.began) {
            var gestureIsDraggingFromLeftToRight = (sender.velocity(in: view).x > 0)
            if (gestureIsDraggingFromLeftToRight == true && leftToRightGestureEnabled == false) {//If user stated swiping from left to right
                                                            //We will not move the screen and set its position at center
                sender.setTranslation(CGPoint.zero, in: self.view)
            }
            
            if (gestureIsDraggingFromLeftToRight == false && rightToLeftGestureEnabled == false) {
                sender.setTranslation(CGPoint.zero, in: self.view)

            }
        }
        
        if (sender.state == UIGestureRecognizerState.changed) {
            //print(translation.x)
            /*if (translation.x < 5 && translation.x > -5 && translation.y < 0) {
             swipeCardView.center = CGPoint(x: view.center.x , y: view.center.y + translation.y);
             } else*/
            if (translation.x >  10 && leftToRightGestureEnabled == true) { //Card is swiped right
                swipeCardView.center = CGPoint(x: view.center.x+translation.x, y: view.center.y);
                
                print(xFromCenter)
                swipeCardView.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor);
                
                let acceptedAlpha = abs(xFromCenter) / self.view.center.x;
                acceptedImageView.alpha = acceptedAlpha;
                
            } else if (translation.x < -10 && rightToLeftGestureEnabled == true) { //Card is swiped right
                swipeCardView.center = CGPoint(x: view.center.x + translation.x, y: view.center.y);
                
                print(xFromCenter)
                swipeCardView.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor);
                
                let rejectedAlpha = abs(xFromCenter) / self.view.center.x;
                rejectedImageiew.alpha = rejectedAlpha;
                
                if (isLoggedInUserAsOwner == true) {
                    let deletedAlpha = abs(xFromCenter) / self.view.center.x;
                    deleteImageView.alpha = deletedAlpha;
                }
            }
        }
        
        //The inviation card will move to center when the finger is up
        //This stated will be achieved when user takes away his hand from screen
        if (sender.state == UIGestureRecognizerState.ended) {
            
            print("xFromCenter : ", xFromCenter, "Swipe Card Center : ",swipeCardView.center.x);
            print("Swipe Center", swipeCardView.center.x, "View Center" ,view.center.x)
            if (xFromCenter > 130) {
                //Move card to right side
                //That is when the card is swiped to accept.
                print("Inside right gesture...")
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    //Now lets move the card away by making it invisibleas it goes away
                    self.swipeCardView.center = CGPoint(x: self.swipeCardView.center.x + 200, y: self.swipeCardView.center.y);
                    self.swipeCardView.alpha = 0;
                    
                    //For other users accept gathering
                    if (self.isLoggedInUserAsOwner == false) {
                        let acceptQueryStr = "eventId=\(String(self.event.eventId))&userId=\(String(self.loggedInUser.userId))&status=Going";
                        GatheringService().updateGatheringStatus(queryStr: acceptQueryStr, token:
                            
                            self.loggedInUser.token, complete: {(response) in
                            
                        });
                        self.pendingEventIndex = self.pendingEventIndex + 1;
                        if (self.pendingEventIndex < self.pendingEvents.count) {
                            self.event = self.pendingEvents[self.pendingEventIndex]
                            //self.populateCardDetails();
                            self.resetScreenToDefaultPosition();
                            self.swipeCardView.alpha = 1
                        } else {
                            self.navigationController?.popViewController(animated: false);
                        }
                    } else {
                        
                        //If owner is looking at the event and,
                        //its an existging event then we will popup this controller
                        if (self.event.eventId != nil) {
                            if (self.event.requestType == EventRequestType.EditEvent) {
                                //For owner, if its a new event, create new event
                                
                                //Lets check.
                                //If event has non cenes members.
                                //And we will open sms composer to send invitation link to non
                                //cenes memebers.
                                var nonCenesMembers = [EventMember]();
                                for mem in self.event.eventMembers {
                                    if (mem.userId == nil && mem.eventMemberId == nil) {
                                        nonCenesMembers.append(mem);
                                    }
                                }
                                if (nonCenesMembers.count > 0) {
                                    if MFMessageComposeViewController.canSendText() {
                                        var shareLinkActualtext = String(shareLinkText).replacingOccurrences(of: "[Host]", with: self.eventOwner.user.name)
                                        
                                        shareLinkActualtext = shareLinkActualtext.replacingOccurrences(of: "[Title]", with: self.event.title);
                                        
                                        let composeVC = MFMessageComposeViewController()
                                        composeVC.messageComposeDelegate = self
                                        
                                        // Configure the fields of the interface.
                                        var phoneNumbers = [String]();
                                        for nmem in nonCenesMembers {
                                            phoneNumbers.append("\(nmem.phone!)")
                                        }
                                        composeVC.recipients = phoneNumbers
                                        composeVC.body = "\(shareLinkActualtext)\r\n\(shareEventUrl)\(self.event.key!)"
                                        
                                        // Present the view controller modally.
                                        self.present(composeVC, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                                    }
                                }
                                
                                DispatchQueue.global(qos: .background).async {
                                    let imageToUpload = self.event.imageToUpload;
                                    GatheringService().createGathering(uploadDict: self.event.toDictionary(event: self.event), complete: {(response) in
                                        print("Saved Successfully...")
                                        let error = response.value(forKey: "Error") as! Bool;
                                        if (error == false) {
                                            let dataDict = response.value(forKey: "data") as! NSDictionary;
                                            
                                            if (imageToUpload != nil) {
                                                let eventId = dataDict.value(forKey: "eventId") as! Int32
                                                GatheringService().uploadEventImageV2(image: imageToUpload, eventId: eventId, loggedInUser: self.loggedInUser, complete: {(resp) in
                                                    print("Saved Uploaded...")
                                                    
                                                });
                                            }
                                            
                                        }
                                    });
                                    DispatchQueue.main.async {
                                        // Go back to the main thread to update the UI.
                                        if (nonCenesMembers.count == 0) {
                                            UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                                        }
                                        
                                    }
                                }
                            } else {
                                self.navigationController?.popViewController(animated: false);
                            }
                        } else {
                            
                            //Lets check.
                            //If event has non cenes members.
                            //Then we will create an event key from app and send it to server.
                            //And we will open sms composer to send invitation link to non
                            //cenes memebers.
                            var nonCenesMembers = [EventMember]();
                            for mem in self.event.eventMembers {
                                if (mem.userId == nil) {
                                    nonCenesMembers.append(mem);
                                }
                            }
                            if (nonCenesMembers.count > 0) {
                                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                                let eventKey = String((0..<32).map{ _ in letters.randomElement()! })
                                
                                if MFMessageComposeViewController.canSendText() {
                                    var shareLinkActualtext = String(shareLinkText).replacingOccurrences(of: "[Host]", with: self.eventOwner.user.name)
                                    
                                    shareLinkActualtext = shareLinkActualtext.replacingOccurrences(of: "[Title]", with: self.event.title);
                                    
                                    let composeVC = MFMessageComposeViewController()
                                    composeVC.messageComposeDelegate = self
                                    
                                    // Configure the fields of the interface.
                                    var phoneNumbers = [String]();
                                    for nmem in nonCenesMembers {
                                        phoneNumbers.append("\(nmem.phone!)")
                                    }
                                    composeVC.recipients = phoneNumbers;
                                    composeVC.body = "\(shareLinkActualtext)\r\n\(shareEventUrl)\(eventKey)"
                                    
                                    // Present the view controller modally.
                                    self.present(composeVC, animated: true, completion: nil)
                                } else {
                                    UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                                }
                                
                                self.event.key = "\(eventKey)";
                            }
                            
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
                                        
                                });
                                DispatchQueue.main.async {
                                    // Go back to the main thread to update the UI.
                                    //If user has no non cenes members then we will directly take him to
                                    //Home screen, Otherwise message box will open and user will then
                                    //redirect to home screen after action
                                    if (nonCenesMembers.count == 0) {
                                        self.navigationController?.popToRootViewController(animated: false);
                                    }
                                }
                            }
                        }
                    }
                });
                return;
            } else if (xFromCenter < -130) {
                //If user move the card to left for declining, then we will decline it.
                //Move card to left side
                UIView.animate(withDuration: 0.3, animations: {
                    //Decline invitation
                    if (self.isLoggedInUserAsOwner == false) {
                        self.swipeCardView.center = CGPoint(x: self.swipeCardView.center.x - 200, y: self.swipeCardView.center.y);
                        

                        self.swipeCardView.alpha = 0

                        let acceptQueryStr = "eventId=\(String(self.event.eventId))&userId=\(String(self.loggedInUser.userId))&status=NotGoing";
                        GatheringService().updateGatheringStatus(queryStr: acceptQueryStr, token: self.loggedInUser.token, complete: {(response) in
                            
                        });
                        
                        self.pendingEventIndex = self.pendingEventIndex + 1;
                        if (self.pendingEventIndex < self.pendingEvents.count) {
                            self.event = self.pendingEvents[self.pendingEventIndex]
                            self.resetScreenToDefaultPosition();
                            self.swipeCardView.alpha = 1;
                            //self.populateCardDetails();
                        } else {
                            self.navigationController?.popViewController(animated: false);
                        }
                        
                    } else {
                        if (self.event.eventId != nil) {
                            
                            if (self.event.requestType == EventRequestType.EditEvent) {
                                self.navigationController?.popViewController(animated: false);

                            } else {
                                self.swipeCardView.center = CGPoint(x: self.swipeCardView.center.x, y: self.swipeCardView.center.y);
                            }
                            
                        } else {
                            self.navigationController?.popViewController(animated: false);
                        }
                    }
                    
                });
                return;
            } else {
                self.resetScreenToDefaultPosition();
            }
        }
    }
    
    @objc func deleteGatheringPressed() {
        
        let alertController = UIAlertController(title: "Delete Event?", message: "Your guests will receive a notification if\nyou delete this event.", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "Delete", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            let queryStr = "event_id=\(String(self.event.eventId))";
            
            DispatchQueue.global(qos: .background).async {
                HomeService().removeEventFromList(queryStr: queryStr, token: self.loggedInUser.token!, complete: {(response) in
                });
            }
            self.navigationController?.popViewController(animated: false);
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in
            print("Cancel button tapped");
            
            self.resetScreenToDefaultPosition();
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
    
    @objc func editButtonPressed() {
        
        let viewController: CreateGatheringV2ViewController = storyboard?.instantiateViewController(withIdentifier: "CreateGatheringV2ViewController") as! CreateGatheringV2ViewController;
        viewController.event = event;
        self.navigationController?.pushViewController(viewController, animated: true);
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
            
            self.resetScreenToDefaultPosition();
            
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
    func skipCard() {
        //We will check if user swiped the card upto 200 Y axis
        //Then we will either bring the new card or popup to previous screen.
        pendingEventIndex = pendingEventIndex + 1;
        if (pendingEventIndex < pendingEvents.count) {
            self.event = pendingEvents[pendingEventIndex]
            //populateCardDetails();
            let indexPath = IndexPath.init(row: 0, section: 0);
            self.invitationCardTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            self.invitationCardTableView.reloadData();
            swipeCardView.center = self.view.center;
        } else {
            self.navigationController?.popViewController(animated: false);
        }
    }
    
    func resetScreenToDefaultPosition() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.swipeCardView.center = self.view.center;
            self.swipeCardView.transform = .identity
            self.acceptedImageView.alpha = 0;
            self.rejectedImageiew.alpha = 0;
            self.deleteImageView.alpha = 0;
        })
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil);
        
        //If its an edit event request then we will send user to Home screen
        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
    }
}

extension GatheringInvitationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return self.view.frame.height;
        }
        return 190;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell : InvitationCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InvitationCardTableViewCell") as! InvitationCardTableViewCell;
            cell.gatheringInvitaionViewControllerDelegate = self;
            
            for eventMember in self.event.eventMembers {
                //We have to check user id, because there may be users which are non cenes users
                if (eventMember.userId != nil && self.event.createdById == eventMember.userId) {
                    self.eventOwner = eventMember;
                    break;
                }
            }
            
            if (self.eventOwner == nil) {
                self.eventOwner = Event().getLoggedInUserAsEventMember();
            }
            
            if (self.eventOwner != nil) {
                if (self.eventOwner.user != nil && self.eventOwner.user.photo != nil) {
                    cell.chatProfilePic.sd_setImage(with: URL(string: self.eventOwner.user.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
                    cell.profilePic.sd_setImage(with: URL(string: self.eventOwner.user.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
                }
                if (self.eventOwner.userId == self.loggedInUser.userId) {
                    self.isLoggedInUserAsOwner = true;
                }
            }
            
            if (self.event.eventId != nil) {
                if (self.event.eventPicture != nil) {
                    cell.eventPicture.sd_setImage(with: URL(string: self.event.eventPicture));
                } else if (self.event.imageToUpload != nil) {
                    cell.eventPicture.image = self.event.imageToUpload;
                } else {
                    cell.eventPicture.image = nil;
                }
            } else {
                if (self.event.imageToUpload != nil) {
                    cell.eventPicture.image = self.event.imageToUpload;
                }
            }
            
            cell.evntTitle.text = self.event.title;
            
            let dateOfEvent = Date(milliseconds: Int(self.event!.startTime)).EMMMd()!;
            
            let timeOfEvent = "\(Date(milliseconds: Int(self.event!.startTime)).hmma())-\(Date(milliseconds: Int(self.event!.endTime)).hmma())"
            
            cell.eventTime.text = "\(dateOfEvent), \(timeOfEvent)";
            
            //This is the case when user view the existing invitation card.
            if (event.eventId != nil) {
                
                //IF the owner if lookingt at the card
                if (isLoggedInUserAsOwner == true) {
                    
                    //And if he is editing the card.
                    if (event.requestType == EventRequestType.EditEvent) {
                        editImageView.isHidden = true;
                        deleteImageView.isHidden = true;
                        rejectedImageiew.isHidden = false;
                    } else {
                        editImageView.isHidden = false;
                        deleteImageView.isHidden = false;
                        rejectedImageiew.isHidden = true;
                    }
                } else {
                    //If the guest if looking at the invitaiton card.
                    //Then in this case we will check case.
                    //1. If the guest did not take action on the card before, then he can swipe right or left
                    //2. If guest already accpted, then he can only declined the card
                    //3. If guest has already declined then he can onluy accept the card but cannot decline agian
                    
                    
                    editImageView.isHidden = true;
                    deleteImageView.isHidden = true;
                    rejectedImageiew.isHidden = false;
                    
                    //If the event is not owner of event
                    //And guest is viewing the card.
                    var loggedInUserEventMemObj = EventMember();
                    for eventMember in self.event.eventMembers {
                        //We have to check user id, because there may be users which are non cenes users
                        if (eventMember.userId != nil && self.loggedInUser.userId == eventMember.userId) {
                            loggedInUserEventMemObj = eventMember;
                            break;
                        }
                    }
                    
                    //Restricting swipe guestre
                    //if user already accepted the card then disable left to right gesture
                    if (loggedInUserEventMemObj.status == nil) {
                        leftToRightGestureEnabled = true;
                        rightToLeftGestureEnabled = true;
                    } else if (loggedInUserEventMemObj.status == "Going") {
                        leftToRightGestureEnabled = false;
                    } else if (loggedInUserEventMemObj.status == "NotGoing") {
                        rightToLeftGestureEnabled = false;
                    }
                }
            } else {
                editImageView.isHidden = true;
                deleteImageView.isHidden = true;
                rejectedImageiew.isHidden = false;
            }
            
            return cell;
        } else if (indexPath.row == 1) {
            
            let cell : NextCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NextCardTableViewCell") as! NextCardTableViewCell;
            cell.gatheringInvitationViewControllerDelegate = self;
            return cell;
            
        }
       
        return UITableViewCell();
    }
}
