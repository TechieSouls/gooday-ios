//
//  GuestListViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 11/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

class GuestListViewController: UIViewController {

    
    @IBOutlet weak var guestListTableView: UITableView!
    
    @IBOutlet weak var closeIcon: UIImageView!
    
    
    @IBOutlet weak var invitedUiView: UIView!
    
    @IBOutlet weak var acceptedUIView: UIView!

    @IBOutlet weak var declinedUIView: UIView!
    
    
    @IBOutlet weak var invitedUIViewUILabel: UILabel!
    
    @IBOutlet weak var acceptedUIViewUILabel: UILabel!
    
    @IBOutlet weak var declinedUIViewUILabel: UILabel!
    
    @IBOutlet weak var noGuestsLabel: UILabel!
    
    @IBOutlet weak var invitedViewFooterLabel: UILabel!
    
    @IBOutlet weak var acceptedViewFooterLabel: UILabel!
    
    @IBOutlet weak var declinedViewFooterLabel: UILabel!
    
    
    var event: Event!;
    
    var filteredEventMembers: [EventMember] = [EventMember]();
    
    var loggedInUser: User!;
    
    var isLoggedInUserAsOwner: Bool = false;
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()

        let closeImageTapGesture = UITapGestureRecognizer(target: self, action: Selector("closeIconPressed"));
        closeIcon.addGestureRecognizer(closeImageTapGesture);
        
        let invitedViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("invitedUiViewPressed"));
        invitedUiView.addGestureRecognizer(invitedViewTapGesture);
        
        
        let acceptedViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("acceptedUIViewPressed"));
        acceptedUIView.addGestureRecognizer(acceptedViewTapGesture);
        
        
        let declinedViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("declinedUIViewPressed"));
        declinedUIView.addGestureRecognizer(declinedViewTapGesture);
        
        
        // Do any additional setup after loading the view.
        guestListTableView.register(UINib(nibName: "GuestListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GuestListTableViewCell")
        
        invitedUiView.layer.borderColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor;
        invitedUiView.layer.borderWidth = 5;
        invitedUiView.layer.shadowOffset = CGSize(width: 0, height: 2)
        invitedUiView.layer.shadowColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.5).cgColor
        invitedUiView.layer.shadowOpacity = 1
        invitedUiView.layer.shadowRadius = 2
        invitedUiView.roundedView();

        invitedUIViewUILabel.textColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        
        acceptedUIView.roundedView();
        acceptedUIView.layer.borderWidth = 5
        acceptedUIView.layer.borderColor = UIColor.white.cgColor
        
        declinedUIView.roundedView();
        declinedUIView.layer.borderWidth = 5
        declinedUIView.layer.borderColor = UIColor.white.cgColor
        
        if (self.event.eventMembers != nil) {
            invitedUIViewUILabel.text = String(self.event.eventMembers!.count);
        } else {
            invitedUIViewUILabel.text = "0";
        }
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        context = self.appDelegate.persistentContainer.viewContext

        var acceptedCount = 0;
        var declinedCount = 0;
        if (self.event.eventMembers != nil && self.event.eventMembers.count > 0) {
            for eventMem in self.event.eventMembers! {
                if (eventMem.status == "Going") {
                    acceptedCount = acceptedCount + 1;
                } else if (eventMem.status == "NotGoing") {
                    declinedCount = declinedCount + 1;
                }
            }
        }
        acceptedUIViewUILabel.text = String(acceptedCount);
        declinedUIViewUILabel.text = String(declinedCount);
        
        if (self.event.eventId != 0) {
            //For Loop to fetch the host of the event
            //Host should be at the top of the list
            if (self.event.eventMembers != nil && self.event.eventMembers.count > 0) {
                for evemem in self.event.eventMembers! {
                                
                    if (evemem.userId != nil && evemem.userId != 0
                        && evemem.userId == self.event.createdById) {
                        evemem.owner = true;
                        
                        if (loggedInUser.userId ==  evemem.userId) {
                            self.isLoggedInUserAsOwner = true;
                        }
                        
                        self.filteredEventMembers.append(evemem);
                        break;
                    }
                }
                
                //We will again iterate the loop to fetch all other guests
                //except owner and they should be below host
                for evemem in self.event.eventMembers! {

                    if (evemem.userId != nil && evemem.userId != 0 && evemem.userId != self.event.createdById) {
                        evemem.owner = false;
                        self.filteredEventMembers.append(evemem);
                    }
                }
                
                if (self.isLoggedInUserAsOwner == true) {
                    for evemem in self.event.eventMembers! {

                        if (evemem.userId == nil || evemem.userId == 0) {
                            self.filteredEventMembers.append(evemem);
                        }
                    }
                } else {
                    //We will again iterate the loop to fetch all non cenes users
                    var nonCenesUserCount = 0;
                    for evemem in self.event.eventMembers! {
                        if (evemem.userId == nil || evemem.userId == 0) {
                            nonCenesUserCount = nonCenesUserCount + 1;
                        }
                    }
                    if (nonCenesUserCount > 0) {
                        let eveMem = EventMember();
                        eveMem.name = "and \(nonCenesUserCount) Others";
                        self.filteredEventMembers.append(eveMem);
                    }
                }
            }
        } else {
            
            self.filteredEventMembers = [EventMember]();
            
            if (self.event.eventMembers != nil && self.event.eventMembers.count > 0) {
                for eventMem in self.event.eventMembers! {
                    self.filteredEventMembers.append(eventMem);
                }
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
    
    @objc func closeIconPressed() {
        print("Close Clicked")
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func invitedUiViewPressed() {
        
        self.activeInvitedView();
        self.deactivateDeclinedView();
        self.deactivateAcceptedView();
        
        
        self.filteredEventMembers = [EventMember]();
        if (self.event.eventId != 0) {
            //For Loop to fetch the host of the event
            //Host should be at the top of the list
            for evemem in self.event.eventMembers! {
                
                if (evemem.userId != nil  && evemem.userId != 0 && evemem.userId == self.event.createdById) {
                    evemem.owner = true;
                    self.filteredEventMembers.append(evemem);
                    break;
                }
            }
            
            //We will again iterate the loop to fetch all other guests
            //except owner and they should be below host
            for evemem in self.event.eventMembers! {
                
                if (evemem.userId != nil && evemem.userId != 0 && evemem.userId != self.event.createdById) {
                    evemem.owner = false;
                    self.filteredEventMembers.append(evemem);
                }
            }
            
            if (self.isLoggedInUserAsOwner == true) {
                for evemem in self.event.eventMembers! {

                    if (evemem.userId == nil || evemem.userId == 0) {
                        self.filteredEventMembers.append(evemem);
                    }
                }
            } else {
                //We will again iterate the loop to fetch all non cenes users
                var nonCenesUserCount = 0;
                for evemem in self.event.eventMembers! {
                    
                    if (evemem.userId == nil || evemem.userId == 0) {
                        nonCenesUserCount = nonCenesUserCount + 1;
                    }
                }
                if (nonCenesUserCount > 0) {
                    let eveMem = EventMember();
                    eveMem.name = "and \(nonCenesUserCount) Others";
                    self.filteredEventMembers.append(eveMem);
                }
            }

        } else {
            self.filteredEventMembers = [EventMember]();
            for eventMem in self.event.eventMembers {
                self.filteredEventMembers.append(eventMem);
            }
        }

        self.guestListTableView.isHidden = false;
        self.noGuestsLabel.isHidden = true
        self.guestListTableView.reloadData();
    }
    
    @objc func acceptedUIViewPressed() {
        
        self.activeAcceptedView();
        self.deactivateInvitedView();
        self.deactivateDeclinedView();
        
        self.filteredEventMembers = [EventMember]();

        //Lets first find the host
        if (self.event.eventMembers != nil) {
            for evemem in self.event.eventMembers! {
                if (evemem.userId != nil && evemem.userId != 0
                    && evemem.userId == self.event.createdById) {
                    evemem.owner = true;
                    self.filteredEventMembers.append(evemem);
                    break;
                }
            }
        }

        //We will again iterate the loop to fetch all other guests
        //except owner and they should be below host
        if (self.event.eventMembers != nil) {
            for evemem in self.event.eventMembers! {

                if (evemem.userId != nil && evemem.userId != 0 && evemem.userId != self.event.createdById && evemem.status == "Going") {
                    evemem.owner = false;
                    self.filteredEventMembers.append(evemem);
                }
            }
        }
        
        if (self.filteredEventMembers.count == 0) {
            noGuestsLabel.isHidden = false;
            self.guestListTableView.isHidden = true;

        } else {
            noGuestsLabel.isHidden = true;
            self.guestListTableView.isHidden = false;
            self.guestListTableView.reloadData();
        }
    }
    
    @objc func declinedUIViewPressed() {
        
        self.activeDeclinedView();
        self.deactivateInvitedView();
        self.deactivateAcceptedView();
        
        self.filteredEventMembers = [EventMember]();

        if (self.event.eventMembers != nil) {
            for eventMem in self.event.eventMembers! {

                if (eventMem.status == "NotGoing") {
                    filteredEventMembers.append(eventMem);
                }
            }
        }
        
        if (self.filteredEventMembers.count == 0) {
            noGuestsLabel.isHidden = false;
            self.guestListTableView.isHidden = true;
        } else {
            noGuestsLabel.isHidden = true;
            self.guestListTableView.isHidden = false;
            self.guestListTableView.reloadData();
        }
    }
    
    func activeAcceptedView() {
        acceptedUIView.layer.borderColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor;
        acceptedUIView.backgroundColor = UIColor.white
        acceptedUIView.layer.borderWidth = 5;
        acceptedUIView.layer.shadowOffset = CGSize(width: 0, height: 2)
        acceptedUIView.layer.shadowColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.5).cgColor
        acceptedUIView.layer.shadowOpacity = 1
        acceptedUIView.layer.shadowRadius = 2
        
        acceptedUIViewUILabel.textColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        acceptedViewFooterLabel.textColor = UIColor.black

    }
    func deactivateAcceptedView() {
        acceptedUIView.layer.borderColor = UIColor.white.cgColor;
        acceptedUIView.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 239/255, alpha: 1);
        acceptedUIView.layer.borderWidth = 5;
        acceptedUIView.layer.shadowColor = nil
        acceptedUIView.layer.shadowOpacity = 0
        acceptedUIView.layer.shadowRadius = 0
        
        acceptedUIViewUILabel.textColor = UIColor.white;
        acceptedViewFooterLabel.textColor = UIColor.lightGray
    }
    
    func activeInvitedView() {
        invitedUiView.layer.borderColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor;
        invitedUiView.backgroundColor = UIColor.white
        invitedUiView.layer.borderWidth = 5;
        invitedUiView.layer.shadowOffset = CGSize(width: 0, height: 2)
        invitedUiView.layer.shadowColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.5).cgColor
        invitedUiView.layer.shadowOpacity = 1
        invitedUiView.layer.shadowRadius = 2
        
        invitedUIViewUILabel.textColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        invitedViewFooterLabel.textColor = UIColor.black

    }
    func deactivateInvitedView() {
        invitedUiView.layer.borderColor = UIColor.white.cgColor;
        invitedUiView.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 239/255, alpha: 1);
        invitedUiView.layer.borderWidth = 5;
        invitedUiView.layer.shadowColor = nil
        invitedUiView.layer.shadowOpacity = 0
        invitedUiView.layer.shadowRadius = 0
        
        invitedUIViewUILabel.textColor = UIColor.white;
        invitedViewFooterLabel.textColor = UIColor.lightGray


    }
    
    func activeDeclinedView() {
        declinedUIView.layer.borderColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor;
        declinedUIView.backgroundColor = UIColor.white
        declinedUIView.layer.borderWidth = 5;
        declinedUIView.layer.shadowOffset = CGSize(width: 0, height: 2)
        declinedUIView.layer.shadowColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.5).cgColor
        declinedUIView.layer.shadowOpacity = 1
        declinedUIView.layer.shadowRadius = 2
        
        declinedUIViewUILabel.textColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        declinedViewFooterLabel.textColor = UIColor.black

    }
    func deactivateDeclinedView() {
        declinedUIView.layer.borderColor = UIColor.white.cgColor;
        declinedUIView.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 239/255, alpha: 1);
        declinedUIView.layer.borderWidth = 5;
        declinedUIView.layer.shadowColor = nil
        declinedUIView.layer.shadowOpacity = 0
        declinedUIView.layer.shadowRadius = 0
        
        declinedUIViewUILabel.textColor = UIColor.white;
        declinedViewFooterLabel.textColor = UIColor.lightGray

    }
}

extension GuestListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEventMembers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eventMember = self.filteredEventMembers[indexPath.row];
        
        let cell: GuestListTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "GuestListTableViewCell", for: indexPath) as! GuestListTableViewCell;
        
        var hostPrefix = "";

        if (eventMember.userId == event.createdById) {
            hostPrefix = " (Host)";
        }
        
        //Setting Cenes Name
        if (eventMember.user != nil && eventMember.user!.name != nil) {
            cell.cenesName.text = eventMember.user!.name! + hostPrefix;
        } else if (eventMember.name != nil) {
            cell.cenesName.text = eventMember.name! + hostPrefix;
        } else if (eventMember.userContact != nil && eventMember.userContact.name != nil) {
            cell.cenesName.text = eventMember.userContact.name! + hostPrefix;
        }
        
        //Setting Phonebook Name
        //if (self.event.createdById == self.loggedInUser.userId) {
            
            if (eventMember.user != nil && eventMember.user!.name != nil) {
                if (eventMember.userId != nil && eventMember.userId != 0 && eventMember.userId != loggedInUser.userId && eventMember.userContact != nil) {
                    cell.contactName.isHidden = false;
                    cell.contactName.text = eventMember.userContact!.name;
                } else if (eventMember.userId != nil && eventMember.userId != 0 && eventMember.userId == loggedInUser.userId) {
                    cell.contactName.isHidden = false;
                    cell.contactName.text = "You";
                } else {
                    cell.contactName.isHidden = true;
                }
            } else {
               cell.contactName.isHidden = true;
            }
        //} else {
        //    cell.contactName.isHidden = true;
        //}
        
        //Setting Image
        if (eventMember.user != nil && eventMember.user!.photo != nil) {
            cell.profilePic.sd_setImage(with: URL(string: eventMember.user!.photo!), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
        } else {
            cell.profilePic.image = UIImage.init(named: "profile_pic_no_image");
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
}
