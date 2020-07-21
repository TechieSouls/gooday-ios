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
    
    @IBOutlet weak var customLocationButton: UIButton!
    
    @IBOutlet weak var previousSearchLabel: UILabel!
    
    var selectedLocationProtocolDelegate: SelectedLocationProtocol!;
    
    var locationManager: CLLocationManager!
    var userLocation = CLLocation();
    var currentLatitude: CLLocationDegrees = 0.0;
    var currentLongitude: CLLocationDegrees = 0.0;
    
    var locationDtos = [LocationDto]();
    var nearByLocations = [Location]();
    var worldWideLocations = [Location]();
    var previousLoactions = [Location]();
    
    var typedText: String = "";

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = themeColor;
        locationTableView.backgroundColor = themeColor;
        
        customLocationButton.frame = CGRect(x: customLocationButton.frame.origin.x, y: view.frame.height - 60, width: 220, height: 33);

        customLocationButton.layer.cornerRadius = 15
        customLocationButton.backgroundColor = UIColor.white
        customLocationButton.layer.borderWidth = 1.5
        customLocationButton.layer.borderColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1).cgColor
        customLocationButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        customLocationButton.layer.shadowColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.5).cgColor
        customLocationButton.layer.shadowOpacity = 1
        customLocationButton.layer.shadowRadius = 2
        //customLocationButton.addSubview(layer)
        
        locationTableView.isHidden = true;
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
        self.loadPreviousLocations();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillAppear(notification: NSNotification){
        // Do something here
        print("Opened");
        var keyboardHeight: CGFloat = 210;
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = CGFloat(keyboardSize.height) + 70
            print(keyboardHeight)
        }
        
        customLocationButton.frame = CGRect.init(x: customLocationButton.frame.origin.x, y: (self.view.frame.height - keyboardHeight), width: customLocationButton.frame.width, height: customLocationButton.frame.height);
        
        //customLocationButton.titleLabel?.text = "Create Custom Location [CL]"
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification){
        // Do something here
        print("Closed");
        print(customLocationButton.frame.origin.y)
        customLocationButton.frame = CGRect(x: customLocationButton.frame.origin.x, y: (self.view.frame.height - 70), width: customLocationButton.frame.width, height: customLocationButton.frame.height);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
            if (manager.location?.coordinate.latitude != nil) {
                currentLatitude = (manager.location?.coordinate.latitude)!;
                currentLongitude = (manager.location?.coordinate.longitude)!;
            }
            break
            
        case .authorizedAlways:
            manager.startUpdatingLocation();
            if (manager.location?.coordinate.latitude != nil) {
                currentLatitude = (manager.location?.coordinate.latitude)!;
                currentLongitude = (manager.location?.coordinate.longitude)!;
            }
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
        searchBar.placeholder = "Search Location"
        searchBar.layer.borderWidth = 0
        searchBar.returnKeyType = .done
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        
        
        
        let backButton = UIButton();
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
        backButton.setImage(UIImage.init(named: "abondan_event_icon"), for: .normal);
        backButton.addTarget(self, action: #selector(backButtonPressed), for: UIControl.Event.touchUpInside)
        
        let backButtonBarButton = UIBarButtonItem.init(customView: backButton)
        
        navigationItem.leftBarButtonItem = backButtonBarButton;
        

    }

    
    //This will locate the near by locations
    func loadNearbyLocations(searchText: String) -> Void {
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAg8FTMwwY2LwneObVbjcjj-9DYZkrTR58&location=\(currentLatitude),\(currentLongitude)&radius=5000&name=\(searchText.replacingOccurrences(of: " ", with: "+"))";
        
        print(url);
        HttpService().getMethod(url: url, token: "", complete: {(response) in

            self.previousSearchLabel.isHidden = true;

            self.locationDtos = [LocationDto]();
            self.nearByLocations = [Location]();
            if let statusStr = response.value(forKey: "status") as? String {
                if (statusStr == "OK" || statusStr == "ZERO_RESULTS") {
                    
                    let locationsNSArray = response.value(forKey: "results") as! NSArray;
                    self.nearByLocations = LocationManager().parseNearByLocationResults(nearByResults: locationsNSArray);
                    self.locationTableView.reloadData();
                    
                    var count = 0;
                    /*var finalwwlocList = [Location]();
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
                    }*/
                    
                    for nbloc in self.nearByLocations {
                        nbloc.kilometers = "\(String(LocationManager().getDistanceInKilometres(currentLatitude: self.currentLatitude, currentLongitude: self.currentLongitude, destLatitude: nbloc.latitudeDouble, destLongitude: nbloc.longitudeDouble)))";
                        
                    }
                    
                    
                    var finalnbList = [Location]();
                    for nbloc in self.nearByLocations {
                        
                        finalnbList.append(nbloc);
                        /*if (count == 9) {
                            break;
                        }
                        count = count + 1;*/
                    }
                    
                    //Sorting by Near Distance.
                    /*if (finalnbList.count > 0) {
                        
                        for i in 0..<(finalnbList.count - 1) {
                            
                            for i in 0..<(finalnbList.count-1) {
                                
                                let currentLoc = finalnbList[i];
                                let nextLoc = finalnbList[i+1];
                                
                                let currentKil: Double = Double(currentLoc.kilometers!) as! Double;
                                let nextKil: Double = Double(nextLoc.kilometers!) as! Double;
                                
                                if (currentKil > nextKil) {
                                    finalnbList[i] = nextLoc;
                                    finalnbList[i+1] = currentLoc;
                                }
                            }
                        }
                    }*/
                    
                    
                    if (finalnbList.count > 0) {
                        let locationDto = LocationDto();
                        locationDto.sectionName = "Suggested Locations";
                        locationDto.sectionObjects = finalnbList;
                        self.locationDtos.append(locationDto);
                        self.nearByLocations = finalnbList;
                        
                        let locs = self.nearByLocations.sorted(by: { CGFloat(($0.kilometers as NSString).floatValue) < CGFloat(($1.kilometers as NSString).floatValue) });
                        self.nearByLocations = locs;
                        self.locationTableView.reloadData();
                    } else {
                        self.loadWorldWideLocations(searchText: searchText);
                    }
                } else {
                    self.loadWorldWideLocations(searchText: searchText);
                }
            }
        });
    }
    
    func loadWorldWideLocations(searchText: String) -> Void {
        let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyAg8FTMwwY2LwneObVbjcjj-9DYZkrTR58&input=\(searchText.replacingOccurrences(of: " ", with: "+"))";
        
        print(url);
        HttpService().getMethod(url: url, token: "", complete: {(response) in
            
            if let statusStr = response.value(forKey: "status") as? String {
                if (statusStr == "OK" || statusStr == "ZERO_RESULTS") {
                    let locationsNSArray = response.value(forKey: "predictions") as! NSArray;
                    self.nearByLocations = LocationManager().parseWorldWideLocationResults(worldwideResults: locationsNSArray);
                    
                    
                    if (self.nearByLocations.count > 0) {
                        var locationDto = LocationDto();
                        locationDto.sectionName = "Suggested Locations";
                        locationDto.sectionObjects = self.nearByLocations;
                        self.locationDtos.append(locationDto);
                        
                        self.locationTableView.reloadData();
                    }
                }
            }
            //self.loadNearbyLocations(searchText: searchText);
            self.locationTableView.reloadData();

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
        typedText = searchText;
        locationDtos = [LocationDto]();
        if (searchText == "") {
            
            self.previousSearchLabel.isHidden = true;

            if (self.previousLoactions.count > 0) {
                
                self.previousSearchLabel.isHidden = false;

                self.nearByLocations = self.previousLoactions;
                locationTableView.isHidden = false;
                self.locationTableView.reloadData();
            } else {
                locationTableView.isHidden = true
            }
            customLocationButton.isHidden = true;
        } else {
            
            locationTableView.isHidden = false
            customLocationButton.isHidden = false;
            //loadWorldWideLocations(searchText: searchText);
            loadNearbyLocations(searchText: searchText);
        }
    }
    
    func loadPreviousLocations() -> Void {
        
        self.previousSearchLabel.isHidden = true;
        var loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        let queryStr = "userId=\(String(loggedInUser.userId))";
        LocationService().findPreviousLocations(queryStr: queryStr, token: loggedInUser.token, complete: {(response) in
            
            print(response);
            let success = response.value(forKey: "success") as! Bool
            if (success == true) {
                self.previousLoactions = [Location]();
                let prevLocArray = response.value(forKey: "data") as! NSArray;
                if (prevLocArray.count > 0) {
                    
                    self.previousSearchLabel.isHidden = false;

                    for prevLocDict in prevLocArray {
                        
                        let prevLoc = Location().loadLocationDataFromPreviousLocations(prevLocDict: prevLocDict as! NSDictionary);
                        
                        if (prevLoc.placeId == nil || prevLoc.placeId == "") {
                            continue;
                        }
                        let destinationLat = Double(prevLoc.latitude) as! CLLocationDegrees
                        let destinationLong = Double(prevLoc.longitude) as! CLLocationDegrees

                        let coordinateUser = CLLocation(latitude: self.currentLatitude, longitude: self.currentLongitude);
                        let coordinateDestination = CLLocation(latitude: destinationLat, longitude: destinationLong);
                        let distanceInMeters = coordinateUser.distance(from: coordinateDestination);
                        print("distanceInMeters : ", distanceInMeters/1000, String(format: "%.1f", distanceInMeters/1000))
                        
                        let distInKms = String(LocationManager().getDistanceInKilometres(currentLatitude: self.currentLatitude, currentLongitude: self.currentLongitude, destLatitude: prevLoc.latitudeDouble, destLongitude: prevLoc.longitudeDouble));
                        
                            prevLoc.kilometers = "\(distInKms)";
                            //prevLoc.kilometers = "\(String(LocationManager().getDistanceInKilometres(currentLatitude: self.currentLatitude, currentLongitude: self.currentLongitude, destLatitude: prevLoc.latitudeDouble, destLongitude: prevLoc.longitudeDouble)))";
                        self.previousLoactions.append(prevLoc);
                    }
                    let locs = self.previousLoactions.sorted(by: { CGFloat(($0.kilometers as NSString).floatValue) < CGFloat(($1.kilometers as NSString).floatValue) });
                    self.previousLoactions = locs;


                    self.nearByLocations = self.previousLoactions;
                    self.locationTableView.isHidden = false;
                    self.locationTableView.reloadData();
                }
            }
        });
    }
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func customLocationPressed(_ sender: Any) {
        
        let nearByLocObje = Location();
        nearByLocObje.location = typedText;
        self.selectedLocationProtocolDelegate.locationSelected(location: nearByLocObje);
        self.navigationController?.popViewController(animated: true);
        
    }
    
}
