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
import CoreData

protocol NewHomeViewControllerDeglegate {
    func refershDataFromOtherScreens();
}
class GatheringInvitationViewController: UIViewController, UIGestureRecognizerDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var acceptedImageView: UIImageView!
    
    @IBOutlet weak var acceptedSendInvitationLoaderView: UIView!
    
    @IBOutlet weak var acceptedSendInvitationLoader: UIImageView!
    
    @IBOutlet weak var sendInvitationImageView: UIImageView!
    
    @IBOutlet weak var rejectedImageiew: UIImageView!
    
    @IBOutlet weak var rejectedInvitationLoaderView: UIView!
    
    @IBOutlet weak var rejectedInvitationLoader: UIImageView!
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
    var newHomeViewControllerDeglegate: NewHomeViewController!;
    var fromPushNotificaiton = false;
    var isLoggedInUserInMemberList = false;
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1);
        self.invitationCardTableView.backgroundColor = themeColor;
        self.invitationCardTableView.register(UINib.init(nibName: "InvitationCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InvitationCardTableViewCell");
        self.invitationCardTableView.register(UINib.init(nibName: "WelcomeCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WelcomeCardTableViewCell");
        
        self.invitationCardTableView.register(UINib.init(nibName: "NextCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NextCardTableViewCell")

        self.invitationCardTableView.frame = self.view.bounds;
        
        //acceptedImageView.alpha = 0;
        
        self.acceptedImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
        self.rejectedImageiew.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
        self.sendInvitationImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);

        //rejectedImageiew.alpha = 0;
        deleteImageView.alpha = 0;
        nextScreenArrow.alpha = 0;
        editImageView.alpha = 0;
        sendInvitationImageView.alpha = 0;
        
        //35 degree angle from center
        divisor = ((self.view.frame.width / 2) / 0.34)
        // Do any additional setup after loading the view.
        
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        context = self.appDelegate.persistentContainer.viewContext

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
        //acceptedImageView.alpha = 0;
        self.acceptedImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
        self.rejectedImageiew.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
         self.sendInvitationImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
        //rejectedImageiew.alpha = 0;
        nextScreenArrow.alpha = 0;
        deleteImageView.alpha = 0;
        sendInvitationImageView.alpha = 0;

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
        navigationController?.navigationBar.isHidden = true;
        tabBarController?.tabBar.isHidden = true;
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);

        if (event.eventId != nil && event.eventId != 0) {
            GatheringService().eventInfoTask(eventId: Int64(event!.eventId), complete: {(response) in
                
                let success = response.value(forKey: "success") as! Bool;
                if (success == true) {
                    if (response.value(forKey: "data") != nil) {
                        let data = response.value(forKey: "data") as! NSDictionary;
                        let eventTemp = EventModel().updateEventManagedObjectFromDictionary(eventDict: data);
                        
                        if (self.fromPushNotificaiton == true) {
                            self.isLoggedInUserAsOwner = false;
                            self.leftToRightGestureEnabled = true;
                            self.rightToLeftGestureEnabled = true;
                            
                            self.event = eventTemp;
                            
                        } else {
                            if (self.event.requestType != EventRequestType.EditEvent) {
                                self.event.eventPicture = eventTemp.eventPicture;
                            }
                            if (eventTemp.eventMembers != nil) {
                                
                                for eventMemFromDb in eventTemp.eventMembers! {
                                    
                                    var editMembersIndex = 0;
                                    for eveMemFromEdit in self.event.eventMembers! {
                                        
                                        if (eventMemFromDb.userContactId != nil && eventMemFromDb.userContactId != 0 && eventMemFromDb.userContactId == eveMemFromEdit.userContactId) {
                                            
                                            self.event.eventMembers[editMembersIndex] = eventMemFromDb;
                                            //self.event.removeFromEventMembers(eveMemFromEditMO);
                                            //self.event.addToEventMembers(eventMemFromDbMO);
                                            break;
                                            
                                        }
                                        editMembersIndex  = editMembersIndex + 1;
                                    }
                                }
                            }
                            
                            self.event.thumbnail = eventTemp.thumbnail;
                        }
                        self.invitationCardTableView.reloadData();
                    }
                }
            });
        } else if (event.key != nil) {
            
            
            GatheringService().getEventInfoByKey(pathVariable: event.key!, token: loggedInUser.token!, complete: {(response) in
                
                let success = response.value(forKey: "success") as! Bool;
                if (success == true) {
                    if (response.value(forKey: "data") != nil) {
                        let data = response.value(forKey: "data") as! NSDictionary;
                        let eventTemp = EventModel().updateEventManagedObjectFromDictionary(eventDict: data);
                        
                        if (self.fromPushNotificaiton == true) {
                            self.isLoggedInUserAsOwner = false;
                            self.leftToRightGestureEnabled = true;
                            self.rightToLeftGestureEnabled = true;
                            
                            self.event = eventTemp;
                            
                        } else {
                            if (self.event.requestType != EventRequestType.EditEvent) {
                                self.event.eventPicture = eventTemp.eventPicture;
                            }
                            
                            if (eventTemp.eventMembers != nil) {
                                
                                for eventMemFromDb in eventTemp.eventMembers! {
                                    
                                    //var eventMemFromDbMO = eventMemFromDb as! EventMemberMO;
                                    var editMembersIndex = 0;
                                    for eveMemFromEdit in self.event.eventMembers! {
                                        
                                        //var eveMemFromEditMO = eveMemFromEdit as! EventMemberMO;
                                        if (eventMemFromDb.userContactId == eveMemFromEdit.userContactId) {
                                            self.event.eventMembers[editMembersIndex] = eventMemFromDb;
                                            //self.event.removeFromEventMembers(eveMemFromEditMO);
                                            //self.event.addToEventMembers(eventMemFromDbMO);

                                            break;
                                        }
                                        editMembersIndex  = editMembersIndex + 1;
                                    }
                                }
                            }
                            
                            self.event.thumbnail = eventTemp.thumbnail;
                        }
                        self.invitationCardTableView.reloadData();
                    }
                }
            });
        }
        /*if (event != nil && event.imageToUpload != nil) {
            print("Uploading Startsss")
            self.uploadImageAndGetUrl();
            print("Uploading Endss")
        }*/
    }
    
    @objc func panRecognizer(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        let xFromCenter = swipeCardView.center.x - self.view.center.x;

        print("State : ", sender.state.rawValue);
        
        //This marks the beginning of Gesture Begin.
        if (sender.state == UIGestureRecognizerState.began) {
            
            self.acceptedSendInvitationLoaderView.isHidden = true;
            self.rejectedInvitationLoaderView.isHidden = true;
            
            var gestureIsDraggingFromLeftToRight = (sender.velocity(in: view).x > 0)
            if (gestureIsDraggingFromLeftToRight == true && leftToRightGestureEnabled == false) {
                //If user stated swiping from left to right
                //We will not move the screen and set its position at center
                sender.setTranslation(CGPoint.zero, in: self.view)
            }
            
            if (gestureIsDraggingFromLeftToRight == false && rightToLeftGestureEnabled == false) {
                sender.setTranslation(CGPoint.zero, in: self.view)

            }
        }
        
        //This will be called when card is swiped.
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
                //acceptedImageView.alpha = acceptedAlpha;
                if (acceptedAlpha > 1) {
                    self.acceptedImageView.transform = CGAffineTransform(scaleX: 1, y: 1);
                    self.sendInvitationImageView.transform = CGAffineTransform(scaleX: 1, y: 1);
                } else {
                    self.acceptedImageView.transform = CGAffineTransform(scaleX: acceptedAlpha, y: acceptedAlpha);
                    self.sendInvitationImageView.transform = CGAffineTransform(scaleX: acceptedAlpha, y: acceptedAlpha);
                    self.sendInvitationImageView.alpha = acceptedAlpha;
                }

                //sendInvitationImageView.alpha = acceptedAlpha;
            } else if (translation.x < -10 && rightToLeftGestureEnabled == true) { //Card is swiped right
                swipeCardView.center = CGPoint(x: view.center.x + translation.x, y: view.center.y);
                
                print(xFromCenter)
                swipeCardView.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor);
                
                let rejectedAlpha = abs(xFromCenter) / self.view.center.x;
                //rejectedImageiew.alpha = rejectedAlpha;
                
                if (rejectedAlpha > 1) {
                    self.rejectedImageiew.transform = CGAffineTransform(scaleX: 1, y: 1);
                } else {
                    self.rejectedImageiew.transform = CGAffineTransform(scaleX: rejectedAlpha, y: rejectedAlpha);
                }

                if (isLoggedInUserAsOwner == true) {
                    let deletedAlpha = abs(xFromCenter) / self.view.center.x;
                    deleteImageView.alpha = deletedAlpha;
                    editImageView.alpha = deletedAlpha;
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
                self.acceptedImageView.transform = CGAffineTransform(scaleX: 1, y: 1);
                self.sendInvitationImageView.transform = CGAffineTransform(scaleX: 1, y: 1);

                self.acceptedSendInvitationLoaderView.isHidden = false

                UIView.animate(withDuration: 0.3, animations: {
                     self.acceptedSendInvitationLoaderView.startRotatingView(duration: 0.5, repeatCount: 1, clockwise: true);
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        // your code here
                        self.acceptedSendInvitationLoaderView.stopRotatingView();
                        
                        //Now lets move the card away by making it invisibleas it goes away
                        self.swipeCardView.center = CGPoint(x: self.swipeCardView.center.x + 200, y: self.swipeCardView.center.y);
                        self.swipeCardView.alpha = 0;
                        
                        //For other users accept gathering
                        if (self.isLoggedInUserAsOwner == false) {
                            
                            if (self.event.scheduleAs == EventScheduleAs.NOTIFICATION) {
                                self.navigationController?.popViewController(animated: true);
                            } else {
                                
                                //Update EventMEmber status in CoreData EventMember table
                                EventMemberModel().updateEventMemberStatus(eventId: self.event.eventId, userId: self.loggedInUser.userId, status: "Going");
                                
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
                                    
                                    self.invitationCardTableView.reloadData();
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        self.invitationCardTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true);
                                    });
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
                                } else {
                                    
                                    /*if (self.event.eventClickedFrom == EventClickedFrom.Gathering) {
                                     UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                                     } else {
                                     self.navigationController?.popViewController(animated: false);
                                     }*/
                                    //This is called when the user is from home screen
                                    
                                    //This is needed when user clciked on push notification.
                                    if (self.fromPushNotificaiton == true) {
                                        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                                    
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
                                        });
                                    } else {
                                        if (self.newHomeViewControllerDeglegate != nil) {
                                            self.newHomeViewControllerDeglegate.refershDataFromOtherScreens();
                                            self.navigationController?.popViewController(animated: true);
                                            
                                        } else {
                                            if (self.tabBarController != nil) {

                                                if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                                                    
                                                    let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                                                    homeViewController?.refershDataFromOtherScreens();
                                                    self.navigationController?.popViewController(animated: true);
                                                }
                                            }
                                        }
                                    }
                                }

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
                                    for mem in self.event.eventMembers! {
                                        if (mem.userId == nil && mem.eventMemberId == nil) {
                                            
                                            nonCenesMembers.append(mem);
                                        }
                                    }
                                    if (nonCenesMembers.count > 0) {
                                        if MFMessageComposeViewController.canSendText() {
                                            var shareLinkActualtext = String(shareLinkText).replacingOccurrences(of: "[Host]", with: String(self.eventOwner.user!.name!));
                                            
                                            shareLinkActualtext = shareLinkActualtext.replacingOccurrences(of: "[Title]", with: self.event.title!);
                                            
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
                                        
                                        let eventDict = self.event.toDictionary(event: self.event);
                                        print(eventDict);
                                        GatheringService().createGathering(uploadDict: eventDict, complete: {(response) in
                                            print("Saved Successfully...")
                                            let error = response.value(forKey: "Error") as! Bool;
                                            if (error == false) {
                                                let dataDict = response.value(forKey: "data") as! NSDictionary;
                                                
                                                /*if (imageToUpload != nil) {
                                                    let eventId = dataDict.value(forKey: "eventId") as! Int32
                                                    GatheringService().uploadEventImageV2(image: imageToUpload, eventId: eventId, loggedInUser: self.loggedInUser, complete: {(resp) in
                                                        print("Saved Uploaded...")
                                                        
                                                    });
                                                }*/
                                                
                                            }
                                        });
                                        DispatchQueue.main.async {
                                            // Go back to the main thread to update the UI.
                                            if (nonCenesMembers.count == 0) {
                                                //UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                                                
                                                //This is called when the user is from home screen
                                                if (self.newHomeViewControllerDeglegate != nil) {
                                                    self.navigationController?.popToRootViewController(animated: true);
                                                   
                                                    //DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                            //self.newHomeViewControllerDeglegate.refershDataFromOtherScreens();
                                                    //}
                                                    //self.navigationController?.popViewController(animated: true);
                                                    //UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                                                    
                                                } else {
                                                    if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                                                        
                                                        let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                                                        self.navigationController?.popToRootViewController(animated: true);
                                                        //DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                        //    homeViewController!.refershDataFromOtherScreens();
                                                        //}
                                                        //UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                                                        
                                                    }
                                                }
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
                                for mem in self.event.eventMembers! {
                                    if (mem.userId == nil || mem.userId == 0) {
                                        nonCenesMembers.append(mem);
                                    }
                                }
                                if (nonCenesMembers.count > 0) {
                                    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                                    let eventKey = String((0..<32).map{ _ in letters.randomElement()! })
                                    
                                    if MFMessageComposeViewController.canSendText() {
                                        var shareLinkActualtext = String(shareLinkText).replacingOccurrences(of: "[Host]", with: String(self.eventOwner.user!.name!));
                                        
                                        shareLinkActualtext = shareLinkActualtext.replacingOccurrences(of: "[Title]", with: self.event.title!);
                                        
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
                                    
                                    //If its the first time. Lets take out the owner from event and let the backend handle it.
                                    var index = 0;
                                    for eventmem in self.event.eventMembers! {
                                        if (eventmem.userId == self.loggedInUser.userId) {
                                            self.event.eventMembers.remove(at: index);
                                            index = index + 1;
                                        }
                                    }
                                    
                                    if (Connectivity.isConnectedToInternet) {
                                        
                                        let eventDict = self.event.toDictionary(event: self.event);
                                        print(eventDict);
                                        GatheringService().createGathering(uploadDict: eventDict, complete: {(response) in

                                            print("Saved Successfully...")
                                            
                                            /*let error = response.value(forKey: "Error") as! Bool;
                                            if (error == false && imageToUpload != nil) {
                                                let dataDict = response.value(forKey: "data") as! NSDictionary;
                                                let eventId = dataDict.value(forKey: "eventId") as! Int32
                                                GatheringService().uploadEventImageV2(image: imageToUpload, eventId: eventId, loggedInUser: self.loggedInUser, complete: {(resp) in
                                                    print("Saved Uploaded...")
                                                    
                                                });
                                            }*/
                                            
                                        });

                                    } else {
                                        EventModel().saveNewEventModelOffline(event: self.event, user: self.loggedInUser);
                                    }
                                    
                                }
                                
                                //DispatchQueue.main.async {
                                    // Go back to the main thread to update the UI.
                                    //If user has no non cenes members then we will directly take him to
                                    //Home screen, Otherwise message box will open and user will then
                                    //redirect to home screen after action
                                    if (nonCenesMembers.count == 0) {
                                        //self.navigationController?.popToRootViewController(animated: false);
                                        //This is called when the user is from home screen
                                        if (self.newHomeViewControllerDeglegate != nil) {
                                            self.newHomeViewControllerDeglegate.refershDataFromOtherScreens();
                                            //self.navigationController?.popViewController(animated: true);
                                            UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                                            
                                        } else {
                                            if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                                                
                                                let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                                                homeViewController?.refershDataFromOtherScreens();
                                                //self.navigationController?.popViewController(animated: true);
                                                UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                                            }
                                        }
                                    }
                                //}
                                //}
                            }
                        }
                    }
                    return;
                });
            } else if (xFromCenter < -130) {
                //If user move the card to left for declining, then we will decline it.
                //Move card to left side
                UIView.animate(withDuration: 0.3, animations: {
                    //Decline invitation
                    
                    if (self.isLoggedInUserAsOwner == true && self.event.eventId != nil && self.event.eventId != 0) {
                        self.rejectedInvitationLoaderView.isHidden = true;
                    } else {
                        self.rejectedInvitationLoaderView.isHidden = false;
                        self.rejectedImageiew.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                    }
                    
                    self.rejectedInvitationLoaderView.startRotatingView(duration: 0.5, repeatCount: 1, clockwise: true);
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        // your code here
                        self.rejectedInvitationLoaderView.stopRotatingView();

                        if (self.isLoggedInUserAsOwner == false) {
                            
                            self.swipeCardView.center = CGPoint(x: self.swipeCardView.center.x - 200, y: self.swipeCardView.center.y);
                            
                            self.swipeCardView.alpha = 0
                            
                            if (self.event.scheduleAs == EventScheduleAs.NOTIFICATION) {
                                self.navigationController?.popViewController(animated: true);
                            } else {
                                
                                //Update EventMEmber status in CoreData EventMember table
                                EventMemberModel().updateEventMemberStatus(eventId: self.event.eventId, userId: self.loggedInUser.userId, status: "NotGoing");
                                
                                let acceptQueryStr = "eventId=\(String(self.event.eventId))&userId=\(String(self.loggedInUser.userId))&status=NotGoing";
                                GatheringService().updateGatheringStatus(queryStr: acceptQueryStr, token: self.loggedInUser.token, complete: {(response) in
                                    
                                });
                                
                                self.pendingEventIndex = self.pendingEventIndex + 1;
                                if (self.pendingEventIndex < self.pendingEvents.count) {
                                    self.event = self.pendingEvents[self.pendingEventIndex]
                                    self.resetScreenToDefaultPosition();
                                    self.swipeCardView.alpha = 1;
                                    //self.populateCardDetails();
                                    self.invitationCardTableView.reloadData();
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        self.invitationCardTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true);
                                    });
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)

                                    
                                } else {
                                    /*if (self.event.eventClickedFrom == EventClickedFrom.Gathering) {
                                     UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                                     } else {
                                     self.navigationController?.popViewController(animated: false);
                                     }*/
                                    
                                    
                                    if (self.fromPushNotificaiton == true) {
                                        
                                        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
                                        });
                                    } else {
                                        //This is called when the user is from home screen
                                        if (self.newHomeViewControllerDeglegate != nil) {
                                            self.newHomeViewControllerDeglegate.refershDataFromOtherScreens();
                                            self.navigationController?.popViewController(animated: true);
                                            
                                        } else {
                                            if (self.tabBarController != nil) {
                                                
                                                if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                                                    
                                                    let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                                                    homeViewController?.refershDataFromOtherScreens();
                                                    self.navigationController?.popViewController(animated: true);
                                                    
                                                }

                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            if (self.event.eventId != nil && self.event.eventId != 0) {
                                
                                if (self.event.requestType == EventRequestType.EditEvent) {
                                    //self.navigationController?.popViewController(animated: true);
                                    
                                } else {
                                    self.swipeCardView.center = CGPoint(x: self.swipeCardView.center.x, y: self.swipeCardView.center.y);
                                }
                                
                            } else {
                                self.navigationController?.popViewController(animated: false);
                            }
                        }
                    };
                    return;
                });
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
            //self.navigationController?.popViewController(animated: false);
            
            //This is called when the user is from home screen
            if (self.newHomeViewControllerDeglegate != nil) {
                self.newHomeViewControllerDeglegate.refershDataFromOtherScreens();
                self.navigationController?.popViewController(animated: false);
                
            } else {
                if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                    
                    let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                    homeViewController?.refershDataFromOtherScreens();
                    self.navigationController?.popViewController(animated: true);
                    
                }
            }
            
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.invitationCardTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true);
            });
            swipeCardView.center = self.view.center;
        } else {
            
            if (self.isLoggedInUserInMemberList == false) {
                
                let acceptQueryStr = "eventId=\(String(self.event.eventId))&userId=\(String(self.loggedInUser.userId))&status=pending]";
                GatheringService().updateGatheringStatus(queryStr: acceptQueryStr, token:
                    
                    self.loggedInUser.token, complete: {(response) in
                        
                });
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
                    self.navigationController?.popViewController(animated: false);

                })
            }
            
            if (fromPushNotificaiton == true) {
                UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
            } else {
                self.navigationController?.popViewController(animated: false);
            }
        }
    }
    
    func resetScreenToDefaultPosition() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.swipeCardView.center = self.view.center;
            self.swipeCardView.transform = .identity
            //self.acceptedImageView.alpha = 0;
            //self.rejectedImageiew.alpha = 0;
            
            self.acceptedImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
            self.rejectedImageiew.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);

            self.deleteImageView.alpha = 0;
            self.editImageView.alpha = 0;
            self.sendInvitationImageView.alpha = 0;
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
    
    /*func uploadImageAndGetUrl() {
        
        GatheringService().uploadEventImageV3(image: event.imageToUpload!, loggedInUser: self.loggedInUser, complete: {(response) in
            
            let success = response.value(forKey: "success") as! Bool;
            if (success == true) {
                
                if (response.value(forKey: "data") != nil) {
                    
                    let images = response.value(forKey: "data") as! NSDictionary;
                    
                    if (images.value(forKey: "large") != nil) {
                        self.event.eventPicture = images.value(forKey: "large") as! String;
                    }
                    
                    if (images.value(forKey: "thumbnail") != nil) {
                        self.event.thumbnail = images.value(forKey: "thumbnail") as! String;
                    } else {
                        self.event.thumbnail = images.value(forKey: "large") as! String;
                    }
                    
                    //self.event.imageToUpload = nil;
                }
                
            }
            
        });
    }*/
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
            
            if (event.scheduleAs == EventScheduleAs.NOTIFICATION) {
                    
                let cell : WelcomeCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCardTableViewCell") as! WelcomeCardTableViewCell;
                
                return cell;
                
            }
            let cell : InvitationCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InvitationCardTableViewCell") as! InvitationCardTableViewCell;
            cell.gatheringInvitaionViewControllerDelegate = self;
            
            if ((event.eventId == nil || event.eventId == 0) && event.key == nil) {
                cell.shareView.isHidden = true;
            } else {
                cell.shareView.isHidden = false;
            }
            
            if (event.eventMembers != nil) {
                
                print("Event Id : ",event.eventId,  "Event Members Count : ",self.event.eventMembers!.count)
                for eventMember in self.event.eventMembers {
                    print(eventMember.name);
                }
                
                for eventMember in self.event.eventMembers {
                    
                    //We have to check user id, because there may be users which are non cenes users
                    if (eventMember.userId != nil && eventMember.userId != 0 && eventMember.userId == loggedInUser.userId) {
                        isLoggedInUserInMemberList = true;
                        break;
                    }
                }
                
                if (self.isLoggedInUserInMemberList == false) {
                    let eventMember = EventMember()
                    eventMember.eventId = event.eventId;
                    eventMember.userId = loggedInUser.userId;
                    eventMember.user = loggedInUser;
                    eventMember.cenesMember = "yes";
                    eventMember.name = loggedInUser.name;
                    event.eventMembers.append(eventMember);
                }

                
                for eventMember in self.event.eventMembers {
                    //We have to check user id, because there may be users which are non cenes users
                    if (eventMember.userId != nil && eventMember.userId != 0 && self.event.createdById == eventMember.userId) {
                        self.eventOwner = eventMember;
                        break;
                    }
                }
            }
            
            if (self.eventOwner == nil) {
                self.eventOwner = Event().getLoggedInUserAsEventMember();
            }
            
            if (self.eventOwner != nil) {
                if (self.eventOwner.user != nil && self.eventOwner.user!.photo != nil) {
                    cell.chatProfilePic.sd_setImage(with: URL(string: self.eventOwner.user!.photo!), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
                    cell.profilePic.sd_setImage(with: URL(string: self.eventOwner.user!.photo!), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
                } else {
                    cell.chatProfilePic.image = UIImage.init(named: "profile_pic_no_image");
                    cell.profilePic.image = UIImage.init(named: "profile_pic_no_image");
                }
                if (self.eventOwner.userId == self.loggedInUser.userId) {
                    self.isLoggedInUserAsOwner = true;
                }
            }
            
            if Connectivity.isConnectedToInternet {
                
                if (self.event.eventPicture != nil) {
                                      
                      if (self.event.thumbnail != nil) {
                       cell.eventPicture.sd_setImage(with: URL(string: self.event.eventPicture!), placeholderImage: UIImage.init(url: URL(string: self.event.thumbnail!)));
                      } else {
                       cell.eventPicture.sd_setImage(with: URL(string: self.event.eventPicture!));
                       }
                }

            } else {
                
                if (event.eventPictureBinary != nil) {
                    cell.eventPicture.image = UIImage.init(data: event.eventPictureBinary);
                }
            }
            
            /*if (self.event.eventId != nil) {
                
                if (self.event.imageToUpload != nil) {
                    cell.eventPicture.image = self.event.imageToUpload;
                } else {
                    /*if ((self.event.thumbnail) != nil) {
                        cell.eventPicture.sd_setImage(with: URL(string: self.event.thumbnail), placeholderImage: UIImage.init(url: URL(string: self.event.thumbnail)));
                    }*/
                    
                    if (self.event.eventPicture != nil) {
                        
                        if (self.event.thumbnail != nil) {
                            cell.eventPicture.sd_setImage(with: URL(string: self.event.eventPicture), placeholderImage: UIImage.init(url: URL(string: self.event.thumbnail)));
                        } else {
                            cell.eventPicture.sd_setImage(with: URL(string: self.event.eventPicture));
                        }
                        
                    } else if (self.event.imageToUpload != nil) {
                        cell.eventPicture.image = self.event.imageToUpload;
                    } else {
                        cell.eventPicture.image = UIImage.init(named: "invitation_default");
                    }
                }
            } else {
                if (self.event.imageToUpload != nil) {
                    cell.eventPicture.image = self.event.imageToUpload;
                }
            }*/
            
            cell.evntTitle.text = self.event.title;
            
            let dateOfEvent = Date(milliseconds: Int(self.event!.startTime)).EMMMd()!;
            
            let timeOfEvent = "\(Date(milliseconds: Int(self.event!.startTime)).hmma())-\(Date(milliseconds: Int(self.event!.endTime)).hmma())"
            
            cell.eventTime.text = "\(dateOfEvent), \(timeOfEvent)";
            
            //This is the case when user view the existing invitation card.
            if (event.eventId != nil && event.eventId != 0) {
                
                //IF the owner if lookingt at the card
                if (isLoggedInUserAsOwner == true) {
                    
                    //And if he is editing the card.
                    if (event.requestType == EventRequestType.EditEvent) {
                        
                        acceptedImageView.isHidden = true;
                        editImageView.isHidden = true;
                        deleteImageView.isHidden = false;
                        
                        sendInvitationImageView.isHidden = false;
                        editImageView.isHidden = false;
                        rejectedImageiew.isHidden = true;
                    } else {
                        
                        //If logged in user is the owner
                        //Then he cannot accept the card.
                        //So left to right swipe should be freezed
                        leftToRightGestureEnabled = false;
                        
                        //if user is accepting or rejecting the card.
                        editImageView.isHidden = false;
                        deleteImageView.isHidden = false;
                        sendInvitationImageView.isHidden = true;

                        acceptedImageView.isHidden = false;
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
                    for eventMember in self.event.eventMembers! {
                        //We have to check user id, because there may be users which are non cenes users
                        if (eventMember.userId != nil && eventMember.userId != 0 && self.loggedInUser!.userId == eventMember.userId) {
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
                
                print(self.event.description);
                if (self.event.expired == true || !Connectivity.isConnectedToInternet) {
                    leftToRightGestureEnabled = false;
                    rightToLeftGestureEnabled = false;
                }
            } else {
                
                //This is the case when its a new card.
                //And owner is about to create new invitation
                editImageView.isHidden = false; // We will hide the edit option
                deleteImageView.isHidden = true; //We will hide the delete option
                acceptedImageView.isHidden = true; //We will hide the accept option
                
                sendInvitationImageView.isHidden = false;
                rejectedImageiew.isHidden = true;
            }
            
            self.acceptedSendInvitationLoaderView.isHidden = true;
            self.rejectedInvitationLoaderView.isHidden = true;

            return cell;
        } else if (indexPath.row == 1) {
            
            let cell : NextCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NextCardTableViewCell") as! NextCardTableViewCell;
            cell.gatheringInvitationViewControllerDelegate = self;
            return cell;
        }
       
        return UITableViewCell();
    }
}
