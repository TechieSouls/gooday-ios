//
//  FriendsViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 03/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

protocol CollectionFriendsProtocol {
    func collectionFriendsList(selectedFriendHolder: [EventMember])
}
protocol CreateGatheringProtocol {
    func friendsDonePressed(eventMembers: [EventMember]);
}
class FriendsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var friendTableView: UITableView!;
    @IBOutlet weak var searchContactsField: UITextField!
    
    var collectionFriendsDelegate: CollectionFriendsProtocol?;
    var loggedInUser: User!;
    var inviteFriendsDto: InviteFriendsDto = InviteFriendsDto();
    var isFirstTime: Bool = true;
    var createGatheringProtocolDelegate: CreateGatheringProtocol!;
    var eventId: Int32!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Invite Guests";
        self.tabBarController?.tabBar.isHidden = true;

        friendTableView.backgroundColor = themeColor;
        friendTableView.register(UINib(nibName: "FriendCollectionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FriendCollectionTableViewCell")
        friendTableView.register(UINib(nibName: "AllAndCenesContactsSwitchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "AllAndCenesContactsSwitchTableViewCell")
        friendTableView.register(UINib(nibName: "FriendsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FriendsTableViewCell")
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        self.setupNavigationBarItems();
        
        if (eventId == nil && inviteFriendsDto.selectedFriendCollectionViewList.count == 0) {
            var userExistsInList = false;
            for userContact in inviteFriendsDto.selectedFriendCollectionViewList {
                if (userContact.user != nil && (userContact.user.userId == self.loggedInUser.userId)) {
                    userExistsInList = true;
                    break;
                }
            }
            if (userExistsInList == false) {

                let loggedInUserContact = Event().getLoggedInUserAsUserContact();
                //print(loggedInUserContact.description);
                inviteFriendsDto.selectedFriendCollectionViewList.append(loggedInUserContact);
            }
        }
        
        if (isFirstTime == true || (eventId != nil && eventId != 0)) {
            self.getFriendsWithName(nameStartsWith: "")
        } else {
            self.friendTableView.reloadData()
            isFirstTime = false
        }
        
        PhonebookService.getPermissionForContacts();
        DispatchQueue.global(qos: .background).async {
            self.syncDeviceContacts();
        }
        
        searchContactsField.layer.cornerRadius = 10
        searchContactsField.leftViewMode = UITextFieldViewMode.always

        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        let image = UIImage(named: "search_icon")
        imageView.image = image
        
        let view = UIView(frame : CGRect(x: 0, y: 0, width: 35, height: 25))
        view.addSubview(imageView)

        searchContactsField.leftView = view
        searchContactsField.addTarget(self, action: #selector(updateSearchResults), for: .editingChanged)
        
        self.hideKeyboardWhenTappedAround();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Invite Guests";
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupNavigationBarItems() {
        
        self.navigationController?.navigationBar.isHidden = false;
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Cancel", for: .normal)
        closeButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20);
        closeButton.addTarget(self, action: #selector(selectFriendsCancel(_ :)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton);

        self.refreshNavigationBarItems();
    }
    
    func refreshNavigationBarItems() {
        //if (inviteFriendsDto.selectedFriendCollectionViewList.count  > 0) {
            let doneButton = UIButton(type: .system);
            doneButton.setTitle("Save", for: .normal);
            doneButton.addTarget(self, action: #selector(selectFriendsDone(_ :)), for: .touchUpInside)
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton);
        /*} else {
            self.navigationItem.rightBarButtonItem = nil;
        }*/
    }
    
    @objc func updateSearchResults(_ textField: UITextField) {
                let searchText = textField.text!;
        if (searchText != "") {
            inviteFriendsDto.isSearchOn = true;
            self.getfilterArray(str: searchText);
        } else {
            inviteFriendsDto.isSearchOn = false;
            self.getfilterArray(str: "");
        }
    }
    
    func syncDeviceContacts() {
        UserService().syncDevicePhoneNumbers(complete: {(response)  in
            
        });
    }
    func getFriendsWithName(nameStartsWith:String) {
        print("Calling API")
        
        //Call api for friends
        WebService().cancelAll()
        
        //self.inviteFriendsDto.allEventMembers = CenesUserContactModel().fetchAllUserContacts(user: loggedInUser);
        //self.processFriendsList();
        //self.friendTableView.reloadData();

        if (Connectivity.isConnectedToInternet == true) {
            let queryStr = "userId=\(String(self.loggedInUser.userId))"
            UserService().findUserFriendsByUserId(queryStr: queryStr, token: self.loggedInUser.token, complete: { (returnedDict) in
                if returnedDict.value(forKey: "success") as? Bool == false {
                    self.showAlert(title: "Error", message: (returnedDict["message"] as? String)!)
                }else{
                    
                    CenesUserContactModel().deleteAllCenesUserContactMO();
                    self.inviteFriendsDto.allEventMembers = CenesUserContactModel().loadUserContactsMO(eventMemberArray: returnedDict["data"] as! NSArray);
                        self.processFriendsList();
                    self.friendTableView.reloadData();

                }
                self.friendTableView.reloadData();
            });
        }
        
    }
    
    func processFriendsList() {
        
        self.inviteFriendsDto.filteredEventMembers = self.inviteFriendsDto.allEventMembers;
        
        for userContact in self.inviteFriendsDto.allEventMembers {
            if (userContact.userContactId != nil && userContact.userContactId != 0) {
                self.inviteFriendsDto.userContactIdMapList[Int(userContact.userContactId)] = userContact;
            }
        }
        
        //Setting list to All Contacts, whether they are cenes or not.
        var friendListDtos = self.inviteFriendsDto.allContacts;
        friendListDtos = GatheringManager().parseFriendsListResults(friendList: self.inviteFriendsDto.allEventMembers);
        
        self.inviteFriendsDto.allContacts = friendListDtos;
        
        //Setting list to cenes contacts, that is, those are cenes members.a
        self.inviteFriendsDto.cenesContacts = GatheringManager().getCenesContacts(friendList: self.inviteFriendsDto.allEventMembers);
        
        //self.inviteFriendsDto.cenesContacts = GatheringManager().getCenesContactsMO(friendList: self.inviteFriendsDto.allEventMembers);

        
        //Let check, if user has cenes contacts then we will show cenes contacts first,
        //Otherwise all contacts.
        if (self.inviteFriendsDto.cenesContacts.count != 0) {
            self.inviteFriendsDto.isAllContactsView = false;
        }
    }
    func getfilterArray(str:String) {
        self.inviteFriendsDto.filteredEventMembers = [];
        
        if (str == "") {
            self.inviteFriendsDto.filteredEventMembers = self.inviteFriendsDto.allEventMembers;
        } else {
            self.inviteFriendsDto.filteredEventMembers = UserContact().filtered(userContacts: self.inviteFriendsDto.allEventMembers, predicate: str);
            
            //self.inviteFriendsDto.filteredEventMembers = EventMember().filteredEventMemberMO(eventMembers: self.inviteFriendsDto.allEventMembers, predicate: str);
        }
        
        self.inviteFriendsDto.userContactIdMapList = [Int: UserContact]();
        for userContact in self.inviteFriendsDto.filteredEventMembers {
            self.inviteFriendsDto.userContactIdMapList[Int(userContact.userContactId)] = userContact;
        }
        
        let friendListDtos = GatheringManager().parseFriendsListResults(friendList: self.inviteFriendsDto.filteredEventMembers);
        self.inviteFriendsDto.allContacts = friendListDtos;
        self.inviteFriendsDto.cenesContacts = GatheringManager().getCenesContacts(friendList: self.inviteFriendsDto.filteredEventMembers);
        
        /*if (inviteFriendsDto.isSearchOn == false) {
            self.inviteFriendsDto.alphabetStrip = [];
            for sectionObj in self.inviteFriendsDto.allContacts {
                self.inviteFriendsDto.alphabetStrip.append(sectionObj.sectionName);
            }
        }*/
        self.friendTableView.reloadData();
    }
    
    @objc func selectFriendsDone(_ sender: UIButton) {
        
        var userContacts: [EventMember] = [];
        for selectedFriend in self.inviteFriendsDto.selectedFriendCollectionViewList {
            
            let eventMember = EventMember();
            if let userContactId = selectedFriend.userContactId {
                eventMember.userContactId = Int32(userContactId);
            }
            if let friendId = selectedFriend.friendId {
                eventMember.userId = Int32(friendId);
            }
            if let user = selectedFriend.user {
                eventMember.user = user;
            }
            if let name = selectedFriend.name {
                eventMember.name = name;
            }
            if let phone = selectedFriend.phone {
                eventMember.phone = phone;
            }
            if let eventMemberId = selectedFriend.eventMemberId {
                eventMember.eventMemberId = eventMemberId;
            }
            if let status = selectedFriend.status {
                eventMember.status = status;
            }
            userContacts.append(eventMember);
        }
        
        //if self.collectionFriendsProtocol != nil {
        self.collectionFriendsDelegate?.collectionFriendsList(selectedFriendHolder: userContacts);
        //}
        
        if (isFirstTime == true) {
            let viewController: CreateGatheringV2ViewController = storyboard?.instantiateViewController(withIdentifier: "CreateGatheringV2ViewController") as! CreateGatheringV2ViewController;
            
            //var eventMembers = [EventMemberMO]();
            for userContact in self.inviteFriendsDto.selectedFriendCollectionViewList {
                //eventMembers.append(eventMem);
                
                //print(userContact.name);
                let eventMember = EventMember();
                if let userContactId = userContact.userContactId {
                    eventMember.userContactId = Int32(userContactId);
                }
                if let friendId = userContact.friendId {
                    eventMember.userId = Int32(friendId);
                }
                if let user = userContact.user {
                    eventMember.user = user;
                }
                if let name = userContact.name {
                    eventMember.name = name;
                }
                if let cenesMember = userContact.cenesMember {
                    eventMember.cenesMember = cenesMember;
                }
                if let eventMemberId = userContact.eventMemberId {
                    eventMember.eventMemberId = eventMemberId;
                }
                if let status = userContact.status {
                    eventMember.status = status;
                }
                if let phone = userContact.phone {
                   eventMember.phone = phone;
                }
                if (viewController.event != nil) {
                    viewController.event.eventMembers.append(eventMember)
                } else {
                    viewController.event = Event();
                    if (viewController.event.eventMembers == nil) {
                        viewController.event.eventMembers = [EventMember]();
                    }
                    viewController.event.eventMembers.append(eventMember);
                }
            }
            viewController.inviteFriendsDto = self.inviteFriendsDto;
            //self.navigationController?.popViewController(animated: true)
            self.navigationController?.pushViewController(viewController, animated: true);
        } else {
            var eventMembers = [EventMember]();
            for userContact in self.inviteFriendsDto.selectedFriendCollectionViewList {
                
                //print(userContact.name);
                
                let eventMember = EventMember();
                if (userContact.userContactId != nil) {
                    eventMember.userContactId = Int32(userContact.userContactId);
                }
                if let friendId = userContact.friendId {
                    eventMember.userId = Int32(friendId);
                }
                eventMember.user = userContact.user;
                eventMember.name = userContact.name;
                eventMember.cenesMember = userContact.cenesMember;
                if let eventMemberId = userContact.eventMemberId {
                    eventMember.eventMemberId = eventMemberId;
                }
                if let status = userContact.status {
                    eventMember.status = status;
                }
                if let phone = userContact.phone {
                   eventMember.phone = phone;
                }
                eventMembers.append(eventMember);
            }
            createGatheringProtocolDelegate.friendsDonePressed(eventMembers: eventMembers);
            
            self.navigationController?.popViewController(animated: false);
        }
        
    }
    
    @objc func selectFriendsCancel(_ sender: UIButton) {
        var _: [EventMember] = [];
        //
        //self.selectedFriendsDelegate?.selectedUserList(userContacts: userContacts);
        self.navigationController?.popViewController(animated: true)
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        inviteFriendsDto.totalNumberOfRows = 3;
        
        if (inviteFriendsDto.selectedFriendCollectionViewList.count == 0) {
            inviteFriendsDto.totalNumberOfRows = inviteFriendsDto.totalNumberOfRows - 1;
        }
        if (self.inviteFriendsDto.cenesContacts.count == 0) {
            inviteFriendsDto.totalNumberOfRows = inviteFriendsDto.totalNumberOfRows - 1;
        }
        return inviteFriendsDto.totalNumberOfRows;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
             if (inviteFriendsDto.totalNumberOfRows == 1) {
                return (self.view.frame.height -  150);
             }
             if (inviteFriendsDto.totalNumberOfRows == 2) {
                if (inviteFriendsDto.selectedFriendCollectionViewList.count != 0) {
                    return inviteFriendsDto.friendCollectionViewCell;
                }
                if (self.inviteFriendsDto.cenesContacts.count != 0) {
                    return inviteFriendsDto.allAndCenesContactsSwitchCell;
                }
             }
             return inviteFriendsDto.friendCollectionViewCell;
        case 1:
            if (inviteFriendsDto.totalNumberOfRows == 2) {
                
                var finalHeight = self.view.frame.height - 150;
                if (inviteFriendsDto.selectedFriendCollectionViewList.count != 0) {
                    finalHeight = finalHeight - inviteFriendsDto.friendCollectionViewCell;
                } else if (inviteFriendsDto.cenesContacts.count != 0) {
                    finalHeight = finalHeight - inviteFriendsDto.allAndCenesContactsSwitchCell;
                }
                return finalHeight;
            }
            return inviteFriendsDto.allAndCenesContactsSwitchCell;
        case 2:
            return (self.view.frame.height - (inviteFriendsDto.friendCollectionViewCell + inviteFriendsDto.allAndCenesContactsSwitchCell + 150));
        default:
            return 100;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //If we have no users selected
        //then we will have 1 row only
        switch indexPath.row {
        case 0:
            if (inviteFriendsDto.totalNumberOfRows == 1) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
                cell.friendViewControllerDelegate = self;
                cell.friendListInnerTable.reloadData()
                
                return cell
            }
            if (inviteFriendsDto.totalNumberOfRows == 2) {
                if (inviteFriendsDto.selectedFriendCollectionViewList.count != 0) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCollectionTableViewCell", for: indexPath) as! FriendCollectionTableViewCell
                    cell.friendsViewControllerDelegate = self;
                    cell.friendshorizontalColView.reloadData();
                    return cell;
                }
                
                if (self.inviteFriendsDto.cenesContacts.count != 0) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AllAndCenesContactsSwitchTableViewCell", for: indexPath) as! AllAndCenesContactsSwitchTableViewCell
                    
                    if (self.inviteFriendsDto.isAllContactsView == true) {
                        cell.switchLabel.text = "Cenes Contacts (\(self.inviteFriendsDto.cenesContacts.count))";
                    } else {
                        cell.switchLabel.text = "All Contacts (\(self.inviteFriendsDto.filteredEventMembers.count))";
                    }
                    return cell
                }
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCollectionTableViewCell", for: indexPath) as! FriendCollectionTableViewCell
            cell.friendsViewControllerDelegate = self;
            cell.friendshorizontalColView.reloadData();
            return cell;
            
        case 1:
            if (inviteFriendsDto.totalNumberOfRows == 2) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
                cell.friendViewControllerDelegate = self;
                cell.friendListInnerTable.reloadData()
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllAndCenesContactsSwitchTableViewCell", for: indexPath) as! AllAndCenesContactsSwitchTableViewCell
            
            if (self.inviteFriendsDto.cenesContacts.count != 0) {
                
                if (self.inviteFriendsDto.isAllContactsView == true) {
                    cell.switchLabel.text = "Cenes Contacts (\(self.inviteFriendsDto.cenesContacts.count))";
                } else {
                    cell.switchLabel.text = "All Contacts (\(self.inviteFriendsDto.filteredEventMembers.count))";
                }
                return cell
            }
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
            cell.friendViewControllerDelegate = self;
            cell.friendListInnerTable.reloadData()
            return cell
            
        default:
            return UITableViewCell();
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.inviteFriendsDto.totalNumberOfRows == 2) {
            if (indexPath.row == 0) {
                //If user clicked on 1 row
                // and first row is all cenes contacts switch
                if (self.inviteFriendsDto.selectedFriendCollectionViewList.count == 0) {
                    if (self.inviteFriendsDto.isAllContactsView == true) {
                        self.inviteFriendsDto.isAllContactsView = false;

                    } else {
                        self.inviteFriendsDto.isAllContactsView = true;
                    }
                    self.friendTableView.reloadData();
                }
            }
        } else if (self.inviteFriendsDto.totalNumberOfRows == 3) {
            if (indexPath.row == 1) {
                    if (self.inviteFriendsDto.isAllContactsView == true) {
                        self.inviteFriendsDto.isAllContactsView = false;
                        
                    } else {
                        self.inviteFriendsDto.isAllContactsView = true;
                    }
                    self.friendTableView.reloadData();
                
            }
        }
    }
    
}
