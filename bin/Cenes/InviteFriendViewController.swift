//
//  InviteFriendViewController.swift
//  Cenes
//
//  Created by Redblink on 11/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol SelectUsersDelegate {
    func selectUser(user: CenesUser)
}

class InviteFriendViewController: UIViewController,NVActivityIndicatorViewable {
    
    var searchBar:UISearchBar!
    var searchText : String?
    var searchOn : Bool! = false
    var imageDownloadsInProgress = [IndexPath : IconDownloader]()
    
    var delegate: SelectUsersDelegate?
    
    @IBOutlet weak var tableBottomViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var inviteFriendsTableView: UITableView!
    var DataArray = [CenesUser]()
    var filteredDataArray = [CenesUser]()
    var gatheringView : CreateGatheringViewController!
    var createReminderView : CreateReminderViewController!
    let webservice = WebService()
    
    var boolStatus = false
    var nBarcolor : UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
         inviteFriendsTableView.register(UINib(nibName: "InviteFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "InviteFriendTableViewCell")
        self.inviteFriendsTableView.isHidden = true
        self.setSearchBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          //  self.searchBar.becomeFirstResponder()
        }
       //
        // Do any additional setup after loading the view.
    }
    
    func setSearchBar() {
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44))
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        
        UIApplication.shared.keyWindow!.addSubview(searchBar)
        searchBar.returnKeyType = .done
       // self.navigationItem.titleView = searchBar
        //UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.gray
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //boolStatus = true
        self.getFriendsWithName(nameStartsWith: "")
       // self.setNeedsStatusBarAppearanceUpdate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableBottomViewConstraint.constant = keyboardSize.height
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.tableBottomViewConstraint.constant  = 0
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 247.0, green: 247.0, blue: 247.0, alpha: 1.0)
        searchBar.removeFromSuperview()
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
        webservice.getFriends(nameString: nameStartsWith, complete: { (returnedDict) in
            self.stopAnimating()
            
            print("Got Friends")
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                let returnedArray = returnedDict["data"] as? NSArray
                
                
                if ((returnedArray?.count) != nil) {
                    print(returnedArray!)
                    
                    for user in returnedArray!{
                        let userDict = user as! NSDictionary
                        let cenesUser = CenesUser()
                        cenesUser.name = userDict.value(forKey: "name") as? String
                        cenesUser.photoUrl = userDict.value(forKey: "photo") as? String
                        cenesUser.userId = "\((userDict.value(forKey: "userId") as? NSNumber)!)"
                        cenesUser.userName = userDict.value(forKey: "username") as? String
                        self.DataArray.append(cenesUser)
                    }
                    
                    self.reloadFriends()
                    self.searchBar.becomeFirstResponder()
                }
            }
            
        })
    }
    
    
    func reloadFriends(){
        if self.DataArray.count > 0 {
            self.inviteFriendsTableView.isHidden = false
        }else{
            self.inviteFriendsTableView.isHidden = true
        }
        
        self.inviteFriendsTableView.reloadData()
    }
}



extension InviteFriendViewController : UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        self.inviteFriendsTableView.reloadData()
        searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchOn = false
        inviteFriendsTableView.reloadData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchOn = false
        searchBar.text = ""
        inviteFriendsTableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchOn = false
        searchBar.text = ""
        inviteFriendsTableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        //print("\(self.searchText)")
        if self.searchText != "" {
            searchOn = true
        }else{
            searchOn = false
        }
        
        self.getfilterArray(str: self.searchText!)
        
        inviteFriendsTableView.reloadData()
        inviteFriendsTableView.setContentOffset(CGPoint.zero, animated:true)
        
    }
}

extension InviteFriendViewController : UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let textAfterUpdate = text.replacingCharacters(in: range, with: string)
            print(textAfterUpdate)
            if textAfterUpdate != "" {
                self.getFriendsWithName(nameStartsWith: textAfterUpdate)
            }else{
                self.DataArray = [CenesUser]()
                self.reloadFriends()
            }
        }
        return true
    }
    
    func getfilterArray(str:String){
        
        filteredDataArray.removeAll()
        
        let predicate : NSPredicate = NSPredicate(format: "SELF BEGINSWITH [cd] %@" ,str)
        
        var arr : [CenesUser]
        arr = DataArray.filter(){$0.name.starts(with: str)}
        //arr = DataArray.filtered(using: predicate) as! [CenesUser]//.filter { predicate.evaluateWithObject($0) }
        
        filteredDataArray = arr
        
        //[filteredContacts removeAllObjects];
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@",searchText];
        //NSArray *tempArray = [contacts filteredArrayUsingPredicate:predicate];
        //filteredContacts = [NSMutableArray arrayWithArray:tempArray];
        print(filteredDataArray)
    }
    
}

extension InviteFriendViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchOn == false{
            
        return self.DataArray.count
        }else{
            return self.filteredDataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "InviteFriendTableViewCell"
        let cell: InviteFriendTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? InviteFriendTableViewCell)!
        
        var user : CenesUser!
        if self.searchOn == false{
             user = DataArray[indexPath.row]
        }else{
             user = filteredDataArray[indexPath.row]
        }
        
        
        
        cell.nameLabel.text = user.name
        
        if let icon = user.profileImage {
            cell.profileImageView.image = icon
        } else {
            if user.photoUrl != nil {
            self.startIconDownload(cenesUser: user, forIndexPath: indexPath)
                cell.profileImageView.image = #imageLiteral(resourceName: "profile icon")
            }else{
                cell.profileImageView.image = #imageLiteral(resourceName: "profile icon")
            }
            
        }
        
        
        return cell
    }
    
    
    func startIconDownload(cenesUser: CenesUser, forIndexPath indexPath: IndexPath) {
        guard self.imageDownloadsInProgress[indexPath] == nil else { return }
        
        let iconDownloader = IconDownloader(cenesUser: cenesUser, cenesEventData: nil, notificationData: nil, indexPath: indexPath)
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        
        var cenesUser : CenesUser!
        
        
        if self.searchOn == false{
            cenesUser = DataArray[indexPath.row]
        }else{
            cenesUser = filteredDataArray[indexPath.row]
        }
        
        
        if self.gatheringView != nil {
        self.gatheringView.FriendArray.append(cenesUser)
        }
        
        if self.createReminderView != nil {
            self.createReminderView.FriendArray.append(cenesUser)
        }
        
        if self.delegate != nil {
            self.delegate?.selectUser(user: cenesUser)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadImagesForOnscreenRows() {
        guard self.DataArray.count != 0 else { return }
        
        let visibleIndexPaths = self.inviteFriendsTableView.indexPathsForVisibleRows ?? [IndexPath]()
        for indexPath in visibleIndexPaths {
            let cenesUser = self.DataArray[indexPath.row]
            if cenesUser.profileImage == nil {
                if cenesUser.photoUrl != nil {
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
