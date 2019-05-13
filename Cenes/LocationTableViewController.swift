//
//  LocationTableViewController.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/29/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol SelectedLocationDelegate {
    func selectedLocation(location: Location, url : String!)
}

class LocationTableViewController: UITableViewController ,NVActivityIndicatorViewable{

    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    let webservice = WebService()
    var locations: [Location] = []
    
    var delegate: SelectedLocationDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:- Fetch Locations
    func fetchLocationsWithKeyword(searchString: String) {
        startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)

        webservice.getLocation(nameString: searchString) { [weak self] (jsonDict) in
            self?.stopAnimating()
            
            if jsonDict["Error"] as? Bool == true {
                self?.showAlert(title: "Error", message: (jsonDict["ErrorMsg"] as? String)!)
            }else{
                if let locationResults = jsonDict["data"] as? [[String: Any]] {
                    self?.parseLocations(results: locationResults)
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    func parseLocations(results: [[String: Any]]) {
        for location in results {
            let locationModel = Location()
           
            if let formattedAddress = location["structured_formatting"] as? [String: Any] {
                
                let mainText = formattedAddress["main_text"] as? String
                let secondText = formattedAddress["secondary_text"] as? String
                
                locationModel.address = secondText
                locationModel.location = mainText
            }
            locationModel.placeId = location["place_id"] as? String
            locations.append(locationModel)
        }
    }
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        title = "Locations"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)

        // Configure the cell...
        
        let location = locations[indexPath.row]
        
        cell.textLabel?.text = location.location
        cell.detailTextLabel?.text = location.address
        
        cell.imageView?.image = #imageLiteral(resourceName: "LocationIconHome")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let location = locations[indexPath.row]
         self.searchBar.resignFirstResponder()
        startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
        
        /*webservice.getLocationLatLong(id: location.placeId) { [weak self] (jsonDict) in
            self?.stopAnimating()
            
            if jsonDict["Error"] as? Bool == true {
                self?.showAlert(title: "Error", message: (jsonDict["ErrorMsg"] as? String)!)
            }else {
                if let locationResults = jsonDict["data"] as? [String: Any]{
                    
                    if let locationPoints = locationResults["geometry"] as? [String: Any] {
                        let latLong = locationPoints["location"] as? [String: Any]
                        location.latitude = (latLong!["lat"] as! NSNumber).stringValue;
                        location.longitude = (latLong!["lng"] as! NSNumber).stringValue;
                    }
                    
                    var photoURL : String!
                    
                    if let photoArrays = locationResults["photos"] as? NSArray{
                        if photoArrays.count > 0{
                            
                            if let pURL = photoArrays.firstObject as? NSDictionary {
                                if let valueReference = pURL["photo_reference"] as? String{
                                    photoURL = "https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyAg8FTMwwY2LwneObVbjcjj-9DYZkrTR58&maxwidth=400&photoreference=\(valueReference)"
                                }
                            }
                        }
                    }
                    
                    
                    self?.searchBar.resignFirstResponder()
                    self?.delegate?.selectedLocation(location: location,url: photoURL)
                    //self?.dismiss(animated: true, completion: nil)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }*/
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 15 , y: 0, width: UIScreen.main.bounds.size.width - 15, height: 0.5))
        view.backgroundColor = Util.colorWithHexString(hexString: lightGreyColor)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}


//MARK: - Private Search bar instance methods
extension LocationTableViewController : UISearchBarDelegate {
    
     func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.tableView.reloadData()
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        locations = []
        if searchText != "" {
            fetchLocationsWithKeyword(searchString: searchText)
        }else{
            tableView.reloadData()
        }
    }
}
