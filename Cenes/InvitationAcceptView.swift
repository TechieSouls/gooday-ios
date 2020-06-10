//
//  InvitationAcceptView.swift
//  Cenes
//
//  Created by Redblink on 31/10/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class InvitationAcceptView: UIViewController,NVActivityIndicatorViewable {
    
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    var invitationData : CenesCalendarData!
    
    var gatheringView : GatheringViewController!
    
    var locationModel : LocationModel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var startEndTimeLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var defaultImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            topItem.backBarButtonItem?.tintColor = UIColor.white
        }
        
        
        self.titleLabel.text = self.invitationData.title
        self.locationName.text = self.invitationData.subTitle
        self.descriptionLabel.text = self.invitationData.eventDescription
        
        
        let startTimeinterval : TimeInterval = Double(truncating: self.invitationData.startTimeMillisecond) / 1000
        let startDate = NSDate(timeIntervalSince1970:startTimeinterval)
        
        let endTimeinterval : TimeInterval = Double(truncating: self.invitationData.endTimeMillisecond) / 1000
        let endDate = NSDate(timeIntervalSince1970:endTimeinterval)
        
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE, MMMM dd"
        let dateString = dateformatter.string(from: startDate as Date)
        
        self.startDateLabel.text = dateString
        
        var timeStr = ""
        
        dateformatter.dateFormat = "h:mm a"
        
        timeStr += dateformatter.string(from: startDate as Date)
        timeStr += " to "
        timeStr += dateformatter.string(from: endDate as Date)
        
        
        self.startEndTimeLabel.text = timeStr
        
        if self.locationModel != nil && self.locationModel.latitude != nil{
            self.mapView.isHidden = false
            self.defaultImage.isHidden = true
            let placeMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.locationModel.latitude as! CLLocationDegrees, longitude: self.locationModel.longitude as! CLLocationDegrees))
            
            var annotation = MKPointAnnotation()
            annotation.coordinate =  CLLocationCoordinate2D(latitude: self.locationModel.latitude as! CLLocationDegrees, longitude: self.locationModel.longitude as! CLLocationDegrees)
                annotation.title = self.locationName.text
                
            self.mapView.addAnnotation(annotation)
            
            
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                var region = MKCoordinateRegion()
                
                let viewRegion = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: self.locationModel.latitude as! CLLocationDegrees, longitude: self.locationModel.longitude as! CLLocationDegrees), latitudinalMeters: 300, longitudinalMeters: 300)
                
                let adjsutedRegion = self.mapView.regionThatFits(viewRegion)
                self.mapView.setRegion(adjsutedRegion, animated: true)
                
                

            }
            
        }else{
            self.mapView.isHidden = true
            self.defaultImage.isHidden = false
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
    @IBAction func acceptInvitation(_ sender: UIButton) {
        self.startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
        
        // Accept Invite
        
        WebService().AcceptDeclineInvitation(eventMemberId: self.invitationData.eventMemberId, status: "confirmed") { (returnedDict) in
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                
                self.gatheringView.confirmedButtonPressed(UIButton())
                self.gatheringView.setUpNavBar()
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        
        
        
        
    }
    
    @IBAction func declineInvitation(_ sender: UIButton) {
        self.startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
        
        // Decline Invite
        WebService().AcceptDeclineInvitation(eventMemberId: self.invitationData.eventMemberId, status: "declined") { (returnedDict) in
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                self.gatheringView.confirmedButtonPressed(UIButton())
                self.gatheringView.setUpNavBar()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
