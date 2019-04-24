//
//  CreateGatheringLocationViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 22/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import CoreLocation

protocol SelectedLocationProtocol {
    func locationSelected(location: Location);
}

class CreateGatheringLocationViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var locationTableView: UITableView!
    
    var selectedLocationProtocolDelegate: SelectedLocationProtocol!;
    
    var locationManager: CLLocationManager!
    var userLocation = CLLocation();
    var currentLatitude: CLLocationDegrees = 0.0;
    var currentLongitude: CLLocationDegrees = 0.0;
    
    var locationDtos = [LocationDto]();
    var nearByLocations = [Location]();
    var worldWideLocations = [Location]();

    override func viewDidLoad() {
        super.viewDidLoad()

        locationTableView.register(UINib(nibName: "LocationItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LocationItemTableViewCell")
        
        locationTableView.register(UINib(nibName: "LocationItemsHeaderViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LocationItemsHeaderViewCell")
        
        // Do any additional setup after loading the view.
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            //locationManager.startUpdatingLocation()
            
            print("Latitude", locationManager.location?.coordinate.latitude, "Longitude", locationManager.location?.coordinate.longitude)
            
            if (locationManager.location?.coordinate.latitude != nil) {
                currentLatitude = (locationManager.location?.coordinate.latitude)!;
                currentLongitude = (locationManager.location?.coordinate.longitude)!;
            }
        }
        
        
        setupNaigationBar();
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last! as CLLocation
        print(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //print("Latitude", manager.location?.coordinate.latitude, "Longitude", manager.location?.coordinate.longitude)
        
        print("Status", status)
        
        switch status {
        case .restricted, .denied:
            //disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse:
            manager.startUpdatingLocation();
            currentLatitude = (manager.location?.coordinate.latitude)!;
            currentLongitude = (manager.location?.coordinate.longitude)!;
            break
            
        case .authorizedAlways:
            manager.startUpdatingLocation();
            currentLatitude = (manager.location?.coordinate.latitude)!;
            currentLongitude = (manager.location?.coordinate.longitude)!;
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error : ",error.localizedDescription)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupNaigationBar() -> Void {
        
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self;
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        
        
        
        /*let backButton = UIButton();
        backButton.setImage(UIImage.init(named: "abondan_event_icon"), for: .normal);
        backButton.addTarget(self, action:#selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        
        let backButtonBarButton = UIBarButtonItem.init(customView: backButton)
        
        navigationItem.leftBarButtonItem = backButtonBarButton;*/

    }

    func loadNearbyLocations(searchText: String) -> Void {
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAg8FTMwwY2LwneObVbjcjj-9DYZkrTR58&location=\(currentLatitude),\(currentLongitude)&radius=50000&name=\(searchText)";
        
        print(url);
        HttpService().getMethod(url: url, token: "", complete: {(response) in
            
            self.locationDtos = [LocationDto]();

            if let statusStr = response.value(forKey: "status") as? String {
                if (statusStr == "OK" || statusStr == "ZERO_RESULTS") {
                    
                    let locationsNSArray = response.value(forKey: "results") as! NSArray;
                    self.nearByLocations = LocationManager().parseNearByLocationResults(nearByResults: locationsNSArray);
                    self.locationTableView.reloadData();
                    
                    var count = 0;
                    var finalwwlocList = [Location]();
                    for wwloc in self.worldWideLocations {
                        finalwwlocList.append(wwloc);
                        if (count == 9) {
                            break;
                        }
                        count = count + 1;
                    }
                    if (finalwwlocList.count > 0) {
                        var locationDto = LocationDto();
                        locationDto.sectionName = "All";
                        locationDto.sectionObjects = finalwwlocList;
                        self.locationDtos.append(locationDto);
                    }
                    
                    for nbloc in self.nearByLocations {
                        nbloc.kilometers = "\(String(LocationManager().getDistanceInKilometres(currentLatitude: self.currentLatitude, currentLongitude: self.currentLongitude, destLatitude: nbloc.latitudeDouble, destLongitude: nbloc.longitudeDouble)))";
                        
                    }
                    
                    
                    var finalnbList = [Location]();
                    for nbloc in self.nearByLocations {
                        
                        finalnbList.append(nbloc);
                        if (count == 9) {
                            break;
                        }
                        count = count + 1;
                    }
                    
                    if (finalnbList.count > 1) {
                        
                        for i in 0..<(finalnbList.count - 1) {
                            
                            for i in 0..<(finalnbList.count-1) {
                                
                                let currentLoc = finalnbList[i];
                                let nextLoc = finalnbList[i+1];
                                
                                let currentKil: Int = Int(currentLoc.kilometers)!;
                                let nextKil: Int = Int(nextLoc.kilometers)!;
                                
                                if (currentKil > nextKil) {
                                    finalnbList[i] = nextLoc;
                                    finalnbList[i+1] = currentLoc;
                                }
                            }
                        }
                    }
                    
                    
                    if (finalnbList.count > 0) {
                        var locationDto = LocationDto();
                        locationDto.sectionName = "Suggested Locations";
                        locationDto.sectionObjects = finalnbList;
                        self.locationDtos.append(locationDto);
                    }
                    self.locationTableView.reloadData();
                }
            }
        });
    }
    
    func loadWorldWideLocations(searchText: String) -> Void {
        let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyAg8FTMwwY2LwneObVbjcjj-9DYZkrTR58&input=\(searchText)";
        
        print(url);
        HttpService().getMethod(url: url, token: "", complete: {(response) in
            
            if let statusStr = response.value(forKey: "status") as? String {
                if (statusStr == "OK" || statusStr == "ZERO_RESULTS") {
                    let locationsNSArray = response.value(forKey: "predictions") as! NSArray;
                    self.worldWideLocations = LocationManager().parseWorldWideLocationResults(worldwideResults: locationsNSArray);
                }
            }
            self.loadNearbyLocations(searchText: searchText);

        });
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText);
        locationDtos = [LocationDto]();
        if (searchText == "") {
            self.locationTableView.reloadData();
        } else {
            loadWorldWideLocations(searchText: searchText);
        }
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
