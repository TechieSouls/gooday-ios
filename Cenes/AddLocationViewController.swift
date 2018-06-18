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
    
    var locations: [LocationModel] = []
    
    var delegate: SelectedLocationDelegate?
    
   
    @IBOutlet weak var tableBottomViewConstraint: NSLayoutConstraint!
    
    
    
    let webservice = WebService()
    
    
    var gatheringView : CreateGatheringViewController!
    
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableBottomViewConstraint.constant = keyboardSize.height
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
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
        
        webservice.getLocation(nameString: nameStartsWith) { [weak self] (jsonDict) in
            self?.stopAnimating()
            
            if jsonDict["Error"] as? Bool == true {
                self?.showAlert(title: "Error", message: (jsonDict["ErrorMsg"] as? String)!)
            }else{
                if let locationResults = jsonDict["data"] as? [[String: Any]] {
                    self?.parseLocations(results: locationResults)
                }
                self?.reloadLocations()
            }
        }
    }
    
    
    func reloadLocations(){
        if self.locations.count > 0 {
            self.locationTableView.isHidden = false
        }else{
            self.locationTableView.isHidden = true
        }
        
        self.locationTableView.reloadData()
    }

    func parseLocations(results: [[String: Any]]) {
        locations = [LocationModel]()
        for location in results {
            let locationModel = LocationModel()
            
//            if let locationPoints = location["geometry"] as? [String: Any] {
//                let latLong = locationPoints["location"] as? [String: Any]
//                locationModel.latitude = latLong!["lat"] as! NSNumber
//                locationModel.longitude = latLong!["lng"] as! NSNumber
//            }
            
            if let formattedAddress = location["structured_formatting"] as? [String: Any] {
                
                let mainText = formattedAddress["main_text"] as? String
                let secondText = formattedAddress["secondary_text"] as? String
                
                locationModel.formattedAddress = secondText
                locationModel.locationName = mainText
            }
            locationModel.placeId = location["place_id"] as? String
            locations.append(locationModel)
        }
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
            self.locations = [LocationModel]()
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
                self.locations = [LocationModel]()
                self.reloadLocations()
            }
        }
        return true
    }
    
}

extension AddLocationViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "LocationCell"
        let cell: LocationCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? LocationCell)!
        
        
        
        let location = locations[indexPath.row]
        
        cell.nameLabel.text = location.locationName
        
        cell.addressLabel.text = location.formattedAddress
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        
        let location = locations[indexPath.row]
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        webservice.getLocationLatLong(id: location.placeId) { [weak self] (jsonDict) in
            self?.stopAnimating()
            
            if jsonDict["Error"] as? Bool == true {
                self?.showAlert(title: "Error", message: (jsonDict["ErrorMsg"] as? String)!)
            }else{
                if let locationResults = jsonDict["data"] as? [String: Any]{
                    
                    if let locationPoints = locationResults["geometry"] as? [String: Any] {
                                        let latLong = locationPoints["location"] as? [String: Any]
                                        location.latitude = latLong!["lat"] as! NSNumber
                                        location.longitude = latLong!["lng"] as! NSNumber
                    }
                    
                    
                    self?.searchBar.resignFirstResponder()
                    
                    self?.delegate?.selectedLocation(location: location,url: nil)
                    self?.navigationController?.popViewController(animated: true)
                }
                
            }
        }
        
        
    }
    
    
    
    
    
    
}


