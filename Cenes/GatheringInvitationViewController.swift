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
import Mixpanel

protocol NewHomeViewControllerDeglegate {
    func refershDataFromOtherScreens();
}
class GatheringInvitationViewController: UIViewController, UIGestureRecognizerDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {

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
    
    @IBOutlet weak var buttonsView: UIView!
    
    var chatBoxView: ChatBoxView!;
    var chatFeatureView: ChatFeatureView!;
    var tapToChatView: TapToChatView!;
    
    var divisor : CGFloat!;
    var event: Event!;
    var eventChats: [EventChat] = [EventChat]();
    var eventChatDateKeys: [String] = [String]();
    var eventChatAndDateMap: [String: [EventChat]] = [String: [EventChat]]();
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
    var isNewEvent: Bool = false;
    var isKeyboardVisible = false;
    var gapBetweenChatBubbles: CGFloat = 11.0;
    var paddingBetweenChatTextAndBubble: CGFloat = 8.0;
    var minBubbleWidth: CGFloat = 80.0;
    var inputChatMessageText: String = "";
    var selectedEventChatDto : SelectedEventChatDto!;
    var chatViewItemAndHeight = [[CGFloat: String]]();
    var locationPhotos = [LocationPhoto]();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1);
        self.invitationCardTableView.backgroundColor = themeColor;
        self.invitationCardTableView.register(UINib.init(nibName: "InvitationCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InvitationCardTableViewCell");
        self.invitationCardTableView.register(UINib.init(nibName: "WelcomeCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WelcomeCardTableViewCell");
        self.invitationCardTableView.register(UINib.init(nibName: "NextCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NextCardTableViewCell")

        self.invitationCardTableView.frame = self.view.bounds;
                
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
        //context = self.appDelegate.persistentContainer.viewContext

        let swipeleftGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panRecognizer))
        swipeCardView.addGestureRecognizer(swipeleftGesture)
    
        let deleteGesture = UITapGestureRecognizer.init(target: self, action: #selector(deleteGatheringPressed))
        deleteImageView.addGestureRecognizer(deleteGesture)

        let editGesture = UITapGestureRecognizer.init(target: self, action: #selector(editButtonPressed))
        editImageView.addGestureRecognizer(editGesture)

        if (pendingEvents.count > 0) {
            event = pendingEvents[pendingEventIndex];
        }
        
        let outsideTabGuestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(cardPressed));
        buttonsView.addGestureRecognizer(outsideTabGuestureRecognizer);
        
        if (event.eventId != nil && event.eventId != 0 && self.event.title != nil) {
            Mixpanel.mainInstance().track(event: "Invitation",
            properties:[ "Action" : "View Invitation Card", "Title":"\(self.event.title!)", "UserEmail": "\(self.loggedInUser.email!)", "UserName": "\(self.loggedInUser.name!)"]);
        } else {
            isNewEvent = true;
        }
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        self.hideKeyboardWhenTappedAround();
        self.hideKeyboardWhenTappedOnTableviewAround(tableViewArea: invitationCardTableView);
        
        if (event.eventId != nil && event.startTime < Date().millisecondsSince1970) {
            event.expired = true;
            sqlDatabaseManager.updateExpiredStatusByEventId(event: event);
        }
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

        if (event.placeId != nil && event.placeId != "") {
            self.fetchLocationPhotos(placeId: event.placeId);
        }
        if (event.eventId != nil && event.eventId != 0) {
            
            let apiEndpoint = "\(apiUrl)\(GatheringService().get_gathering_data)";
            let queryStr = "eventId=\(self.event.eventId!)&userId=\(self.loggedInUser.userId!)";
            GatheringService().gatheringCommonGetAPI(api: apiEndpoint, queryStr: queryStr, token: self.loggedInUser.token, complete: {(response) in
                
                let success = response.value(forKey: "success") as! Bool;
                if (success == true) {
                    if (response.value(forKey: "data") != nil) {
                        let data = response.value(forKey: "data") as! NSDictionary;
                        let eventTemp = Event().loadEventData(eventDict: data);
                        sqlDatabaseManager.updateEventByEventId(eventId: eventTemp.eventId, eventFromApi: eventTemp);
                        
                        //After updating the latest info lets refres invitation tab data
                         //if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                            
                          //  var isNewControllerFound: Bool = false;
                          //  for viewController in cenesTabBarViewControllers {
                          //      if (viewController is NewHomeViewController) {
                          //          isNewControllerFound = true;
                          //          (viewController as! NewHomeViewController).initilizeInvitationTabsData();
                          //      }
                          //  }
                            //if (isNewControllerFound == false) {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshInvitaitonTabsLocally"), object: nil);
                            //}
                        //}
                        
                        if (self.fromPushNotificaiton == true) {
                            //self.isLoggedInUserAsOwner = false;
                            //self.leftToRightGestureEnabled = true;
                            //self.rightToLeftGestureEnabled = true;
                            
                            if (eventTemp.eventId != nil && eventTemp.eventId != 0) {
                                self.event = eventTemp;
                            }
                        } else {
                            
                            if (eventTemp.createdAt != nil) {
                                self.event.createdAt = eventTemp.createdAt;
                            } else if (eventTemp.updateAt != nil) {
                                self.event.createdAt = eventTemp.updateAt;
                            } else {
                                self.event.createdAt = Date().millisecondsSince1970;
                            }
                            if (self.event.requestType != EventRequestType.EditEvent) {
                                self.event.eventPicture = eventTemp.eventPicture;
                                self.event.description = eventTemp.description;
                                
                                if (eventTemp.eventMembers != nil) {
                                                               
                                       let eventMembersExistingInEvent  = self.event.eventMembers;
                                       
                                       self.event.eventMembers = [EventMember]();
                                       
                                       for eventMemFromDb in eventTemp.eventMembers! {
                                           
                                           var eventMemberAlreadyExists = false;
                                           for eveMemFromEdit in self.event.eventMembers! {
                                               if (eventMemFromDb.userId != nil && eventMemFromDb.userId != 0 && eventMemFromDb.userId == eveMemFromEdit.userId) {
                                                   eventMemberAlreadyExists = true;
                                                   break;
                                               }
                                           }
                                           
                                           if (eventMemberAlreadyExists == true) {
                                               continue;
                                           }
                                           self.event.eventMembers.append(eventMemFromDb);
                                       }
                                       
                                       //Lets add newly added members
                                       for oldEventMember in eventMembersExistingInEvent! {
                                           if (oldEventMember.eventMemberId == nil) {
                                               self.event.eventMembers.append(oldEventMember);
                                           }
                                       }
                                   }
                            }
                           
                            self.event.thumbnail = eventTemp.thumbnail;
                        }
                        self.invitationCardTableView.reloadData();
                        self.getAllEventChat();
                        
                        if (eventTemp.placeId != nil && eventTemp.placeId != "") {
                            self.fetchLocationPhotos(placeId: eventTemp.placeId);
                        }
                    }
                }
            });
        
        } else if (event.key != nil) {
            
            let apiEndpoint = "\(apiUrl)\(GatheringService().get_gathering_data)";
            let queryStr = "key=\(self.event.key!)&userId=\(self.loggedInUser.userId!)";
            GatheringService().gatheringCommonGetAPI(api: apiEndpoint, queryStr: queryStr, token: self.loggedInUser.token, complete: {(response) in
            
                let success = response.value(forKey: "success") as! Bool;
                if (success == true) {
                    if (response.value(forKey: "data") != nil) {
                        let data = response.value(forKey: "data") as! NSDictionary;
                        let eventTemp = Event().loadEventData(eventDict: data);
                        
                        let localEvent = sqlDatabaseManager.findEventByEventId(eventId: eventTemp.eventId);
                        if (localEvent.eventId != nil) {
                            sqlDatabaseManager.updateEventByEventId(eventId: eventTemp.eventId, eventFromApi: eventTemp);
                        }
                        
                        if (self.fromPushNotificaiton == true) {
                            self.isLoggedInUserAsOwner = false;
                            //self.leftToRightGestureEnabled = true;
                            //self.rightToLeftGestureEnabled = true;
                            
                            self.event = eventTemp;
                            
                        } else {
                            if (self.event.requestType != EventRequestType.EditEvent) {
                                self.event.eventPicture = eventTemp.eventPicture;
                                self.event.description = eventTemp.description;
                            }
                            
                            if (eventTemp.createdAt != nil) {
                                self.event.createdAt = eventTemp.createdAt;
                            } else if (eventTemp.updateAt != nil) {
                                self.event.createdAt = eventTemp.updateAt;
                            } else {
                                self.event.createdAt = Date().millisecondsSince1970;
                            }
                            
                            
                            let eventMembersExistingInEvent  = self.event.eventMembers;

                            if (eventTemp.eventMembers != nil) {
                                
                                for eventMemFromDb in eventTemp.eventMembers! {
                                    
                                    var eventMemberAlreadyExists = false;
                                    for eveMemFromEdit in self.event.eventMembers! {
                                        if (eventMemFromDb.userId != nil && eventMemFromDb.userId == eveMemFromEdit.userId) {
                                            eventMemberAlreadyExists = true;
                                            break;
                                        }
                                    }
                                    
                                    if (eventMemberAlreadyExists == true) {
                                        continue;
                                    }
                                    self.event.eventMembers.append(eventMemFromDb);
                                    
                                    //var eventMemFromDbMO = eventMemFromDb as! EventMemberMO;
                                    /*var editMembersIndex = 0;
                                    for eveMemFromEdit in self.event.eventMembers! {
                                        
                                        //var eveMemFromEditMO = eveMemFromEdit as! EventMemberMO;
                                        if (eventMemFromDb.userContactId == eveMemFromEdit.userContactId) {
                                            
                                            eventMemFromDb.userContact = eveMemFromEdit.userContact;

                                            self.event.eventMembers[editMembersIndex] = eventMemFromDb;
                                             //self.event.addToEventMembers(eventMemFromDbMO);

                                            break;
                                        }
                                        editMembersIndex  = editMembersIndex + 1;
                                    }*/
                                }
                            }
                            //Lets add newly added members
                            for oldEventMember in eventMembersExistingInEvent! {
                                if (oldEventMember.eventMemberId == nil) {
                                    self.event.eventMembers.append(oldEventMember);
                                }
                            }
                            self.event.thumbnail = eventTemp.thumbnail;
                        }
                        self.invitationCardTableView.reloadData();
                        self.getAllEventChat();
                        
                        if (eventTemp.placeId != nil) {
                            self.fetchLocationPhotos(placeId: eventTemp.placeId);
                        }
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
        if (sender.state == UIGestureRecognizer.State.began) {
            
            self.acceptedSendInvitationLoaderView.isHidden = true;
            self.rejectedInvitationLoaderView.isHidden = true;
            
            let gestureIsDraggingFromLeftToRight = (sender.velocity(in: view).x > 0)
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
        if (sender.state == UIGestureRecognizer.State.changed) {
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
        if (sender.state == UIGestureRecognizer.State.ended) {
            
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
                            self.acceptGatheringCall();
                        } else {
                            
                            //If owner is looking at the event and,
                            //its an existging event then we will popup this controller
                            if (self.event.eventId != nil && self.event.eventId != 0) {
                                if (self.event.requestType == EventRequestType.EditEvent) {
                                    //For owner, if its a new event, create new event
                                    
                                    //Lets check.
                                    //If event has non cenes members.
                                    //And we will open sms composer to send invitation link to non
                                    //cenes memebers.
                                    /*var nonCenesMembers = [EventMember]();
                                    if (self.event.eventMembers != nil) {
                                        for mem in self.event.eventMembers! {
                                            if ((mem.userId == nil || mem.userId == 0) && (mem.eventMemberId == nil || mem.eventMemberId == 0) && mem.phone != nil) {
                                                
                                                nonCenesMembers.append(mem);
                                            }
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
                                    }*/
                                    
                                    DispatchQueue.global(qos: .background).async {
                                        
                                        //If its an already existing event
                                        if (self.event.eventId != nil && self.event.eventId != 0) {
                                            
                                            let existingEvents = sqlDatabaseManager.findEventListByEventId(eventId: self.event.eventId);
                                            
                                            if (existingEvents.count > 0) {
                                                //Deleting the
                                                sqlDatabaseManager.deleteEventByEventId(eventId: self.event.eventId);
                                            }
                                            //Saving the events again in localdatabase
                                            //for existingEve in existingEvents {
                                                self.event.displayScreenAt = existingEvents[0].displayScreenAt;
                                                self.event.processed = 0;
                                                sqlDatabaseManager.saveEvent(event: self.event);
                                            //}
                                        } else {
                                            //If Event is a new Event then lets save this event with temp id.
                                            //And save it with processed status 0
                                            self.event.eventId = Int32(Date().millisecondsSince1970);
                                            self.event.processed = 0;
                                            self.event.displayScreenAt = EventDisplayScreen.HOME;
                                            for offlineEventMem in self.event.eventMembers {
                                                offlineEventMem.eventId = self.event.eventId;
                                            }
                                            sqlDatabaseManager.saveEvent(event: self.event);
                                            
                                            self.event.eventId = nil;
                                            for offlineEventMem in self.event.eventMembers {
                                                offlineEventMem.eventId = nil;
                                                offlineEventMem.eventMemberId = nil;
                                            }
                                        }
                                        
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateExistingEventOnServer"), object: nil);
                                        DispatchQueue.main.async {
                                            UIApplication.shared.keyWindow?.rootViewController = NewHomeViewController.MainViewController();

                                        }

                                        let eventDict = self.event.toDictionary(event: self.event);
                                        print(eventDict);
                                        /*GatheringService().createGatheringV2(postData: eventDict, token: self.loggedInUser.token, complete: {(response) in
                                            print("Saved Successfully...")
                                            let success = response.value(forKey: "success") as! Bool;
                                            if (success == true) {
                                                
                                                //Lets delete all unprocessed events
                                                sqlDatabaseManager.deleteAllEventsByProcessedStatus(processed: 0);

                                                let dataDict = response.value(forKey: "data") as! NSDictionary;
                                                let eventId = dataDict.value(forKey: "eventId") as! Int32;
                                                if (eventId != nil && eventId != 0) {
                                                    
                                                    //If its an existing event, lets delete it so that if user has added or removed any member then it can be reflected in the app.
                                                    sqlDatabaseManager.deleteEventByEventId(eventId: self.event.eventId);
                                                    
                                                    //Now after deleting lets add the event again to display at Home and Accepted screen
                                                    let eventTemp = Event().loadEventData(eventDict: dataDict);
                                                    eventTemp.displayScreenAt = EventDisplayScreen.HOME;
                                                    sqlDatabaseManager.saveEvent(event: eventTemp);
                                                    
                                                    eventTemp.displayScreenAt = EventDisplayScreen.ACCEPTED;
                                                    sqlDatabaseManager.saveEvent(event: eventTemp);
                                                    
                                                    DispatchQueue.main.async {
                                                        // Go back to the main thread to update the UI.
                                                        if (nonCenesMembers.count == 0) {
                                                            
                                                            //This is called when the user is from home screen
                                                            if (self.newHomeViewControllerDeglegate != nil) {
                                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
                                                                self.navigationController?.popToRootViewController(animated: true);
                                                            } else {
                                                                if (self.tabBarController != nil) {
                                                                    if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                                                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil);
                                                                        self.navigationController?.popToRootViewController(animated: true);
                                                                        
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                        });*/
                                        /*DispatchQueue.main.async {
                                            // Go back to the main thread to update the UI.
                                            if (nonCenesMembers.count == 0) {
                                                
                                                //This is called when the user is from home screen
                                                if (self.newHomeViewControllerDeglegate != nil) {
                                                    //DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                                     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
                                                    //});
                                                    self.newHomeViewControllerDeglegate.createGatheringAfterInvitation(postData: eventDict, nonCenesMembers: nonCenesMembers);
                                                    self.navigationController?.popToRootViewController(animated: true);
                                            
                                                } else {
                                                    if (self.tabBarController != nil) {
                                                        if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                                                            
                                                            //DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                                           //     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
                                                            //});
                                                            var isNewControllerFound: Bool = false;
                                                            for viewController in cenesTabBarViewControllers {
                                                                if (viewController is NewHomeViewController) {
                                                                    isNewControllerFound = true;
                                                                    (viewController as! NewHomeViewController).createGatheringAfterInvitation(postData: eventDict, nonCenesMembers: nonCenesMembers);
                                                                }
                                                            }
                                                            if (isNewControllerFound == false) {
                                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateExistingEventOnServer"), object: nil)

                                                            }
                                                            self.navigationController?.popToRootViewController(animated: true);
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        }*/
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
                                if (self.event.eventMembers != nil) {
                                    for mem in self.event.eventMembers! {
                                        if (mem.userId == nil || mem.userId == 0 && mem.phone != nil) {
                                            nonCenesMembers.append(mem);
                                        }
                                    }
                                }
                                
                                //For owner, if its a new event, create new event
                                DispatchQueue.global(qos: .background).async {
                                    
                                    //If its the first time. Lets take out the owner from event and let the backend handle it.
                                    var index = 0;
                                    if (self.event.eventMembers != nil) {
                                        for eventmem in self.event.eventMembers! {
                                            if (eventmem.userId == self.loggedInUser.userId) {
                                                self.event.eventMembers.remove(at: index);
                                                index = index + 1;
                                            }
                                        }
                                    }
                                    
                                    if (nonCenesMembers.count > 0) {
                                        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                                        let eventKey = String((0..<32).map{ _ in letters.randomElement()! })
                                        self.event.key = "\(eventKey)";

                                        //DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                                        /*DispatchQueue.main.async {
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
                                        }//);*/
                                    }
                                    
                                    if (Connectivity.isConnectedToInternet) {
                                        
                                        //If its an already existing event
                                        if (self.event.eventId != nil && self.event.eventId != 0) {
                                            
                                            let existingEvents = sqlDatabaseManager.findEventListByEventId(eventId: self.event.eventId);
                                            
                                            if (existingEvents.count > 0) {
                                                //Deleting the
                                                sqlDatabaseManager.deleteEventByEventId(eventId: self.event.eventId);
                                            }
                                            //Saving the events again in localdatabase
                                            for existingEve in existingEvents {
                                                self.event.displayScreenAt = existingEve.displayScreenAt;
                                                self.event.processed = 0;
                                                sqlDatabaseManager.saveEvent(event: self.event);
                                            }
                                        } else {
                                            //If Event is a new Event then lets save this event with temp id.
                                            //And save it with processed status 0
                                            self.event.eventId = Int32(truncatingIfNeeded: Date().millisecondsSince1970);
                                            self.event.processed = 0;
                                            self.event.displayScreenAt = EventDisplayScreen.HOME;
                                            for offlineEventMem in self.event.eventMembers {
                                                offlineEventMem.eventId = self.event.eventId;
                                            }
                                            sqlDatabaseManager.saveEvent(event: self.event);
                                            self.event.eventId = nil;
                                            for offlineEventMem in self.event.eventMembers {
                                                offlineEventMem.eventId = nil;
                                                offlineEventMem.eventMemberId = nil;
                                            }
                                        }

                                        let eventDict = self.event.toDictionary(event: self.event);
                                        print(eventDict);
                                        /*GatheringService().createGatheringV2(postData: eventDict, token: self.loggedInUser.token, complete: {(response) in
                                            print("Saved Successfully...")
                                            
                                            let success = response.value(forKey: "success") as! Bool;
                                            if (success == true) {
                                                //Lets delete all unprocessed events
                                                sqlDatabaseManager.deleteAllEventsByProcessedStatus(processed: 0);
                                                
                                                Mixpanel.mainInstance().track(event: "Gathering",
                                                properties:[ "Action" : "Create Gathering Success", "Title":"\(self.event.title!)", "UserEmail": "\(self.loggedInUser.email!)", "UserName": "\(self.loggedInUser.name!)"]);
                                                
                                                let dataDict = response.value(forKey: "data") as! NSDictionary;
                                                let eventId = dataDict.value(forKey: "eventId") as! Int32;
                                                if (eventId != nil && eventId != 0) {
                                                    
                                                    //If its an existing event, lets delete it so that if user has added or removed any member then it can be reflected in the app.
                                                    sqlDatabaseManager.deleteEventByEventId(eventId: self.event.eventId);
                                                    
                                                    //Now after deleting lets add the event again to display at Home and Accepted screen
                                                    let eventTemp = Event().loadEventData(eventDict: dataDict);
                                                    eventTemp.displayScreenAt = EventDisplayScreen.HOME;
                                                    sqlDatabaseManager.saveEvent(event: eventTemp);
                                                    
                                                    eventTemp.displayScreenAt = EventDisplayScreen.ACCEPTED;
                                                    sqlDatabaseManager.saveEvent(event: eventTemp);
                                                    
                                                    if (nonCenesMembers.count == 0) {
                                                        //self.navigationController?.popToRootViewController(animated: false);
                                                        //This is called when the user is from home screen
                                                        if (self.newHomeViewControllerDeglegate != nil) {
                                                            self.newHomeViewControllerDeglegate.refershDataFromOtherScreens();
                                                            //UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                                                            
                                                        } else {
                                                            if (self.tabBarController != nil) {
                                                                if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                                                                    
                                                                    let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                                                                   
                                                                    if (homeViewController != nil) {
                                                                        homeViewController?.refershDataFromOtherScreens();
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        });*/

                                        
                                        
                                        //if (nonCenesMembers.count == 0) {
                                            DispatchQueue.main.async {

                                               if (self.tabBarController != nil) {
                                                   if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                                                       
                                                    let isNewControllerFound: Bool = false;
                                                        for viewController in cenesTabBarViewControllers {
                                                           if (viewController is NewHomeViewController) {
                                                               //isNewControllerFound = true;
                                                               //(viewController as! NewHomeViewController).createGatheringAfterInvitation(postData: eventDict, nonCenesMembers: nonCenesMembers);
                                                           }
                                                       }
                                                       if (isNewControllerFound == false) {
                                                        print(Date())
                                                        print("Running Notification Code");
                                                       
                                                        //DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                                                             print(Date())
                                                            if (self.event.eventId == nil) {
                                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createNewExistingEventOnServer"), object: nil)
                                                            } else {
                                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateExistingEventOnServer"), object: nil)
                                                            }
                                                        //});

                                                       }

                                                    UIApplication.shared.keyWindow?.rootViewController = NewHomeViewController.MainViewController();

                                                   }
                                               }
                                            }
                                        //}
 
                                    } else {
                                        
                                        //Save Offline Event
                                        sqlDatabaseManager.saveEventWhenNoInternet(event: self.event);
                                    }
                                }
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
                    
                    //If logged In User is not an Owner and is going to decline the event
                    if (self.isLoggedInUserAsOwner == false) {
                        //self.declineInvitationCall();
                        self.declinedInvitationConfirmAlert();
                    } else {
                        self.rejectedInvitationLoaderView.startRotatingView(duration: 0.5, repeatCount: 1, clockwise: true);
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            // your code here
                            self.rejectedInvitationLoaderView.stopRotatingView();
                            if (self.event.eventId != nil && self.event.eventId != 0) {
                                
                                if (self.event.requestType == EventRequestType.EditEvent) {
                                    //self.navigationController?.popViewController(animated: true);
                                    
                                } else {
                                    self.swipeCardView.center = CGPoint(x: self.swipeCardView.center.x, y: self.swipeCardView.center.y);
                                }
                                
                            } else {
                                self.navigationController?.popViewController(animated: false);
                            }
                        };
                    }
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
    
    @objc func cardPressed() {
        self.resetScreenToDefaultPosition();
    }
    
   func acceptGatheringCall() {
        if (self.event.scheduleAs == EventScheduleAs.NOTIFICATION) {
            self.navigationController?.popViewController(animated: true);
        } else {
            
            //Update EventMEmber status in CoreData EventMember table
            //sqlDatabaseManager.updateEventMemberStatusByUserId(eventMemberStatus: "Going", userId: self.loggedInUser.userId);
            
            let acceptedEvent = sqlDatabaseManager.findEventByEventId(eventId: event.eventId);
            if (acceptedEvent.eventId != nil) {
                sqlDatabaseManager.deleteEventByEventId(eventId: acceptedEvent.eventId);
                
                //Display Event At Home Screen
                acceptedEvent.displayScreenAt = EventDisplayScreen.HOME;
                sqlDatabaseManager.saveEvent(event: acceptedEvent);
                
                //Display Event At Accepted Screen
                acceptedEvent.displayScreenAt = EventDisplayScreen.ACCEPTED;
                sqlDatabaseManager.saveEvent(event: acceptedEvent);
            }
            
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
    }
    
    func declineInvitationCall() {
        
        self.swipeCardView.center = CGPoint(x: self.swipeCardView.center.x - 200, y: self.swipeCardView.center.y);
        self.swipeCardView.alpha = 0;
        
        if (self.event.scheduleAs == EventScheduleAs.NOTIFICATION) {
            self.navigationController?.popViewController(animated: true);
        } else {
            
            //Update EventMEmber status in CoreData EventMember table
            sqlDatabaseManager.updateEventMemberStatusByUserId(eventMemberStatus: "NotGoing", userId: self.loggedInUser.userId);

            let declinedEvent = sqlDatabaseManager.findEventByEventId(eventId: event.eventId);
            sqlDatabaseManager.deleteEventByEventId(eventId: declinedEvent.eventId);
            
            //Display Event At Home Screen
            declinedEvent.displayScreenAt = EventDisplayScreen.DECLINED;
            sqlDatabaseManager.saveEvent(event: declinedEvent);
                    
            let acceptQueryStr = "eventId=\(String(self.event.eventId))&userId=\(String(self.loggedInUser.userId))&status=NotGoing";
            GatheringService().updateGatheringStatus(queryStr: acceptQueryStr, token: self.loggedInUser.token, complete: {(response) in
                
            });
        }
    }
    
    func declinedInvitationConfirmAlert() {
        
        let declineAlert = UIAlertController(title: "Message", message: "Are you sure to decline this event?", preferredStyle: UIAlertController.Style.alert)

        declineAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here");
            self.declinedInvitationSendMessageAlert();
            self.declineInvitationCall();
          }))

        declineAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here");
            self.resetScreenToDefaultPosition();
        }));
        
        self.present(declineAlert, animated: true, completion: nil)
    }
    
    func declinedInvitationSendMessageAlert() {
        
        let declineAlert = UIAlertController(title: "Decline Event", message: "Do you want to leave a note to ", preferredStyle: UIAlertController.Style.alert)

        //2. Add the text field. You can configure it however you need.
        declineAlert.addTextField { (textField) in
            textField.text = ""
        }

        declineAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            let textField = declineAlert.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField.text)")
            if (textField.text != "") {
                
                self.rejectedInvitationLoaderView.startRotatingView(duration: 0.5, repeatCount: 1, clockwise: true);
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // your code here
                    self.rejectedInvitationLoaderView.stopRotatingView();
                    self.self.resetScreenToDefaultPosition();
                }
                self.postEventChat(chatMessage: textField.text!);
            }
        }));

        declineAlert.addAction(UIAlertAction(title: "Skip", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here");
            self.resetScreenToDefaultPosition();
            //self.moveToHomeScreen();
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
                
                if (self.fromPushNotificaiton == true) {
                    
                    UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
                    });
                } else {
                    self.moveToHomeScreen();
                }
            }
          }))

        self.present(declineAlert, animated: true, completion: nil)
    }
    
    func postEventChat(chatMessage: String) {
        
        let api = "\(apiUrl)\(GatheringService.post_event_chat_api)";
        var postData = [String: Any]();
        postData["senderId"] = loggedInUser.userId;
        postData["chat"] = chatMessage;
        postData["eventId"] = event.eventId;
        postData["chatStatus"] = "Sent"; //1 For making status as Read
        postData["createdAt"] = Date().millisecondsSince1970; //1 For making status as Read

        if (self.isKeyboardVisible == true) {
            self.chatBoxView.activiyIndicator.stopAnimating();
            self.chatBoxView.sendMessageTextField.resignFirstResponder();
        }

        let eventChatTmp = EventChat();
        eventChatTmp.createdAt = (postData["createdAt"] as! Int64);
        eventChatTmp.chat = (postData["chat"] as! String);
        eventChatTmp.senderId = loggedInUser.userId;
        eventChatTmp.eventId = (postData["eventId"] as! Int32);
        
        let eventChatDateKeyeTmp = Date(millis: eventChatTmp.createdAt).EMMMd();
        if (!self.eventChatDateKeys.contains(eventChatDateKeyeTmp!)) {
            self.eventChatDateKeys.append(eventChatDateKeyeTmp!);
        }
        
        if (self.eventChatAndDateMap[eventChatDateKeyeTmp!] != nil) {
            var eventChatTmpList = self.eventChatAndDateMap[eventChatDateKeyeTmp!]!;
            eventChatTmpList.append(eventChatTmp);
            self.eventChatAndDateMap[eventChatDateKeyeTmp!] = eventChatTmpList;
            
        } else {
            var eventChatTmpList = [EventChat]();
            eventChatTmpList.append(eventChatTmp);
            self.eventChatAndDateMap[eventChatDateKeyeTmp!] = eventChatTmpList;
        }
        
        for chatFeatureViewTemp in self.view.subviews {
            if (chatFeatureViewTemp is ChatFeatureView) {
                self.addChatScrollView();
                break;
            }
        }
        self.inputChatMessageText = "";
        
        GatheringService().gatheringCommonPostAPI(api: api, postData: postData, token: loggedInUser.token, complete: {response in
            
            let success = response.value(forKey: "success") as! Bool;
            if (success == true) {
                self.getAllEventChat();
            }
        });
    }
    
    func moveToHomeScreen() {
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
            
            
            self.chatFeatureView = nil;
            for chatFeatView in self.view.subviews {
                if (chatFeatView is ChatFeatureView) {
                    chatFeatView.removeFromSuperview();
                }
            }
            self.getAllEventChat();
            self.locationPhotos = [LocationPhoto]();
            if (self.event.placeId != nil && self.event.placeId != "") {
                self.fetchLocationPhotos(placeId: self.event.placeId);
            }
        } else {
            
            if (self.isLoggedInUserInMemberList == false) {
                
                if (self.event.eventId != nil) {
                    
                    let acceptQueryStr = "eventId=\(String(self.event.eventId))&userId=\(String(self.loggedInUser.userId))&status=pending";
                    GatheringService().updateGatheringStatus(queryStr: acceptQueryStr, token:
                        
                        self.loggedInUser.token, complete: {(response) in
                            
                    });
                }
                
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
    
    func addChatScrollView() {
        
        let leftPaddingViewChatFeature: CGFloat = 25.0;
        if (self.chatFeatureView == nil) {
            self.chatFeatureView = ChatFeatureView.instanceFromNib() as! ChatFeatureView;
        }
        self.chatFeatureView.frame = CGRect.init(x: leftPaddingViewChatFeature, y: self.view.frame.height - 550, width: self.view.frame.width - 30, height: 400);
        self.chatFeatureView.chatMessageScrollView.frame = CGRect.init(x: 0, y: 0, width: self.chatFeatureView.frame.width, height: 300);
        
        print("Print Chat Feature Cordinates Initially : ",self.chatFeatureView.frame);
        print("Print Scroll View Cordinates Initially : ",self.chatFeatureView.chatMessageScrollView.frame);

        //self.chatFeatureView.addSubview(self.chatFeatureView.chatMessageScrollView);
        print("Scroll View Y posigion : ",self.chatFeatureView.chatMessageScrollView.frame.origin.y);
        for viewTemp in self.chatFeatureView.chatMessageScrollView.subviews {
            viewTemp.removeFromSuperview();
        }
        var descriptionHeight: CGFloat = 0;
        
        for eventChatDateKey in self.eventChatDateKeys {
            
            let chatBlurbView: ChatBlurbView = ChatBlurbView.instanceFromNib() as! ChatBlurbView;
            
            let yesterdayKey = Calendar.current.date(byAdding: .day, value: -1, to: Date())?.EMMMd();
            if (eventChatDateKey == Date().EMMMd()) {
                chatBlurbView.chatBlurbLabel.text = "Today";
            } else if (eventChatDateKey == yesterdayKey) {
                chatBlurbView.chatBlurbLabel.text = "Yesterday";
            } else {
                chatBlurbView.chatBlurbLabel.text = eventChatDateKey;
            }
                        
            //Setting frame for Chat Blur View
            chatBlurbView.frame = CGRect.init(x: self.chatFeatureView.chatMessageScrollView.frame.origin.x, y: descriptionHeight, width: self.chatFeatureView.chatMessageScrollView.frame.width, height: chatBlurbView.frame.height);

            print("Blurb View Frame : ", chatBlurbView.frame);
            //Adding View to ScrollView
            
            let tempDict: [CGFloat: String] = [chatBlurbView.frame.height: chatBlurbView.chatBlurbLabel.text!];
            self.chatViewItemAndHeight.append(tempDict);
            self.chatFeatureView.chatMessageScrollView.addSubview(chatBlurbView);
            
            descriptionHeight = descriptionHeight + chatBlurbView.frame.height;
            
            let eventChatsFromMap = self.eventChatAndDateMap[eventChatDateKey];
            
            //Creating Chat Bubbles
            descriptionHeight = createChatBubbles(eventChatsFromMap: eventChatsFromMap!, descriptionHeightParam: descriptionHeight);
        }
        
        //self.chatFeatureView.backgroundColor = UIColor.green;
        //self.chatFeatureView.chatMessageScrollView.backgroundColor = UIColor.red;
        
        self.chatFeatureView.chatMessageScrollView.isScrollEnabled = true;
        self.chatFeatureView.chatMessageScrollView.contentSize = CGSize.init(width: self.chatFeatureView.frame.width, height: descriptionHeight + 50);
        
        if (eventChats.count == 1) {
            //self.chatFeatureView.chatMessageScrollView.frame = CGRect.init(x: 0, y: 0, width: self.chatFeatureView.frame.width, height: 300);
        } else {
            //self.chatFeatureView.chatMessageScrollView.frame = CGRect.init(x: 0, y: 0, width: self.chatFeatureView.frame.width, height: 300);
        }
        print("Print Chat Feature Cordinates : ",self.chatFeatureView.frame);
        print("Print Scroll View Cordinates : ",self.chatFeatureView.chatMessageScrollView.frame);

        //self.chatFeatureView.chatMessageScrollView.frame = CGRect.init(x: self.chatFeatureView.frame.origin.x, y: 0, width: self.chatFeatureView.frame.width, height: 300.0);
                
        
        //Tap to send message will be needed only if the event is not expired.
        if (event.expired == false) {
            addTapToChatViewSection();
        }
        
        scrollToBottomScrollView();
        self.view.addSubview(chatFeatureView);
    }
    
    func getAllEventChat() {
        
        /*let defaultEventDesc = EventChat();
        if (event.description != nil && event.description != "") {
            defaultEventDesc.senderId = event.createdById;
            defaultEventDesc.chat = event.description!;
            defaultEventDesc.eventId = event.eventId;
            defaultEventDesc.createdAt = event.createdAt;
            defaultEventDesc.synced = true;
            if (eventOwner.eventMemberId != nil && eventOwner.user != nil) {
                defaultEventDesc.user = eventOwner.user;
            }
        }*/
        
        let apiEndpoint = "\(apiUrl)\(GatheringService.get_event_chat_by_eventId)";
        let queryStr = "eventId=\(event.eventId!)";
        
        GatheringService().gatheringCommonGetAPI(api: apiEndpoint, queryStr: queryStr, token: loggedInUser.token, complete: {response in
            
            
            self.eventChats = [EventChat]();
            self.eventChatDateKeys = [String]();
            self.eventChatAndDateMap = [String: [EventChat]]();
            //self.eventChats.append(defaultEventDesc);

            let success = response.value(forKey: "success") as! Bool;
            if (success == true) {
                let eventChatDataArr = response.value(forKey: "data") as! NSArray;
                if (eventChatDataArr.count > 0) {
                    let eventChatsTemps = EventChat().populateEventChatFromArray(eventChatArray: eventChatDataArr);
                    for eventChatTemp in eventChatsTemps {
                        eventChatTemp.synced = true;
                        if (eventChatTemp.chatType == EventChatType.DESCRIPTION) {
                            if (eventChatTemp.chat != self.event.description) {
                                eventChatTemp.chatEdited = EventChatEdited.YES;
                                eventChatTemp.chat = self.event.description;
                            }
                        }
                        
                        self.eventChats.append(eventChatTemp);
                    }
                } else {
                    let defaultEventDesc = EventChat();
                    if (self.event.description != nil && self.event.description != "") {
                       defaultEventDesc.senderId = self.event.createdById;
                       defaultEventDesc.chat = self.event.description!;
                       defaultEventDesc.eventId = self.event.eventId;
                       defaultEventDesc.createdAt = self.event.createdAt;
                       defaultEventDesc.synced = true;
                       if (self.eventOwner.eventMemberId != nil && self.eventOwner.user != nil) {
                           defaultEventDesc.user = self.eventOwner.user;
                       }
                        self.eventChats.append(defaultEventDesc);
                   }
                }
            }
            //Deleting event Chats
            /*sqlDatabaseManager.deleteEventChatByEventId(eventId: self.event.eventId);
            for eventChatTmp in self.eventChats {
                //Saving Event Chats
                sqlDatabaseManager.saveEventChat(eventChat: eventChatTmp);
            }*/
            
            //Processing event chat list to create
            for eventChatTmp in self.eventChats {
                if (eventChatTmp.createdAt == nil) {
                    eventChatTmp.createdAt = Date().millisecondsSince1970;
                }
                let eventChatDateKeyeTmp = Date(millis: eventChatTmp.createdAt).EMMMd();
                if (!self.eventChatDateKeys.contains(eventChatDateKeyeTmp!)) {
                    self.eventChatDateKeys.append(eventChatDateKeyeTmp!);
                }
                
                if (self.eventChatAndDateMap[eventChatDateKeyeTmp!] != nil) {
                    var eventChatTmpList = self.eventChatAndDateMap[eventChatDateKeyeTmp!]!;
                    eventChatTmpList.append(eventChatTmp);
                    self.eventChatAndDateMap[eventChatDateKeyeTmp!] = eventChatTmpList;
                    
                } else {
                    
                    var eventChatTmpList = [EventChat]();
                    eventChatTmpList.append(eventChatTmp);
                    self.eventChatAndDateMap[eventChatDateKeyeTmp!] = eventChatTmpList;
                }
            }
            
            for chatFeatureViewTemp in self.view.subviews {
                if (chatFeatureViewTemp is ChatFeatureView) {
                    self.addChatScrollView();
                    
                    self.makeMessagesAsRead();
                    break;
                }
            }
        });
    }
    
    func refreshChatScreen() {
        
        Mixpanel.mainInstance().track(event: "InvitationScreen", properties:[ "Logs" : "refreshChatScreen Called"]);
        //print("Inside : refreshChatScreen");
        getAllEventChat();
    }
    
    func addTapToChatViewSection() {
        self.tapToChatView = TapToChatView.instanceFromNib() as! TapToChatView;
        tapToChatView.frame = CGRect.init(x: self.chatFeatureView.chatMessageScrollView.frame.width - tapToChatView.frame.width, y: self.chatFeatureView.frame.height - tapToChatView.frame.height, width: tapToChatView.frame.width, height: tapToChatView.frame.height);
        
         if (loggedInUser.photo != nil) {
            tapToChatView.profilePic.sd_setImage(with: URL.init(string: loggedInUser.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
        } else {
            tapToChatView.profilePic.image = UIImage.init(named: "profile_pic_no_image");
        }
         
        if (loggedInUser.userId == event.createdById) {
            tapToChatView.hostGradientCircle.isHidden = false;
        } else {
            tapToChatView.hostGradientCircle.isHidden = true;
        }
         let tapToChatTouchListener = UITapGestureRecognizer.init(target: self, action: #selector(tapToChatPressed));
         tapToChatView.addGestureRecognizer(tapToChatTouchListener);
             chatFeatureView.addSubview(tapToChatView);
    }
    
    func scrollToBottomScrollView() {
        var bottomOffset: CGPoint = CGPoint(x: 0, y: self.chatFeatureView.chatMessageScrollView.contentSize.height - self.chatFeatureView.chatMessageScrollView.bounds.size.height + self.chatFeatureView.chatMessageScrollView.contentInset.bottom);
        
        if (eventChats.count > 1) {
            if (selectedEventChatDto != nil && selectedEventChatDto.message != nil) {
                var heightToMinus:CGFloat = 0.0;
                for chatViewItemTmp in self.chatViewItemAndHeight {
                    var isChatFound: Bool = false;
                    for (height, chat) in chatViewItemTmp {
                        if (chat == selectedEventChatDto.message) {
                            isChatFound = true;
                            heightToMinus += height;
                            break;
                        }
                        heightToMinus += height;
                    }
                    if (isChatFound == true) {
                        break;
                    }
                }
                
                bottomOffset = CGPoint(x: 0, y: heightToMinus - self.chatFeatureView.chatMessageScrollView.bounds.size.height + self.chatFeatureView.chatMessageScrollView.contentInset.bottom);
                
            }
            
            self.chatFeatureView.chatMessageScrollView.setContentOffset(bottomOffset, animated: true);
        }
    }
    
    func createChatBubbles(eventChatsFromMap: [EventChat], descriptionHeightParam: CGFloat) -> CGFloat {
        
        var descriptionHeight = descriptionHeightParam;
        for eventChat in eventChatsFromMap {
            if (eventChat.chatEdited == EventChatEdited.YES) {
                if (!eventChat.chat.contains("(Edited)")) {
                    eventChat.chat = eventChat.chat + " (Edited)";
                }
            }
            print(eventChat.senderId, eventChat.chat);
            if (loggedInUser.userId == eventChat.senderId) {
                
                descriptionHeight = createSenderChatBubble(eventChat: eventChat, descriptionHeightParam: descriptionHeight);
            } else {
                
                descriptionHeight = createAttendeeView(eventChat: eventChat, descriptionHeightParam: descriptionHeight);
            }
        }
        
        return descriptionHeight;
    }
    
    func createSenderChatBubble(eventChat: EventChat, descriptionHeightParam: CGFloat) -> CGFloat {
        
        var descriptionHeight = descriptionHeightParam;
        
        //Lets load different view in case the text if from logged In User
        let senderChatView: SenderChatView = SenderChatView.instanceFromNib() as! SenderChatView;

        let chatTime = Date.init(millis: eventChat.createdAt).hmma();
        let timeConstraintRect = CGSize(width: .greatestFiniteMagnitude, height: senderChatView.chatTime.frame.height);
        let timeBoundingBox = chatTime.boundingRect(with: timeConstraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: senderChatView.chatTime.font], context: nil);

        //Lets find the number of lines for Chat Message
        let heightOfDesc = self.heightForView(text: eventChat.chat!, font: senderChatView.chatMessage.font, width: self.chatFeatureView.chatMessageScrollView.frame.width - (100));
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: heightOfDesc)
        let boundingBox = eventChat.chat.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: senderChatView.chatMessage.font], context: nil)
               
        //Setting Frame for Chat Message *******
        //Lets find the number of lines of chat message uilabel
        if (eventChat.chatEdited == EventChatEdited.YES) {
            if (!eventChat.chat.contains("(Edited)")) {
                eventChat.chat = eventChat.chat + " (Edited)";
            }
        }
        senderChatView.chatMessage.unselectedTextColorChange(fullText: eventChat.chat, changeText: "(Edited)");
        var numberOFlines: Int = 0;
        let heightOfUILabel: Int = 20;
        let widthOfSpeechArrow: CGFloat = 25;
        let leftPaddingToText: CGFloat = 10;
        let rightPaddingToText: CGFloat = 10;
        let maxWidth: CGFloat = self.chatFeatureView.chatMessageScrollView.frame.width - (15 + 24);

        senderChatView.chatMessage.frame = CGRect.init(x: 10 , y: senderChatView.chatMessage.frame.origin.y, width: maxWidth - timeBoundingBox.width - senderChatView.chatMsgStatus.frame.width - leftPaddingToText - rightPaddingToText, height: heightOfDesc);
        numberOFlines = countLabelLines(label: senderChatView.chatMessage);
        var addHeightToSingleLine: CGFloat = 0.0;

        if (boundingBox.width < minBubbleWidth) {

            addHeightToSingleLine = 0.0;
            senderChatView.senderChatBoxView.frame = CGRect.init(x: chatFeatureView.chatMessageScrollView.frame.width - (15 + 24 +
                boundingBox.width + timeBoundingBox.width + senderChatView.chatMsgStatus.frame.width + leftPaddingToText + rightPaddingToText), y: 9, width: boundingBox.width + timeBoundingBox.width + senderChatView.chatMsgStatus.frame.width + widthOfSpeechArrow + leftPaddingToText + rightPaddingToText, height: heightOfDesc + 2*paddingBetweenChatTextAndBubble + addHeightToSingleLine);
            
        } else if (numberOFlines == 1) {
            
            addHeightToSingleLine = 0.0;
            senderChatView.senderChatBoxView.frame = CGRect.init(x: chatFeatureView.chatMessageScrollView.frame.width - (15 + 24 + boundingBox.width + timeBoundingBox.width + senderChatView.chatMsgStatus.frame.width + leftPaddingToText + rightPaddingToText)
            , y: 9, width: boundingBox.width + timeBoundingBox.width  + senderChatView.chatMsgStatus.frame.width + widthOfSpeechArrow + leftPaddingToText + rightPaddingToText, height: CGFloat(heightOfUILabel*numberOFlines) + 2*paddingBetweenChatTextAndBubble + addHeightToSingleLine);
        } else {
            //Setting Frame for Sender Chat Box *******
            senderChatView.senderChatBoxView.frame = CGRect.init(x: senderChatView.senderChatBoxView.frame.origin.x, y: 9, width: maxWidth, height: CGFloat(heightOfUILabel*numberOFlines) + 2*paddingBetweenChatTextAndBubble);
        }
        senderChatView.senderChatBoxView.layer.cornerRadius = 10;
        
        if (boundingBox.width < minBubbleWidth) {
            senderChatView.chatMessage.frame = CGRect.init(x: senderChatView.chatMessage.frame.origin.x
        , y: senderChatView.chatMessage.frame.origin.y, width: self.chatFeatureView.chatMessageScrollView.frame.width - (55), height: heightOfDesc);
            
            numberOFlines = countLabelLines(label: senderChatView.chatMessage);
            print(numberOFlines);

        } else {
            
            print("Chat message origin : ",senderChatView.chatMessage.frame.origin.y);
            //10 is the start padding of text
            senderChatView.chatMessage.frame = CGRect.init(x: 10 , y: senderChatView.chatMessage.frame.origin.y, width: maxWidth - timeBoundingBox.width - senderChatView.chatMsgStatus.frame.width - leftPaddingToText - rightPaddingToText, height: CGFloat(numberOFlines*heightOfUILabel));
            
            numberOFlines = countLabelLines(label: senderChatView.chatMessage);
            print(numberOFlines);
        }

        //Setting frame for chat message
        if (eventChat.chatStatus == "Read") {
            senderChatView.chatMsgStatus.image = UIImage.init(named: "read_chat_msg")
        } else {
            senderChatView.chatMsgStatus.image = UIImage.init(named: "sent_chat_msg")
        }
        senderChatView.chatMsgStatus.frame = CGRect.init(x: senderChatView.senderChatBoxView.frame.width - (senderChatView.chatMsgStatus.frame.width + 9), y: CGFloat(numberOFlines*heightOfUILabel) - 2, width: senderChatView.chatMsgStatus.frame.width, height: senderChatView.chatMsgStatus.frame.height);

        
        //Setting Frame for Chat Time *******
        if (eventChat.createdAt == nil) {
            eventChat.createdAt = event.createdAt;
        }
        if (eventChat.createdAt == nil) {
            eventChat.createdAt = event.updateAt;
        }
        if (eventChat.createdAt == nil) {
            eventChat.createdAt = Date().millisecondsSince1970;
        }
        senderChatView.chatTime.text = chatTime;
        senderChatView.chatTime.frame = CGRect.init(x: senderChatView.senderChatBoxView.frame.width - (senderChatView.chatTime.frame.width + senderChatView.chatMsgStatus.frame.width + 10), y: CGFloat(numberOFlines*heightOfUILabel) - 2, width: senderChatView.chatTime.frame.width, height: senderChatView.chatTime.frame.height);
        //Setting Frame for Sender Chat Main View *******
        senderChatView.frame = CGRect.init(x: 0, y: descriptionHeight, width: self.chatFeatureView.chatMessageScrollView.frame.width, height: senderChatView.senderChatBoxView.frame.height + gapBetweenChatBubbles);
        print("Sender Chat View : ", senderChatView.frame);
                
        descriptionHeight = descriptionHeight + senderChatView.frame.height;

        senderChatView.layoutIfNeeded();
        
        let path = UIBezierPath();
        path.move(to : CGPoint(x: senderChatView.senderChatBoxView.frame.width - 6 , y: senderChatView.senderChatBoxView.frame.origin.y - 8.5));
        path.addLine(to: CGPoint(x: senderChatView.senderChatBoxView.frame.width + 15, y: senderChatView.senderChatBoxView.frame.origin.y - 8.5));
        path.addLine(to: CGPoint(x: senderChatView.senderChatBoxView.frame.width - 6, y: senderChatView.senderChatBoxView.frame.origin.y + 9));
        path.close();
        
        let bubbleLayer = CAShapeLayer()
        bubbleLayer.path = path.cgPath;
        bubbleLayer.fillColor = senderChatView.senderChatBoxView.backgroundColor?.cgColor;
        bubbleLayer.strokeColor = senderChatView.senderChatBoxView.backgroundColor?.cgColor
        senderChatView.senderChatBoxView.layer.addSublayer(bubbleLayer)
        self.chatFeatureView.chatMessageScrollView.addSubview(senderChatView);
        
        let tempDict: [CGFloat: String] = [senderChatView.frame.height: eventChat.chat];
        self.chatViewItemAndHeight.append(tempDict);
        
        return descriptionHeight;
    }
    
    func createAttendeeView(eventChat: EventChat, descriptionHeightParam: CGFloat) -> CGFloat {
        
        var descriptionHeight = descriptionHeightParam;

        let attandeeChatView = AttendeeChatView.instanceFromNib() as! AttendeeChatView;
        attandeeChatView.chatTime.text = Date.init(millis: eventChat.createdAt).hmma();

        //Lets find the height of Text Message
        let heightOfDesc = self.heightForView(text: eventChat.chat, font: attandeeChatView.chatLbl.font, width: self.chatFeatureView.chatMessageScrollView.frame.width - (20 + 30  + attandeeChatView.chatTime.intrinsicContentSize.width + 20));

        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: heightOfDesc)
        let boundingBox = eventChat.chat.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: attandeeChatView.chatLbl.font], context: nil)
        
        //Lets fetch the bounds of Chat Time
        let chatTime = Date.init(millis: eventChat.createdAt).hmma();
        let timeConstraintRect = CGSize(width: .greatestFiniteMagnitude, height: attandeeChatView.chatTime.frame.height);
        let timeBoundingBox = chatTime.boundingRect(with: timeConstraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: attandeeChatView.chatTime.font], context: nil);

        //Lets find the number of lines of chat message uilabel
        if (eventChat.chatEdited == EventChatEdited.YES) {
            if (!eventChat.chat.contains("(Edited)")) {
                eventChat.chat = eventChat.chat + " (Edited)";
            }
        }
        attandeeChatView.chatLbl.unselectedTextColorChange(fullText: eventChat.chat, changeText: "(Edited)");
        var numberOFlines: Int = 0;
        let heightOfUILabel: Int = 20;
        attandeeChatView.chatLbl.frame = CGRect.init(x: 10 , y: attandeeChatView.chatLbl.frame.origin.y, width: self.chatFeatureView.chatMessageScrollView.frame.width - (20 + 30 +  timeBoundingBox.width + 20), height: heightOfDesc);
        numberOFlines = countLabelLines(label: attandeeChatView.chatLbl);
        
        var addHeightToSingleLine: CGFloat = 0.0;
        if (boundingBox.width < 80) {
            
            //addHeightToSingleLine = 10.0;
            //Seeting frame size for chat message and time
             attandeeChatView.chatLblView.frame = CGRect.init(x: attandeeChatView.chatLblView.frame.origin.x
                , y: 9, width: boundingBox.width + 20 + timeBoundingBox.width + attandeeChatView.profilePic.frame.width/2 + 15.0, height: heightOfDesc + 2*paddingBetweenChatTextAndBubble + addHeightToSingleLine);

        } else if (numberOFlines == 1) {
            
            //addHeightToSingleLine = 10.0;
            //Seeting frame size for chat message and time
             attandeeChatView.chatLblView.frame = CGRect.init(x: attandeeChatView.chatLblView.frame.origin.x
                , y: 9, width: boundingBox.width + timeBoundingBox.width + 50, height: heightOfDesc + 2*paddingBetweenChatTextAndBubble + addHeightToSingleLine);
       } else {
            //Seeting frame size for chat message and time
            
            print("Multi Line Chat : ", eventChat.chat);
             attandeeChatView.chatLblView.frame = CGRect.init(x: attandeeChatView.chatLblView.frame.origin.x
                , y: 9, width: self.chatFeatureView.chatMessageScrollView.frame.width - (20 + 30), height: heightOfDesc + 2*paddingBetweenChatTextAndBubble);
                            
        }
        
        
        //Setting frame for CHAT LABEL ******
        if (boundingBox.width < 80) {
            
            attandeeChatView.chatLbl.frame = CGRect.init(x: attandeeChatView.profilePic.frame.width/2 + 10.0, y: 10, width: boundingBox.width + timeBoundingBox.width, height: heightOfDesc);
            
        } else if (numberOFlines == 1) {
            
            attandeeChatView.chatLbl.frame = CGRect.init(x: attandeeChatView.profilePic.frame.width/2 + 5.0, y: 10, width: self.chatFeatureView.chatMessageScrollView.frame.width - (60) - 30, height: heightOfDesc);

        } else {
            attandeeChatView.chatLbl.frame = CGRect.init(x: attandeeChatView.profilePic.frame.width/2 + 5.0, y: 10, width: self.chatFeatureView.chatMessageScrollView.frame.width - (20 + 30 + timeBoundingBox.width + 20), height: heightOfDesc);
        }
        
                       
        attandeeChatView.chatLblView.layer.cornerRadius = 10;
        attandeeChatView.chatLblView.backgroundColor = UIColor.white;

        //Setting Frame for Chat Time *******
        if (eventChat.createdAt == nil) {
            eventChat.createdAt = event.createdAt;
        }
        if (eventChat.createdAt == nil) {
            eventChat.createdAt = event.updateAt;
        }
        if (eventChat.createdAt == nil) {
            eventChat.createdAt = Date().millisecondsSince1970;
        }

        attandeeChatView.chatTime.frame = CGRect.init(x: attandeeChatView.chatLblView.frame.width - (attandeeChatView.chatTime.frame.width + 10), y: heightOfDesc - 2.0, width: attandeeChatView.chatTime.frame.width, height: attandeeChatView.chatTime.frame.height);
        
         if (eventChat.user != nil && eventChat.user.photo != nil) {
             attandeeChatView.profilePic.sd_setImage(with: URL.init(string: eventChat.user.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
         } else {
             attandeeChatView.profilePic.image = UIImage.init(named: "profile_pic_no_image");
         }
         
        //Lets set the frame for profile pic
        if (numberOFlines == 1) {
            attandeeChatView.profilePic.frame = CGRect.init(x: attandeeChatView.profilePic.frame.origin.x, y: attandeeChatView.chatLblView.frame.height - attandeeChatView.profilePic.frame.width/3, width: attandeeChatView.profilePic.frame.width, height: attandeeChatView.profilePic.frame.height);
        } else {
            attandeeChatView.profilePic.frame = CGRect.init(x: attandeeChatView.profilePic.frame.origin.x, y: attandeeChatView.chatLblView.frame.height - attandeeChatView.profilePic.frame.width/2, width: attandeeChatView.profilePic.frame.width, height: attandeeChatView.profilePic.frame.height);
        }
         
         
        attandeeChatView.hostGradientColor.frame = attandeeChatView.profilePic.frame;

         if (eventChat.user.userId == event.createdById) {
             attandeeChatView.hostGradientColor.isHidden = false;
         } else {
             attandeeChatView.hostGradientColor.isHidden = true;
             attandeeChatView.profilePic.layer.borderWidth = 1.5;
             attandeeChatView.profilePic.layer.borderColor = UIColor.white.cgColor;
         }
        attandeeChatView.frame = CGRect.init(x: self.chatFeatureView.chatMessageScrollView.frame.origin.x, y: descriptionHeight, width: self.chatFeatureView.chatMessageScrollView.frame.width, height: attandeeChatView.chatLblView.frame.height + attandeeChatView.profilePic.frame.height/2 + gapBetweenChatBubbles);
         
        descriptionHeight = descriptionHeight + attandeeChatView.frame.height;
         attandeeChatView.layoutSubviews();
        attandeeChatView.layoutIfNeeded();

        self.chatFeatureView.chatMessageScrollView.addSubview(attandeeChatView);
        let tempDict: [CGFloat: String] = [attandeeChatView.frame.height: eventChat.chat];
        self.chatViewItemAndHeight.append(tempDict);
        
        return descriptionHeight;
    }
    
    func makeMessagesAsRead() {
        let apiUpdateStatus = "\(apiUrl)api/eventchat/updateStatus";
        var postData = [String: Any]();
        postData["eventId"] = self.event.eventId;
        postData["userId"] = self.loggedInUser.userId;

        GatheringService().gatheringCommonPostAPI(api: apiUpdateStatus, postData: postData, token: self.loggedInUser.token, complete: {response in
        });
    }
    
    func countLabelLines(label: UILabel) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = label.text! as NSString
        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }

    func expandTextField() {

        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                //Frame Option 1:
            self.chatBoxView.frame = CGRect(x: 0, y: self.view.frame.height - 230, width: self.view.frame.width, height: self.chatBoxView.frame.height);
            print("Final Width : ",self.chatBoxView.frame.width);
            
            },completion: { finish in
                self.chatBoxView.sendMessageTextField.becomeFirstResponder();
           
        });
    }
    
    func fetchLocationPhotos(placeId: String) {
        let queryStr = "place_id=\(placeId)&fields=photos&key=\(googleMapApiKey)";
        
        UserService().commonGetWithoutAuthCall(queryStr: queryStr, apiEndPoint: LocationService().get_place_details_api, token: "", complete: {response in
            
            let resultDict = response.value(forKey: "result") as! NSDictionary;
            let photoArr = resultDict.value(forKey: "photos") as! NSArray;
            
            self.locationPhotos = LocationPhoto().loadLocationPhotoByArray(locArr: photoArr);
            
        });
    }
    @objc func tapToChatPressed() {
        //expandTextField();
        if (isKeyboardVisible == false) {
            
            self.chatBoxView = ChatBoxView.instanceFromNib() as! ChatBoxView;
            self.view.addSubview(self.chatBoxView);
            chatBoxView.frame = CGRect(x: view.frame.width - 230, y: view.frame.height - 230, width: 155, height: chatBoxView.frame.height);
            
            print("Initial Width : ",chatBoxView.frame.width);
            //chatBoxView.sendMessageTextField.becomeFirstResponder();
                        
            isKeyboardVisible = true;
            for tapToChatViewTemp in self.chatFeatureView.subviews {
                if (tapToChatViewTemp is TapToChatView) {
                    tapToChatViewTemp.removeFromSuperview();
                }
            }
            expandTextField();
        } else {
            
            for chatBoxViewTemp in self.view.subviews {
                if (chatBoxViewTemp is ChatBoxView) {
                    self.chatBoxView = chatBoxViewTemp as! ChatBoxView;
                    break;
                }
            }
            //self.chatBoxView.sendMessageTextField.resignFirstResponder();
            isKeyboardVisible = false;
            addTapToChatViewSection();

        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        self.invitationCardTableView.isScrollEnabled = false;

        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
              print(keyboardRect.height)
            
            for chatBoxViewTemp in self.view.subviews {
                if (chatBoxViewTemp is ChatBoxView) {
                    self.chatBoxView = chatBoxViewTemp as! ChatBoxView;
                    break;
                }
            }
            if (self.chatBoxView == nil) {
                self.chatBoxView = ChatBoxView.instanceFromNib() as! ChatBoxView;
            }
            let sendMessageBtnGesture = GatheringTapGesture.init(target: self, action: #selector(sendChatMessageButtonPressed));            self.chatBoxView.sendMessageBtn.addGestureRecognizer(sendMessageBtnGesture);

            self.chatBoxView.frame = CGRect(x: 0, y: view.frame.height - keyboardRect.height - self.chatBoxView.frame.height, width: keyboardRect.width, height: self.chatBoxView.frame.height);
            
            if (self.chatFeatureView == nil) {
                self.chatFeatureView = ChatFeatureView.instanceFromNib() as! ChatFeatureView;
            }
            
            for tapToChatViewTemp in self.chatFeatureView.subviews {
                if (tapToChatViewTemp is TapToChatView) {
                    tapToChatViewTemp.removeFromSuperview();
                    self.tapToChatView = nil;
                }
            }
            self.chatFeatureView.frame = CGRect.init(x: 25, y: self.view.frame.height - 400 - keyboardRect.height, width: self.view.frame.width - 30, height: 400);
            self.chatFeatureView.chatMessageScrollView.frame = CGRect.init(x: self.chatFeatureView.chatMessageScrollView.frame.origin.x, y: 0, width: self.chatFeatureView.frame.width, height: 300);
            self.chatFeatureView.chatMessageScrollView.contentOffset.x = 0;
            
            scrollToBottomScrollView();
            
            self.chatBoxView.sendMessageTextField.delegate = self;
            if (self.inputChatMessageText != "") {
                self.chatBoxView.sendMessageTextField.text = self.inputChatMessageText;
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        self.invitationCardTableView.isScrollEnabled = false;

        self.inputChatMessageText = self.chatBoxView.sendMessageTextField.text!;

        isKeyboardVisible = false;
        for chatBoxView in self.view.subviews {
            if (chatBoxView is ChatBoxView) {
                chatBoxView.removeFromSuperview();
            }
        }
        
        self.chatFeatureView.frame = CGRect.init(x: 25, y: self.view.frame.height - 550, width: self.view.frame.width - 30, height: 400);
        self.chatFeatureView.chatMessageScrollView.frame = CGRect.init(x: self.chatFeatureView.chatMessageScrollView.frame.origin.x, y: 0, width: self.chatFeatureView.frame.width, height: 300);
        self.chatFeatureView.chatMessageScrollView.contentOffset.x = 0;

        addTapToChatViewSection();
        
    }
        
    @objc func sendChatMessageButtonPressed(sendMessageBtnGesture: GatheringTapGesture) {
        
        if (self.chatBoxView.sendMessageTextField.text! != "") {
            
            self.invitationCardTableView.isScrollEnabled = true;
            if (self.isKeyboardVisible == true) {
                self.chatBoxView.sendMessageBtn.isHidden = true;
                self.chatBoxView.activiyIndicator.isHidden = false;
                self.chatBoxView.activiyIndicator.startAnimating();
            }
            postEventChat(chatMessage: self.chatBoxView.sendMessageTextField.text!);
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
            
            if (event.scheduleAs == EventScheduleAs.NOTIFICATION) {
                    
                let cell : WelcomeCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCardTableViewCell") as! WelcomeCardTableViewCell;
                
                return cell;
                
            }
            
            let cell : InvitationCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InvitationCardTableViewCell") as! InvitationCardTableViewCell;
            cell.gatheringInvitaionViewControllerDelegate = self;
            
            leftToRightGestureEnabled = true;
            rightToLeftGestureEnabled = true;
            
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
            cell.profilePic.isUserInteractionEnabled = true;
            cell.profilePic.tag = -1;
            cell.profilePic.addGestureRecognizer(self.profilePicTapGuesture);

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

            let uiTapGuestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(cardPressed));
            cell.topHeaderView.addGestureRecognizer(uiTapGuestureRecognizer)
        
            if (selectedEventChatDto != nil && selectedEventChatDto.showChatWindow == true) {
                selectedEventChatDto.showChatWindow = false;
                cell.descriptionViewPressed();
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
