//
//  InviteFriendViewController.swift
//  Cenes
//
//  Created by Redblink on 11/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MessageUI

protocol SelectUsersDelegate {
    func selectUser(user: CenesUser)
}

protocol SelectedFriendsProtocol {
    func selectedUserList(userContacts: [UserContact])
}

class InviteFriendViewController: UIViewController,NVActivityIndicatorViewable {
    
    var searchText : String!
    var searchOn : Bool! = false
    var imageDownloadsInProgress = [IndexPath : IconDownloader]()
    var checkboxStateHolder: [Int: Bool] = [:];
    var selectedFriendHolder: [Int: UserContact] = [:]
    var userContacts: [UserContact] = [];
    var allUserContacts: [UserContact] = [];
    var userContactIdMapList: [Int: UserContact] = [:];
    
    var delegate: SelectUsersDelegate?
    var selectedFriendsDelegate: SelectedFriendsProtocol?
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tableBottomViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var inviteFriendsTableView: UITableView!
    
    @IBOutlet weak var friendshorizontalColView: UICollectionView!;
    
    var DataArray = [CenesUser]()
    var filteredDataArray = [CenesUser]()
    var gatheringView : CreateGatheringViewController!
    let webservice = WebService()
    
    var boolStatus = false
    var nBarcolor : UIColor!
    
    let tableTopView: Int = 60;
    let tableTopViewAfterSelection: Int = 150
    let collectionViewHeight: Int = 90;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = themeColor;
        
        let imageView = UIImageView();
        imageView.image = #imageLiteral(resourceName: "search_icon");
        self.searchTextField.leftView = imageView;
        self.searchTextField.leftViewMode = UITextFieldViewMode.always
        self.searchTextField.leftViewMode = .always
        

        self.setupNavigationBarItems();
        //self.navigationController?.navigationBar.isHidden = false;
        
        self.friendshorizontalColView.register(UINib(nibName: "FriendsViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "friendCell")
        
        self.inviteFriendsTableView.register(UINib(nibName: "InviteFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "InviteFriendTableViewCell")
        
        self.setSearchBar();
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

    @objc func selectFriendsDone(_ sender: UIButton) {
        
        var userContacts: [UserContact] = [];
        for (key, value) in self.selectedFriendHolder {
            userContacts.append(value);
        }
        
        if self.selectedFriendsDelegate != nil {
            self.selectedFriendsDelegate?.selectedUserList(userContacts: userContacts);
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func selectFriendsCancel(_ sender: UIButton) {
        var userContacts: [UserContact] = [];
        self.selectedFriendsDelegate?.selectedUserList(userContacts: userContacts);
        self.navigationController?.popViewController(animated: true)
    }
    
    func setSearchBar() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = themeColor;
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.backgroundColor = themeColor
        self.navigationController?.navigationBar.tintColor = themeColor;
        
        self.setSearchBar()
        self.getFriendsWithName(nameStartsWith: "")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //self.tableBottomViewConstraint.constant  = 0
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.terminateAllDownloads()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true//boolStatus
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func getFriendsWithName(nameStartsWith:String){
        //Call api for friends
        webservice.cancelAll()
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        UserService().findUserFriendsByUserId(complete: { (returnedDict) in
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                
                var userContact = UserContact();
                
                self.userContacts = userContact.loadUserContactList(userContactArray: returnedDict["data"] as! NSArray);
                self.allUserContacts = userContact.loadUserContactList(userContactArray: returnedDict["data"] as! NSArray);
                for userContact in self.userContacts {
                    self.userContactIdMapList[userContact.userContactId] = userContact;
                }
                
                self.inviteFriendsTableView.reloadData();
            }
        });
    }
    
    
    func reloadFriends(){

        self.inviteFriendsTableView.reloadData()
        self.friendshorizontalColView.reloadData();
    }
    
    func deleteCEll(tag:Int,cell:FriendsViewCell){
        print("\(cell.tag) to be Deleted")
        
        let key = Array(self.selectedFriendHolder.keys)[tag]
        let userContact = self.selectedFriendHolder[key] as! UserContact;
        
        self.selectedFriendHolder.removeValue(forKey: key);
        self.checkboxStateHolder[key] = false;
        
        self.reloadFriends();
    }
}


/*************** EXTENSIONS  ******************/
extension InviteFriendViewController : UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        self.searchText = updatedString

        self.getfilterArray(str: self.searchText.capitalized)

        self.inviteFriendsTableView.reloadData();
        
        return true
    }
    
    func getfilterArray(str:String){
        
        var userContact = UserContact();
        self.userContacts = [];
        
        if (str == "") {
            self.userContacts = self.allUserContacts;
        } else {
            //let predicate : NSPredicate = NSPredicate(format: "name BEGINSWITH [cd] %@" ,str)
            self.userContacts = userContact.filtered(userContacts: self.allUserContacts, predicate: str);
        }
    }
    
}

extension InviteFriendViewController : UITableViewDelegate,UITableViewDataSource, MFMessageComposeViewControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "InviteFriendTableViewCell"
        let cell: InviteFriendTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? InviteFriendTableViewCell)!
        
        let userContact = userContacts[indexPath.row] ;
        cell.nameLabel.text = userContact.name;
        cell.profileImageView.image = #imageLiteral(resourceName: "profile icon")

        if userContact.photo != nil {
            WebService().profilePicFromFacebook(url: userContact.photo, completion: { image in
                cell.profileImageView.image = image
            })
        }else{
            cell.profileImageView.image = #imageLiteral(resourceName: "profile icon")
        }
    
        let userContactId: Int = userContact.userContactId;
        
        let keyExists = self.checkboxStateHolder[userContactId] != nil
        if (keyExists && self.checkboxStateHolder[userContactId] == true) {
            cell.inviteUerCheckbox.isSelected = true;
        } else {
            cell.inviteUerCheckbox.isSelected = false;
        }
        if let btnChk = cell.inviteUerCheckbox {
            btnChk.tag = Int(userContactId);
            btnChk.addTarget(self, action: #selector(checkboxClicked(_ :)), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func checkboxClicked(_ sender: UIButton) {
        
        print("\(sender.tag) isSelected : \(!sender.isSelected)")
        self.checkboxStateHolder[sender.tag] = !sender.isSelected;
        print("\(self.checkboxStateHolder) summary");
        if (!sender.isSelected == true) {
            self.selectedFriendHolder[sender.tag] = self.userContactIdMapList[sender.tag];
        } else {
            self.selectedFriendHolder.removeValue(forKey: sender.tag);
        }
        sender.isSelected = !sender.isSelected
        
        self.inviteFriendsTableView.reloadData();
        self.friendshorizontalColView.reloadData();
        
    }
    
    func startIconDownload(cenesUser: CenesUser, forIndexPath indexPath: IndexPath) {
        guard self.imageDownloadsInProgress[indexPath] == nil else { return }
        
        let iconDownloader = IconDownloader(cenesUser: cenesUser, cenesEventData: nil, notificationData: nil, indexPath: indexPath, photoDiary: nil)
        iconDownloader.delegate = self
        self.imageDownloadsInProgress[indexPath] = iconDownloader
        iconDownloader.startDownload()
    }
    
    func terminateAllDownloads() {
        let allDownloads = Array(self.imageDownloadsInProgress.values)
        allDownloads.forEach { $0.cancelDownload() }
        self.imageDownloadsInProgress.removeAll()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadImagesForOnscreenRows() {
        guard self.DataArray.count != 0 else { return }
        
        let visibleIndexPaths = self.inviteFriendsTableView.indexPathsForVisibleRows ?? [IndexPath]()
        for indexPath in visibleIndexPaths {
            let cenesUser = self.DataArray[indexPath.row]
            if cenesUser.profileImage == nil {
                if cenesUser.photoUrl != nil && cenesUser.photoUrl != ""{
                    self.startIconDownload(cenesUser: cenesUser, forIndexPath: indexPath)
                }
            }
        }
    }
    
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.loadImagesForOnscreenRows()
        }
    }
    
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.loadImagesForOnscreenRows()
    }
    
}

extension InviteFriendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("print : \(self.selectedFriendHolder.count)")
        return self.selectedFriendHolder.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = friendshorizontalColView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! FriendsViewCell;
        
        print("row Number : \(indexPath.row)")
        let key = Array(self.selectedFriendHolder.keys)[indexPath.row]
        let userContact = self.selectedFriendHolder[key] as! UserContact;
        print("Array : \(userContact)")

        var photo = "";
        if (userContact.photo != nil) {
            WebService().profilePicFromFacebook(url: photo, completion: { image in
                cell.profileImage.image = image
            })
        } else{
            cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
        }
        cell.nameLabel.text = userContact.name;
        cell.tag = userContact.userContactId;
        cell.inviteFriendCtrl = self;
        return cell
    }
}
extension InviteFriendViewController: IconDownloaderDelegate {
    func iconDownloaderDidFinishDownloadingImage(_ iconDownloader: IconDownloader, error: NSError?) {
        guard let cell = self.inviteFriendsTableView.cellForRow(at: iconDownloader.indexPath as IndexPath) as? InviteFriendTableViewCell else { return }
        if let error = error {
            print("error downloading Image")
            //fatalError("Error loading thumbnails: \(error.localizedDescription)")
        } else {
            cell.profileImageView?.image = iconDownloader.cenesUser.profileImage
        }
        self.imageDownloadsInProgress.removeValue(forKey: iconDownloader.indexPath as IndexPath)
    }
}
