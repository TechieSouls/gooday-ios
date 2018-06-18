//
//  LocationViewController.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/30/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController ,CLLocationManagerDelegate  {
    var locationManager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var segmentSelected: UISegmentedControl!
    var regionEntryOption = true
    let regionRadius  = 1000.0
    var coord:CLLocationCoordinate2D?
    var regionSet = false
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : commonColor]
        self.navigationController?.navigationBar.tintColor = commonColor
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        map.delegate = self
        locationTextField.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    }
    func mapAnnotation(at address: String, done: @escaping (Bool?)->Void)
    {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
               print("Error", error ?? "Address is not found")
                return
            }
             print ("Address of map\(address)")
                if let placemark = placemarks?.first {
                
                self.coord = placemark.location!.coordinate
                let latDelta:CLLocationDegrees = 0.01
                let longDelta:CLLocationDegrees = 0.01
                let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
                let pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.coord!.latitude, self.coord!.longitude)
                let region:MKCoordinateRegion = MKCoordinateRegionMake(pointLocation, theSpan)
                self.map.setRegion(region, animated: true)

                let annotation = MKPointAnnotation()
                annotation.coordinate = self.coord!
                self.map.addAnnotation(annotation)
                // 5. setup circle
                let circle = MKCircle(center: self.coord!, radius: self.regionRadius)
                self.map.add(circle)
                done(true)

         }
    
        })
       

    }
    
    func addressNotification()
    {
        let region = CLCircularRegion(center:CLLocationCoordinate2D(latitude: (coord?.latitude)!, longitude: (coord?.longitude)!),
                                              radius: self.regionRadius, identifier: "test")
        region.notifyOnEntry = self.regionEntryOption
        region.notifyOnExit = !self.regionEntryOption
        print("Notification will trigger at \(region)")
        let reminder = Reminders()
        reminder.locationNotification(at: region, identifier: "Location", title: "Cenes")
    }

    
    @IBAction func segmetIndexChanged(_ sender: Any) {
        
        switch segmentSelected.selectedSegmentIndex
        {
        case 0:
            regionEntryOption = true
        case 1:
            regionEntryOption = false
        default:
            break; 
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //regionSet is used to check coordinate value of address is set or not
        if(self.regionSet == true)
        {
            addressNotification()
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension LocationViewController:MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = commonColor
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
}
extension LocationViewController:UITextFieldDelegate
{
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            mapAnnotation(at: textField.text!, done: {done in
               self.regionSet = true
            })
            textField.resignFirstResponder()
    
            return true
        }
    
}
