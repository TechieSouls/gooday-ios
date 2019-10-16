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
    func collectionFriendsList(selectedFriendHolder: [EventMemberMO])
}
protocol CreateGatheringProtocol {
    func friendsDonePressed(eventMembers: [EventMemberMO]);
}
class FriendsViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var friendTableView: UITableView!;
    
    var collectionFriendsDelegate: CollectionFriendsProtocol?;
    var loggedInUser: User!;
    var inviteFriendsDto: InviteFriendsDto = InviteFriendsDto();
    var isFirstTime: Bool = true;
    var createGatheringProtocolDelegate: CreateGatheringProtocol!;
    var eventId: Int32!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext? = nil;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Invite Guests";
        self.tabBarController?.tabBar.isHidden = true;

        friendTableView.backgroundColor = themeColor;
        friendTableView.register(UINib(nibName: "FriendCollectionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FriendCollectionTableViewCell")
        friendTableView.register(UINib(nibName: "AllAndCenesContactsSwitchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "AllAndCenesContactsSwitchTableViewCell")
        friendTableView.register(UINib(nibName: "FriendsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FriendsTableViewCell")
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        context = self.appDelegate.persistentContainer.viewContext
        self.setupNavigationBarItems();
        
        if (eventId == nil && inviteFriendsDto.selectedFriendCollectionViewList.count == 0) {
            var userExistsInList = false;
            for eventMem in inviteFriendsDto.selectedFriendCollectionViewList {
                if (eventMem.user != nil && (eventMem.user?.userId == self.loggedInUser.userId)) {
                    userExistsInList = true;
                    break;
                }
            }
            if (userExistsInList == false) {

                let loggedInUserContact = CenesUserContactModel().loggedInUserAsEventMember(context: context!, user: loggedInUser);
                print(loggedInUserContact.description);
                inviteFriendsDto.selectedFriendCollectionViewList.append(loggedInUserContact);
            }
        }
        
        if (isFirstTime == true || eventId != nil) {
            self.getFriendsWithName(nameStartsWith: "")
        } else {
            self.friendTableView.reloadData()
            isFirstTime = false
        }
        
        PhonebookService.getPermissionForContacts();
        DispatchQueue.global(qos: .background).async {
            self.syncDeviceContacts();
        }
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
        
        
        let searchBarController = UISearchController(searchResultsController: nil);
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.placeholder = "Search Contacts"
        searchBarController.searchResultsUpdater = self
        searchBarController.obscuresBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchBarController
        } else {
            // Fallback on earlier versions
        };
        definesPresentationContext = true

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
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text!;
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
        
        //CenesUserContactModel().deleteAllCenesUserContactMO(context: context!);
        self.inviteFriendsDto.allEventMembers = CenesUserContactModel().fetchAllUserContacts(context: context!, user: loggedInUser);
        self.processFriendsList();
        self.friendTableView.reloadData();

        if (Connectivity.isConnectedToInternet == true) {
            let queryStr = "userId=\(String(self.loggedInUser.userId))"
            UserService().findUserFriendsByUserId(queryStr: queryStr, token: self.loggedInUser.token, complete: { (returnedDict) in
                if returnedDict.value(forKey: "success") as? Bool == false {
                    self.showAlert(title: "Error", message: (returnedDict["message"] as? String)!)
                }else{
                    
                    self.inviteFriendsDto.allEventMembers = EventMember().loadUserContactsMO(eventMemberArray: returnedDict["data"] as! NSArray, context: self.context!);
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
            if (userContact.userContactId != 0) {
                self.inviteFriendsDto.userContactIdMapList[Int(userContact.userContactId)] = userContact;
            }
        }
        
        //Setting list to All Contacts, whether they are cenes or not.
        var friendListDtos = self.inviteFriendsDto.allContacts;
        friendListDtos = GatheringManager().parseFriendsListResults(friendList: self.inviteFriendsDto.allEventMembers);
        
        self.inviteFriendsDto.allContacts = friendListDtos;
        
        //Setting list to cenes contacts, that is, those are cenes members.a
        //self.inviteFriendsDto.cenesContacts = GatheringManager().getCenesContacts(friendList: self.inviteFriendsDto.allEventMembers);
        
        self.inviteFriendsDto.cenesContacts = GatheringManager().getCenesContactsMO(friendList: self.inviteFriendsDto.allEventMembers);

        
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
            //self.inviteFriendsDto.filteredEventMembers = EventMember().filtered(eventMembers: self.inviteFriendsDto.allEventMembers, predicate: str);
            
            self.inviteFriendsDto.filteredEventMembers = EventMember().filteredEventMemberMO(eventMembers: self.inviteFriendsDto.allEventMembers, predicate: str);
        }
        
        self.inviteFriendsDto.userContactIdMapList = [Int: CenesUserContactMO]();
        for userContact in self.inviteFriendsDto.filteredEventMembers {
            self.inviteFriendsDto.userContactIdMapList[Int(userContact.userContactId)] = userContact;
        }
        
        let friendListDtos = GatheringManager().parseFriendsListResults(friendList: self.inviteFriendsDto.filteredEventMembers);
        self.inviteFriendsDto.allContacts = friendListDtos;
        self.inviteFriendsDto.cenesContacts = GatheringManager().getCenesContactsMO(friendList: self.inviteFriendsDto.filteredEventMembers);
        
        /*if (inviteFriendsDto.isSearchOn == false) {
            self.inviteFriendsDto.alphabetStrip = [];
            for sectionObj in self.inviteFriendsDto.allContacts {
                self.inviteFriendsDto.alphabetStrip.append(sectionObj.sectionName);
            }
        }*/
        self.friendTableView.reloadData();
    }
    
    @objc func selectFriendsDone(_ sender: UIButton) {
        
        var userContacts: [EventMemberMO] = [];
        for selectedFriend in self.inviteFriendsDto.selectedFriendCollectionViewList {
            
            print(selectedFriend.description);
            
            let eventMemberMO = EventMemberMO(context: context!);
            eventMemberMO.userContactId = selectedFriend.userContactId;
            eventMemberMO.userId = selectedFriend.friendId;
            eventMemberMO.user = selectedFriend.user;
            eventMemberMO.name = selectedFriend.name;
            userContacts.append(eventMemberMO);
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
                let eventMemberMO = EventMemberMO(context: context!);
                eventMemberMO.userContactId = userContact.userContactId;
                eventMemberMO.userId = userContact.friendId;
                eventMemberMO.user = userContact.user;
                eventMemberMO.name = userContact.name;
                eventMemberMO.cenesMember = userContact.cenesMember;

                if (viewController.event != nil) {
                    viewController.event.addToEventMembers(eventMemberMO)
                } else {
                    viewController.event = EventMO(context: context!);
                    viewController.event.addToEventMembers(eventMemberMO);
                }
            }
            viewController.inviteFriendsDto = self.inviteFriendsDto;
            //self.navigationController?.popViewController(animated: true)
            self.navigationController?.pushViewController(viewController, animated: true);
        } else {
            var eventMembers = [EventMemberMO]();
            for userContact in self.inviteFriendsDto.selectedFriendCollectionViewList {
                
                //print(userContact.name);
                
                let eventMemberMO = EventMemberMO(context: context!);
                eventMemberMO.userContactId = userContact.userContactId;
                eventMemberMO.userId = userContact.friendId;
                eventMemberMO.user = userContact.user;
                eventMemberMO.name = userContact.name;
                eventMemberMO.cenesMember = userContact.cenesMember;

                eventMembers.append(eventMemberMO);
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
