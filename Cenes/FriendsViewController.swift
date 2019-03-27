//
//  FriendsViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 03/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

protocol CollectionFriendsProtocol {
    func collectionFriendsList(selectedFriendHolder: [EventMember])
}

class FriendsViewController: UIViewController {

    @IBOutlet weak var friendTableView: UITableView!;

    @IBOutlet weak var searchTextField: UITextField!
    
    var friendsViewControllerDelegate: FriendsViewController!;
    
    var searchText : String!
    var selectedFriendHolder: [Int: EventMember] = [:]
    var eventMembers: [EventMember] = [];
    var allEventMembers: [EventMember] = [];
    var userContactIdMapList: [Int: EventMember] = [:];
    var collectionFriendsDelegate: CollectionFriendsProtocol?;
    
    var friendTableViewCellsHeight: [String: CGFloat] = [:];
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendTableView.register(UINib(nibName: "FriendInputTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FriendInputTableViewCell")
        friendTableView.register(UINib(nibName: "FriendCollectionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FriendCollectionTableViewCell")
        friendTableView.register(UINib(nibName: "FriendsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FriendsTableViewCell")
        
        friendTableViewCellsHeight["textFieldCell"] = 50;
        friendTableViewCellsHeight["friendCollectionViewCell"] = 0;
            
        self.setupNavigationBarItems();
        
        self.getFriendsWithName(nameStartsWith: "")
            }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setupSearchBar() -> Void {
        let imageView = UIImageView();
        imageView.image = #imageLiteral(resourceName: "search_icon");
        self.searchTextField.leftView = imageView;
        self.searchTextField.leftViewMode = UITextFieldViewMode.always
        self.searchTextField.leftViewMode = .always
    }
    
    func setupNavigationBarItems() {
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage.init(named: "crossIcon.png"), for: UIControlState.normal)
        closeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20);
        closeButton.addTarget(self, action: #selector(selectFriendsCancel(_ :)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton);
        
        let doneButton = UIButton(type: .system);
        doneButton.setTitle("DONE", for: .normal);
        doneButton.setTitleColor(cenesLabelBlue, for: .normal)
        doneButton.addTarget(self, action: #selector(selectFriendsDone(_ :)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton);
    }
    
    func getFriendsWithName(nameStartsWith:String) {
        print("Calling API")
        
        //Call api for friends
        WebService().cancelAll()
        
        //startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
        
        UserService().findUserFriendsByUserId(complete: { (returnedDict) in
            //self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                //self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                
                self.eventMembers = EventMember().loadUserContacts(eventMemberArray: returnedDict["data"] as! NSArray);
                self.allEventMembers = EventMember().loadUserContacts(eventMemberArray: returnedDict["data"] as! NSArray);
                for userContact in self.eventMembers {
                    self.userContactIdMapList[Int(userContact.userContactId)] = userContact;
                }
            }
            
            self.friendTableView.reloadData();

        });
        
    }
    
    func getfilterArray(str:String){
        self.eventMembers = [];
        
        if (str == "") {
            self.eventMembers = self.allEventMembers;
        } else {
            //let predicate : NSPredicate = NSPredicate(format: "name BEGINSWITH [cd] %@" ,str)
            self.eventMembers = EventMember().filtered(eventMembers: self.allEventMembers, predicate: str);
        }
    }
    
    @objc func selectFriendsDone(_ sender: UIButton) {
        
        var userContacts: [EventMember] = [];
        for (_, value) in self.selectedFriendHolder {
            userContacts.append(value);
        }
        
        //if self.collectionFriendsProtocol != nil {
        self.collectionFriendsDelegate?.collectionFriendsList(selectedFriendHolder: userContacts);
        //}
        self.navigationController?.popViewController(animated: true)
        
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
        
        if (friendTableViewCellsHeight["friendCollectionViewCell"] == 0) {
            return 1;
        }
        return 2;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
             if (friendTableViewCellsHeight["friendCollectionViewCell"] == 0) {
                return (self.view.frame.size.height - (friendTableViewCellsHeight["textFieldCell"]! + friendTableViewCellsHeight["friendCollectionViewCell"]!));
             }
            print("Colleciton View Height: \(friendTableViewCellsHeight["friendCollectionViewCell"])")
            return friendTableViewCellsHeight["friendCollectionViewCell"]!;
        case 1:
            return (self.view.frame.size.height - (friendTableViewCellsHeight["textFieldCell"]! + friendTableViewCellsHeight["friendCollectionViewCell"]!));
        default:
            return 100;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            if (friendTableViewCellsHeight["friendCollectionViewCell"] == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
                cell.friendViewControllerDelegate = self;
                cell.friendListInnerTable.reloadData()

                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCollectionTableViewCell", for: indexPath) as! FriendCollectionTableViewCell
            cell.friendsViewControllerDelegate = self;
            cell.friendshorizontalColView.reloadData();
            return cell;
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
            cell.friendViewControllerDelegate = self;
            cell.friendListInnerTable.reloadData()
            return cell
            
        default:
            return UITableViewCell();
        }
    }
}

extension FriendsViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        self.searchText = updatedString
        
        self.getfilterArray(str: self.searchText.capitalized)
        
        self.friendTableView.reloadData();
        
        return true
    }
}
