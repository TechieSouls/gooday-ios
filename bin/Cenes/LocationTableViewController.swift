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
    func selectedLocation(location: LocationModel)
}

class LocationTableViewController: UITableViewController ,NVActivityIndicatorViewable{

    let webservice = WebService()
    var locations: [LocationModel] = []
    
    var delegate: SelectedLocationDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    func fetchLocationsWithKeyword(searchString: String) {
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))

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
            let locationModel = LocationModel()
           
            if let locationPoints = location["geometry"] as? [String: Any] {
                let latLong = locationPoints["location"] as? [String: Any]
                locationModel.latitude = latLong!["lat"] as! NSNumber
                locationModel.longitude = latLong!["lng"] as! NSNumber
            }
        
            if let formattedAddress = location["formatted_address"] as? String {
                locationModel.formattedAddress = formattedAddress
            }
            
            if let locationName = location["name"] as? String {
                locationModel.locationName = locationName
            }
            
            locations.append(locationModel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        title = "Locations"
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
        
        cell.textLabel?.text = location.locationName
        cell.detailTextLabel?.text = location.formattedAddress
        
        cell.imageView?.image = #imageLiteral(resourceName: "LocationIconHome")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        self.searchBar.resignFirstResponder()
        
        self.delegate?.selectedLocation(location: location)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 15 , y: 0, width: UIScreen.main.bounds.size.width - 15, height: 0.5))
        view.backgroundColor = Util.colorWithHexString(hexString: lightGreyColor)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Private Search bar instance methods
}

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
