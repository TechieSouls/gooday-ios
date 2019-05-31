//
//  GatheringInvitationViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GatheringInvitationViewController: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var acceptedImageView: UIImageView!
    
    @IBOutlet weak var rejectedImageiew: UIImageView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1);
        self.invitationCardTableView.backgroundColor = themeColor;
        self.invitationCardTableView.register(UINib.init(nibName: "InvitationCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InvitationCardTableViewCell")
        self.invitationCardTableView.register(UINib.init(nibName: "NextCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NextCardTableViewCell")

        self.invitationCardTableView.frame = self.view.bounds;
        
        acceptedImageView.alpha = 0;
        rejectedImageiew.alpha = 0;
        nextScreenArrow.alpha = 0;
        
        //35 degree angle from center
        divisor = ((self.view.frame.width / 2) / 0.34)
        // Do any additional setup after loading the view.
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        let swipeleftGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panRecognizer))
        swipeCardView.addGestureRecognizer(swipeleftGesture)
        
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
        //print(translation.x)
        /*if (translation.x < 5 && translation.x > -5 && translation.y < 0) {
            swipeCardView.center = CGPoint(x: view.center.x , y: view.center.y + translation.y);
        } else*/
        let xFromCenter = swipeCardView.center.x - self.view.center.x;
        if (translation.x >  10) { //Card is swiped right
            swipeCardView.center = CGPoint(x: view.center.x+translation.x, y: view.center.y);
            
            print(xFromCenter)
            swipeCardView.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor);
            
            let acceptedAlpha = abs(xFromCenter) / self.view.center.x;
            acceptedImageView.alpha = acceptedAlpha;

        } else if (translation.x < -10) { //Card is swiped right
            swipeCardView.center = CGPoint(x: view.center.x + translation.x, y: view.center.y);
            
            print(xFromCenter)
            swipeCardView.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor);
            
            let rejectedAlpha = abs(xFromCenter) / self.view.center.x;
            rejectedImageiew.alpha = rejectedAlpha;
        }
        
        //The inviation card will move to center when the finger is up
        if (sender.state == UIGestureRecognizerState.ended) {
            
            print("Swipe Card Center : ",swipeCardView.center.x);
            print("Swipe Center", swipeCardView.center.x, "View Center" ,view.center.x)
            if (xFromCenter > 150) {
                //Move card to right side
                print("Inside right gesture...")
                UIView.animate(withDuration: 0.3, animations: {
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
                            UIView.animate(withDuration: 0.3, animations: {
                                self.swipeCardView.center = self.view.center;
                                self.swipeCardView.transform = .identity
                                self.acceptedImageView.alpha = 0;
                                self.rejectedImageiew.alpha = 0;
                            })
                            self.swipeCardView.alpha = 1
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
            } else if (xFromCenter < -150) {
                //If user move the card to left for declining, then we will decline it.
                //Move card to left side
                UIView.animate(withDuration: 0.3, animations: {
                    self.swipeCardView.center = CGPoint(x: self.swipeCardView.center.x - 200, y: self.swipeCardView.center.y);
                    self.swipeCardView.alpha = 0
                    
                    //Decline invitation
                    if (self.isLoggedInUserAsOwner == false) {
                        let acceptQueryStr = "eventId=\(String(self.event.eventId))&userId=\(String(self.loggedInUser.userId))&status=NotGoing";
                        GatheringService().updateGatheringStatus(queryStr: acceptQueryStr, token: self.loggedInUser.token, complete: {(response) in
                            
                        });
                        
                        self.pendingEventIndex = self.pendingEventIndex + 1;
                        if (self.pendingEventIndex < self.pendingEvents.count) {
                            self.event = self.pendingEvents[self.pendingEventIndex]
                            UIView.animate(withDuration: 0.2, animations: {
                                self.swipeCardView.center = self.view.center;
                                self.swipeCardView.transform = .identity
                                self.acceptedImageView.alpha = 0;
                                self.rejectedImageiew.alpha = 0;
                            });
                            self.swipeCardView.alpha = 1;
                            //self.populateCardDetails();
                        } else {
                            self.navigationController?.popViewController(animated: false);
                        }
                        
                    } else {
                        self.navigationController?.popViewController(animated: false);
                    }
                    
                });
                return;
            } else {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.swipeCardView.center = self.view.center;
                    self.swipeCardView.transform = .identity
                    self.acceptedImageView.alpha = 0;
                    self.rejectedImageiew.alpha = 0;
                })
            }
        }
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
            
                UIView.animate(withDuration: 0.2, animations: {
                    self.imageCard.center = self.view.center;
                    self.imageCard.transform = .identity
                    self.acceptedImageView.alpha = 0;
                    self.rejectedImageiew.alpha = 0;
                })
            
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
            event = pendingEvents[pendingEventIndex]
            //populateCardDetails();
            imageCard.center = self.view.center;
        } else {
            self.navigationController?.popViewController(animated: false);
        }
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
            
            return cell;
        } else if (indexPath.row == 1) {
            
            let cell : NextCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NextCardTableViewCell") as! NextCardTableViewCell;
            cell.gatheringInvitationViewControllerDelegate = self;
            return cell;
            
        }
       
        return UITableViewCell();
    }
}
