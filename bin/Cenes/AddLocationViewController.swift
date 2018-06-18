//
//  AddLocationViewController.swift
//  Cenes
//
//  Created by Redblink on 12/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddLocationViewController: UIViewController ,NVActivityIndicatorViewable{
    
    
    @IBOutlet weak var locationTableView: UITableView!
    
    
    var searchBar:UISearchBar!
    var searchText : String?
    
    
    var DataArray = NSArray()
    @IBOutlet weak var tableBottomViewConstraint: NSLayoutConstraint!
    
    
    
    let webservice = WebService()
    
    
    var gatheringView : CreateGatheringViewController!
    var createReminderView : CreateReminderViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationTableView.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
        self.setSearchBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              self.searchBar.becomeFirstResponder()
        }
        
        
        // Do any additional setup after loading the view.
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    
    
    func getLocationWithName(nameStartsWith:String){
        //Call api for friends
        webservice.cancelAll()
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
//        webservice.getLocation(nameString: nameStartsWith, complete: { (returnedDict) in
//            let hud = MBProgressHUD(for: self.view.window!)
//            hud?.hide(animated: true)
//            print("Got Locations")
//            if returnedDict.value(forKey: "Error") as? Bool == true {
//
//                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
//
//            }else{
//                let returnedArray = returnedDict["data"] as? NSArray
//
//
//                if ((returnedArray?.count) != nil) {
//                    print(returnedArray)
//                    self.DataArray = returnedArray!
//                    self.reloadLocations()
//                }
//            }
//
//        })
    }
    
    
    func reloadLocations(){
        if self.DataArray.count > 0 {
            self.locationTableView.isHidden = false
        }else{
            self.locationTableView.isHidden = true
        }
        
        self.locationTableView.reloadData()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddLocationViewController : UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        self.locationTableView.reloadData()
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
       
        locationTableView.reloadData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        locationTableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        locationTableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        if searchText != "" {
            self.getLocationWithName(nameStartsWith: searchText)
        }else{
            self.DataArray = NSArray()
            self.reloadLocations()
        }
        
    }
}





extension AddLocationViewController : UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let textAfterUpdate = text.replacingCharacters(in: range, with: string)
            print(textAfterUpdate)
            if textAfterUpdate != "" {
                self.getLocationWithName(nameStartsWith: textAfterUpdate)
            }else{
                self.DataArray = NSArray()
                self.reloadLocations()
            }
        }
        return true
    }
    
}

extension AddLocationViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "LocationCell"
        let cell: LocationCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? LocationCell)!
        
        
        
        let dict = DataArray[indexPath.row] as! NSDictionary
        
        cell.nameLabel.text = dict.value(forKey:"name") as? String
        
        cell.addressLabel.text = dict.value(forKey:"formatted_address") as? String
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        
        let dict = DataArray[indexPath.row] as! NSDictionary
        if self.gatheringView != nil {
        self.gatheringView.locationName = (dict.value(forKey:"name") as? String)!
        }
        if self.createReminderView != nil {
            self.createReminderView.locationName = (dict.value(forKey:"name") as? String)!
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}


