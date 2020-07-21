//
//  InvitationCardTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 24/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import Mixpanel
import GoogleMaps

class InvitationCardTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var evntTitle: UILabel!
    
    @IBOutlet weak var eventTime: UILabel!
    
    @IBOutlet weak var guestListView: UIView!
    
    @IBOutlet weak var locationView: UIView!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var chatProfilePic: UIImageView!
    @IBOutlet weak var descriptionUILabelHolder: UIView!
    @IBOutlet weak var descriptionUILabel: UILabel!
    
    @IBOutlet weak var eventPicture: UIImageView!
    
    @IBOutlet weak var descViewMessageIcon: UIImageView!
    
    @IBOutlet weak var locationViewLocationIcon: UIImageView!
    
    @IBOutlet weak var topHeaderView: UIView!
    
    var gatheringInvitaionViewControllerDelegate: GatheringInvitationViewController!
    var locationAlertView: LocationAlertView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePic.roundedView();
        guestListView.roundedView();
        locationView.roundedView();
        descriptionView.roundedView();
        shareView.roundedView();
        descriptionUILabelHolder.layer.cornerRadius = 10;
        chatProfilePic.roundedView();
        chatProfilePic.layer.borderWidth = 2;
        chatProfilePic.layer.borderColor = UIColor.white.cgColor;
        
        let layer = UIView(frame: CGRect(x: 0, y: 0, width: self.topHeaderView.frame.width, height: self.topHeaderView.frame.height))
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.topHeaderView.frame.height)
        gradient.colors = [
            UIColor.white.cgColor,
            UIColor.black.cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.06)
        layer.layer.addSublayer(gradient)
        
        self.topHeaderView.addSubview(layer)
        
        let guestListViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("guestListViewPressed"));
        guestListView.addGestureRecognizer(guestListViewTapGesture);
        
        let locationViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("locationViewPressed"));
        locationView.addGestureRecognizer(locationViewTapGesture);
        
        let descriptionViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("descriptionViewPressed"));
        descriptionView.addGestureRecognizer(descriptionViewTapGesture);
        
        let shareViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("shareViewPressed"));
        shareView.addGestureRecognizer(shareViewTapGesture);
        
        let imageViewTapGesture = UITapGestureRecognizer(target: self, action: Selector("eventImageTapped"));
        eventPicture.addGestureRecognizer(imageViewTapGesture);
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func locationViewPressed() {
        
        self.processAlreadyCheckedBubble(selectedBubble: "location");
        
        gatheringInvitaionViewControllerDelegate.trackCheckdeBubble = "location";
        self.locationViewLocationIcon.image = UIImage.init(named: "location_on_icon")
        self.locationView.backgroundColor = UIColor.white;
        
        if (gatheringInvitaionViewControllerDelegate.event.latitude != nil && gatheringInvitaionViewControllerDelegate.event.latitude != "") {
            
            if (gatheringInvitaionViewControllerDelegate.locationPhotos.count > 0) {
                
                for locAlertView in gatheringInvitaionViewControllerDelegate.view.subviews {
                    if (locAlertView is LocationAlertView) {
                        locAlertView.removeFromSuperview();
                    }
                }
                locationAlertView = LocationAlertView.instanceFromNib() as! LocationAlertView;
                locationAlertView.frame = gatheringInvitaionViewControllerDelegate.view.frame;
                locationAlertView.lblLocation.text = gatheringInvitaionViewControllerDelegate.event.location;
                
                let backDroptapGesture = UITapGestureRecognizer.init(target: self, action: #selector(backDropPressed));
                locationAlertView.alertBackdropView.addGestureRecognizer(backDroptapGesture);
                
                let alertWhiteViewtapGesture = UITapGestureRecognizer.init(target: self, action: #selector(alertWhiteViewPressed));
                locationAlertView.alertWhiteView.addGestureRecognizer(alertWhiteViewtapGesture);

                
                let getDirectionsTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(getDirectionsPressed));
                locationAlertView.lblGetDirections.addGestureRecognizer(getDirectionsTapGesture);

                
                var scrollViewContentSize: CGFloat  = 0.0;
                var photoIndex: Int = 0;
                for locationPhoto in gatheringInvitaionViewControllerDelegate.locationPhotos {
                    
                    let locationPhotoView = LocationAlertView.locationPhotoInstanceFromNib() as! LocationAlertView;
                    locationPhotoView.frame = CGRect.init(x: scrollViewContentSize, y: locationPhotoView.frame.origin.y, width: locationPhotoView.frame.width, height: locationPhotoView.frame.height)
                    locationPhotoView.ivLocationPhoto.sd_setImage(with: URL.init(string: "\(GOOGLE_PLACE_THUMBNAIL_PHOTOS_API)\(locationPhoto.photoReference!)"));
                    
                    let onImageTapListener = LocationImageTagGesture.init(target: self, action: #selector(locationImagePressed(sender: )));
                    onImageTapListener.selectedImageIndex = photoIndex; locationPhotoView.ivLocationPhoto.addGestureRecognizer(onImageTapListener);
                    
                    scrollViewContentSize = scrollViewContentSize + locationPhotoView.frame.width;
                    locationAlertView.scrollViewPlacePhotos.addSubview(locationPhotoView);
                    
                    photoIndex = photoIndex +  1;
                }
                
                locationAlertView.newCasesLabel.text = gatheringInvitaionViewControllerDelegate.locationBo.newCases;
                locationAlertView.locationPhoneLabel.text = gatheringInvitaionViewControllerDelegate.locationBo.phoneNumber;
                
                if (gatheringInvitaionViewControllerDelegate.locationBo.openNow != nil) {
                    if (gatheringInvitaionViewControllerDelegate.locationBo.openNow == true) {
                        locationAlertView.openNowLabel.text = "Open";
                        locationAlertView.openNowLabel.textColor = UIColor.green
                    } else {
                        locationAlertView.openNowLabel.text = "Closed";
                        locationAlertView.openNowLabel.textColor = UIColor.red
                    }
                } else {
                    locationAlertView.openNowLabel.text = "No Data";
                    locationAlertView.openNowLabel.textColor = UIColor.lightGray
                }
                
                if (gatheringInvitaionViewControllerDelegate.locationBo.phoneNumber != nil) {
                    locationAlertView.locationPhoneLabel.text = gatheringInvitaionViewControllerDelegate.locationBo.phoneNumber;
                } else {
                    locationAlertView.locationPhoneLabel.text = "No Data";
                    locationAlertView.locationPhoneLabel.textColor = UIColor.lightGray
                }
                
                locationAlertView.scrollViewPlacePhotos.contentSize.width = scrollViewContentSize;
                
                let aboutThisIconTap = UITapGestureRecognizer.init(target: self, action: #selector(aboutThisDataIconPressed));
                locationAlertView.aboutCovidIcon.addGestureRecognizer(aboutThisIconTap);

               
                let covidShowHideTapGesture = CovidShowHideTapGesture.init(target: self, action: #selector(updateShowCovidDataStatus(sender:)))
                covidShowHideTapGesture.showCovidData = true;
                locationAlertView.showLatestCovidInfoLabel.addGestureRecognizer(covidShowHideTapGesture)
                
               
                let donotShowCovidShowHideTapGesture = CovidShowHideTapGesture.init(target: self, action: #selector(updateShowCovidDataStatus(sender:)))
                donotShowCovidShowHideTapGesture.showCovidData = false;
                locationAlertView.donotShowThisDataLabel.addGestureRecognizer(donotShowCovidShowHideTapGesture)

                if (gatheringInvitaionViewControllerDelegate.loggedInUser.showCovidLocationData == true) {
                    locationAlertView.covidDataViewContainer.isHidden = false;
                    locationAlertView.showLatestCovidInfoView.isHidden = true;
                } else {
                    locationAlertView.covidDataViewContainer.isHidden = true;
                    locationAlertView.showLatestCovidInfoView.isHidden = false;
                    
                    self.locationAlertView.bottomSeparatorView.frame = CGRect.init(x: self.locationAlertView.bottomSeparatorView.frame.origin.x, y: self.locationAlertView.showLatestCovidInfoView.frame.origin.y + self.locationAlertView.showLatestCovidInfoView.frame.height, width: self.locationAlertView.bottomSeparatorView.frame.width, height: self.locationAlertView.bottomSeparatorView.frame.height);
                    
                    self.locationAlertView.lblGetDirections.frame = CGRect.init(x: self.locationAlertView.lblGetDirections.frame.origin.x, y: self.locationAlertView.bottomSeparatorView.frame.origin.y + self.locationAlertView.bottomSeparatorView.frame.height + 9, width: self.locationAlertView.lblGetDirections.frame.width, height: self.locationAlertView.lblGetDirections.frame.height);
                    
                    
                    let yPositionOfAlert: CGFloat = CGFloat(self.gatheringInvitaionViewControllerDelegate.view.frame.height/2) - CGFloat((389 + 40 - 148)/2);
                    self.locationAlertView.alertWhiteView.frame = CGRect.init(x: self.locationAlertView.alertWhiteView.frame.origin.x, y: yPositionOfAlert, width: self.locationAlertView.alertWhiteView.frame.width, height: (389 - 148) + 40);

                }
                
                let latDegrees = CLLocationDegrees.init(self.gatheringInvitaionViewControllerDelegate.event.latitude)
                let longDegrees = CLLocationDegrees.init(self.gatheringInvitaionViewControllerDelegate.event.longitude)
                gatheringInvitaionViewControllerDelegate.view.addSubview(locationAlertView);

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // your code here
                    self.locationAlertView.locationMap.clear();
                    // Creates a marker in the center of the map.
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: latDegrees!, longitude: longDegrees!)
                    
                    if (self.gatheringInvitaionViewControllerDelegate.locationBo.county != nil) {
                        marker.title = self.gatheringInvitaionViewControllerDelegate.locationBo.county;
                    } else if (self.gatheringInvitaionViewControllerDelegate.locationBo.state != nil) {
                        marker.title = self.gatheringInvitaionViewControllerDelegate.locationBo.state;
                    } else if (self.gatheringInvitaionViewControllerDelegate.locationBo.country != nil) {
                        marker.title = self.gatheringInvitaionViewControllerDelegate.locationBo.country
                    }
                    marker.snippet = self.gatheringInvitaionViewControllerDelegate.locationBo.markerSnippet;
                    marker.map = self.locationAlertView.locationMap;
                    let camera = GMSCameraPosition.camera(withLatitude: latDegrees!, longitude: longDegrees!, zoom: 6.0)
                    self.locationAlertView.locationMap.camera = camera;
                    self.locationAlertView.locationMap.animate(toLocation: marker.position);
                    self.locationAlertView.locationMap.selectedMarker = marker;
                }

                
                
            } else {
                let alert = UIAlertController(title: nil, message: gatheringInvitaionViewControllerDelegate.event.location, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Get Directions", style: .default, handler: {(resp) in
                    self.locationView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                    self.locationViewLocationIcon.image = UIImage.init(named: "location_off_icon")
                    
                    
                    //Working in Swift new versions.
                    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {UIApplication.shared.openURL(NSURL(string:"comgooglemaps://?saddr=&daddr=\(Float(String(self.gatheringInvitaionViewControllerDelegate.event.latitude!))),\(Float(String(self.gatheringInvitaionViewControllerDelegate.event.longitude!)))&directionsmode=driving")! as URL)
                    } else {
                        NSLog("Can't use com.google.maps://");
                        if (UIApplication.shared.canOpenURL(NSURL(string:"https://maps.google.com")! as URL))  {
                            
                            let url: String = String("https://maps.google.com?daddr=\(String(self.gatheringInvitaionViewControllerDelegate.event.location!).replacingOccurrences(of: " ", with: "+"))&center=\(String(self.gatheringInvitaionViewControllerDelegate.event.latitude!)),\(String(self.gatheringInvitaionViewControllerDelegate.event.longitude!))&zoom=15");
                            
                            print(url)
                            let finalURL: URL = NSURL(string: url)! as URL;
                            UIApplication.shared.open(finalURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil);
                            
                        }
                    }
                }))
                gatheringInvitaionViewControllerDelegate.present(alert, animated: true) {
                    alert.view.superview?.isUserInteractionEnabled = true
                    alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
                }
            }
            
        } else {
            
            var location = "No Location Selected";
            if (gatheringInvitaionViewControllerDelegate.event.location != nil) {
                location = gatheringInvitaionViewControllerDelegate.event.location!;
            }
            let alert = UIAlertController(title: "Location", message: "\(String(location))", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(resp) in
                self.locationView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.locationViewLocationIcon.image = UIImage.init(named: "location_off_icon")
            }))
            gatheringInvitaionViewControllerDelegate.present(alert, animated: true)
        }
    }
    
    @objc func alertControllerBackgroundTapped() {
        self.locationView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
        self.locationViewLocationIcon.image = UIImage.init(named: "location_off_icon")
        gatheringInvitaionViewControllerDelegate.dismiss(animated: true, completion: nil)
    }
    
    @objc func descriptionViewPressed() {
            
        self.processAlreadyCheckedBubble(selectedBubble: "description");
        
        self.descriptionView.backgroundColor = UIColor.white;
        self.descViewMessageIcon.image = UIImage.init(named: "message_on_icon");
        
        if (gatheringInvitaionViewControllerDelegate.event.description != nil && gatheringInvitaionViewControllerDelegate.event.description != "") {
            gatheringInvitaionViewControllerDelegate.trackCheckdeBubble = "description";
            
            self.descriptionView.backgroundColor = UIColor.white;
            self.descriptionUILabel.text = gatheringInvitaionViewControllerDelegate.event.description;
            var isScrollViewPresent = false;
            for uiview in self.gatheringInvitaionViewControllerDelegate.view.subviews {
                if (uiview is ChatFeatureView) {
                    isScrollViewPresent = true;
                }
            }
            
            if (isScrollViewPresent == true) {
                
                if (self.gatheringInvitaionViewControllerDelegate.event.expired == false) {
                    self.gatheringInvitaionViewControllerDelegate.setSwipeRestrictions();
                }
                
                for uiview in self.gatheringInvitaionViewControllerDelegate.view.subviews {
                    if (uiview is ChatFeatureView) {
                        uiview.removeFromSuperview();
                    }
                }
                self.descViewMessageIcon.image = UIImage.init(named: "message_off_icon");
                self.descriptionView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.gatheringInvitaionViewControllerDelegate.invitationCardTableView.isScrollEnabled = true;

            } else {

                if (gatheringInvitaionViewControllerDelegate.event.eventId != nil) {
                    gatheringInvitaionViewControllerDelegate.addChatScrollView();
                    gatheringInvitaionViewControllerDelegate.makeMessagesAsRead();
                   
                    self.gatheringInvitaionViewControllerDelegate.leftToRightGestureEnabled = false;
                    self.gatheringInvitaionViewControllerDelegate.rightToLeftGestureEnabled = false;

                    self.gatheringInvitaionViewControllerDelegate.invitationCardTableView.isScrollEnabled = false;
                    
                } else {
                    
                    if (self.descriptionUILabelHolder.isHidden) {
                        
                        self.gatheringInvitaionViewControllerDelegate.leftToRightGestureEnabled = false;
                        self.gatheringInvitaionViewControllerDelegate.rightToLeftGestureEnabled = false;

                        self.descriptionUILabelHolder.isHidden = false;
                        let height = self.heightForViewDesc(text:gatheringInvitaionViewControllerDelegate.event.description!, font: self.descriptionUILabel.font, width: self.descriptionUILabel.frame.width);
                        
                        
                        //160 is the destance from bottom
                        //40 is the total padding from uilabel(20 top , 20 bottom)
                        //so y will be total height of screen - bottom space(160) - height of uilabel(height) - total padding(top + bottom)
                        self.descriptionUILabelHolder.frame =  CGRect(x: self.descriptionUILabelHolder.frame.origin.x, y: gatheringInvitaionViewControllerDelegate.view.frame.height - (160 + height + 40) , width: self.descriptionUILabelHolder.frame.width, height: height + 40);
                        
                        self.chatProfilePic.isHidden = false;
                        
                    } else {
                        
                        if (self.gatheringInvitaionViewControllerDelegate.event.expired == false) {
                            self.gatheringInvitaionViewControllerDelegate.setSwipeRestrictions();
                        }
                        
                        self.descriptionView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                        self.descriptionUILabelHolder.isHidden = true;
                        self.chatProfilePic.isHidden = true;
                        self.descViewMessageIcon.image = UIImage.init(named: "message_off_icon");
                    }
                }
            }
            /*if (self.descriptionUILabelHolder.isHidden) {
                
                self.descriptionUILabelHolder.isHidden = false;
                let height = self.heightForView(text:gatheringInvitaionViewControllerDelegate.event.description!, font: self.descriptionUILabel.font, width: self.descriptionUILabel.frame.width);
                
                
                //160 is the destance from bottom
                //40 is the total padding from uilabel(20 top , 20 bottom)
                //so y will be total height of screen - bottom space(160) - height of uilabel(height) - total padding(top + bottom)
                self.descriptionUILabelHolder.frame =  CGRect(x: self.descriptionUILabelHolder.frame.origin.x, y: gatheringInvitaionViewControllerDelegate.view.frame.height - (160 + height + 40) , width: self.descriptionUILabelHolder.frame.width, height: height + 40);
                
                self.chatProfilePic.isHidden = false;
                
            } else {
                self.descriptionView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.descriptionUILabelHolder.isHidden = true;
                self.chatProfilePic.isHidden = true;
                self.descViewMessageIcon.image = UIImage.init(named: "message_off_icon");
            }*/
        } else {
            let alert = UIAlertController(title: "Alert!", message: "Description Not Available.", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(resp) in
                self.descriptionView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.descViewMessageIcon.image = UIImage.init(named: "message_off_icon");
            }));
            gatheringInvitaionViewControllerDelegate.present(alert, animated: true)
        }
    }
    
    @objc func shareViewPressed() {
        
        self.processAlreadyCheckedBubble(selectedBubble: "share");
        gatheringInvitaionViewControllerDelegate.trackCheckdeBubble = "share";
        
        if (gatheringInvitaionViewControllerDelegate.event.eventId == nil || gatheringInvitaionViewControllerDelegate.event.eventId == 0) {
            let alert = UIAlertController(title: "Alert!", message: "Event cannot be shared this time.", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
            gatheringInvitaionViewControllerDelegate.present(alert, animated: true)
        } else {
            
            var text: String = "\(gatheringInvitaionViewControllerDelegate.eventOwner.user!.name!) invites you to \(gatheringInvitaionViewControllerDelegate.event.title!). RSVP through the Cenes app. Link below: \n";
            text = text + String("\(shareEventUrl)\(String(gatheringInvitaionViewControllerDelegate.event.key!))");
            
            // set up activity view controller
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = gatheringInvitaionViewControllerDelegate.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = []
            
            // present the view controller
            gatheringInvitaionViewControllerDelegate.present(activityViewController, animated: true, completion: nil)
            
            Mixpanel.mainInstance().track(event: "Invitation",
            properties:[ "Action" : "Share Invitation", "Title":"\(gatheringInvitaionViewControllerDelegate.event.title!)", "UserEmail": "\(gatheringInvitaionViewControllerDelegate.loggedInUser.email!)", "UserName": "\(gatheringInvitaionViewControllerDelegate.loggedInUser.name!)"]);
        }
    }
    
    @objc func eventImageTapped() {
        //print("Tapped")
        
        self.descriptionView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
        self.descriptionUILabelHolder.isHidden = true;
        self.chatProfilePic.isHidden = true;
        self.descViewMessageIcon.image = UIImage.init(named: "message_off_icon");
        
        gatheringInvitaionViewControllerDelegate.resetScreenToDefaultPosition();
    }
    
    @objc func locationImagePressed(sender: LocationImageTagGesture) {
        var locationImages = [String]();
        for locImg in gatheringInvitaionViewControllerDelegate.locationPhotos {
            locationImages.append("\(GOOGLE_PLACE_SLIDER_PHOTOS_API)\(locImg.photoReference!)");
        }
        let viewController = gatheringInvitaionViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "ImageSliderViewController") as! ImageSliderViewController;
        viewController.photos = locationImages;
        viewController.selectedIndex = sender.selectedImageIndex
        gatheringInvitaionViewControllerDelegate.navigationController?.pushViewController(viewController, animated: true);
    }
    
    func heightForViewDesc(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.descriptionUILabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func processAlreadyCheckedBubble(selectedBubble: String) {
        
        if (gatheringInvitaionViewControllerDelegate.trackCheckdeBubble != selectedBubble) {
            
            if (gatheringInvitaionViewControllerDelegate.trackCheckdeBubble == "description") {
                self.descriptionView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
                self.descriptionUILabelHolder.isHidden = true;
                self.chatProfilePic.isHidden = true;
                self.descViewMessageIcon.image = UIImage.init(named: "message_off_icon");
                for uiview in self.gatheringInvitaionViewControllerDelegate.view.subviews {
                    if (uiview is ChatFeatureView) {
                        uiview.removeFromSuperview();
                    }
                }
                self.gatheringInvitaionViewControllerDelegate.invitationCardTableView.isScrollEnabled = true;
            }
        }
    }
    
    @objc func guestListViewPressed() {
        
        self.processAlreadyCheckedBubble(selectedBubble: "guestList");
        
        gatheringInvitaionViewControllerDelegate.trackCheckdeBubble = "guestList";
        
        let guestListViewController: GuestListViewController = gatheringInvitaionViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "GuestListViewController") as! GuestListViewController;
            guestListViewController.event = gatheringInvitaionViewControllerDelegate.event;
            gatheringInvitaionViewControllerDelegate.present(guestListViewController, animated: true, completion: nil);
    }
    
    @objc func backDropPressed() {
        for locAlertView in gatheringInvitaionViewControllerDelegate.view.subviews {
            if (locAlertView is LocationAlertView) {
                locAlertView.removeFromSuperview();
            }
        }
        self.locationView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
        self.locationViewLocationIcon.image = UIImage.init(named: "location_off_icon")
    }
    
    @objc func alertWhiteViewPressed() {
        
    }
    
    @objc func getDirectionsPressed() {
        
        for locAlertView in gatheringInvitaionViewControllerDelegate.view.subviews {
            if (locAlertView is LocationAlertView) {
                locAlertView.removeFromSuperview();
            }
        }
        self.locationView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3);
        self.locationViewLocationIcon.image = UIImage.init(named: "location_off_icon")
        
        
        //Working in Swift new versions.
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {UIApplication.shared.openURL(NSURL(string:"comgooglemaps://?saddr=&daddr=\(Float(String(self.gatheringInvitaionViewControllerDelegate.event.latitude!))),\(Float(String(self.gatheringInvitaionViewControllerDelegate.event.longitude!)))&directionsmode=driving")! as URL)
        } else {
            NSLog("Can't use com.google.maps://");
            if (UIApplication.shared.canOpenURL(NSURL(string:"https://maps.google.com")! as URL))  {
                
                let url: String = String("https://maps.google.com?daddr=\(String(self.gatheringInvitaionViewControllerDelegate.event.location!).replacingOccurrences(of: " ", with: "+"))&center=\(String(self.gatheringInvitaionViewControllerDelegate.event.latitude!)),\(String(self.gatheringInvitaionViewControllerDelegate.event.longitude!))&zoom=15");
                
                print(url)
                let finalURL: URL = NSURL(string: url)! as URL;
                UIApplication.shared.open(finalURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil);
                
            }
        }
        
    }
    
    func populateCardDetails () {
        
        for eventMember in gatheringInvitaionViewControllerDelegate.event.eventMembers! {
            
            //We have to check user id, because there may be users which are non cenes users
            if (eventMember.userId != 0 && gatheringInvitaionViewControllerDelegate.event.createdById == eventMember.userId) {
                gatheringInvitaionViewControllerDelegate.eventOwner = eventMember;
                break;
            }
        }
        
        if (gatheringInvitaionViewControllerDelegate.eventOwner == nil) {
            gatheringInvitaionViewControllerDelegate.eventOwner = Event().getLoggedInUserAsEventMember();
        }
        
        if (gatheringInvitaionViewControllerDelegate.eventOwner != nil) {
            if (gatheringInvitaionViewControllerDelegate.eventOwner.user != nil && gatheringInvitaionViewControllerDelegate.eventOwner.user!.photo != nil) {
                chatProfilePic.sd_setImage(with: URL(string: gatheringInvitaionViewControllerDelegate.eventOwner.user!.photo!), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
                profilePic.sd_setImage(with: URL(string: gatheringInvitaionViewControllerDelegate.eventOwner.user!.photo!), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
            }
            
            if (gatheringInvitaionViewControllerDelegate.eventOwner.userId == gatheringInvitaionViewControllerDelegate.loggedInUser.userId) {
                gatheringInvitaionViewControllerDelegate.isLoggedInUserAsOwner = true;
            }
            
        }
        
        if (gatheringInvitaionViewControllerDelegate.event.eventId != nil && gatheringInvitaionViewControllerDelegate.event.eventId != 0) {
            if (gatheringInvitaionViewControllerDelegate.event.eventPicture != nil) {
                eventPicture.sd_setImage(with: URL(string: gatheringInvitaionViewControllerDelegate.event.thumbnail!));

                eventPicture.sd_setImage(with: URL(string: gatheringInvitaionViewControllerDelegate.event.eventPicture!), placeholderImage: UIImage(url: URL(string: gatheringInvitaionViewControllerDelegate.event.thumbnail!)));
                
            }/* else if (gatheringInvitaionViewControllerDelegate.event.imageToUpload != nil) {
                
                eventPicture.image = gatheringInvitaionViewControllerDelegate.event.imageToUpload;
            }*/
        } /*else {
            if (gatheringInvitaionViewControllerDelegate.event.imageToUpload != nil) {
                
                eventPicture.image = gatheringInvitaionViewControllerDelegate.event.imageToUpload;
            }
        }*/
        
        evntTitle.text = gatheringInvitaionViewControllerDelegate.event.title;
        
        let dateOfEvent = Date(milliseconds: Int(gatheringInvitaionViewControllerDelegate.event!.startTime)).EMMMd()!;
        
        let timeOfEvent = "\(Date(milliseconds: Int(gatheringInvitaionViewControllerDelegate.event!.startTime)).hmma())-\(Date(milliseconds: Int(gatheringInvitaionViewControllerDelegate.event!.endTime)).hmma())"
        
        eventTime.text = "\(dateOfEvent), \(timeOfEvent)";
        
        /*if (imageCard != nil) {
            imageCard.setNeedsDisplay();
        }*/
        
        
        if (gatheringInvitaionViewControllerDelegate.isLoggedInUserAsOwner == true) {
            gatheringInvitaionViewControllerDelegate.editImageView.isHidden = false;
            gatheringInvitaionViewControllerDelegate.deleteImageView.isHidden = false;
            gatheringInvitaionViewControllerDelegate.rejectedImageiew.isHidden = true;
        } else {
            gatheringInvitaionViewControllerDelegate.editImageView.isHidden = true;
            gatheringInvitaionViewControllerDelegate.deleteImageView.isHidden = true;
            gatheringInvitaionViewControllerDelegate.rejectedImageiew.isHidden = false;
        }
    }
    
    @objc func updateShowCovidDataStatus(sender: CovidShowHideTapGesture) {
        
        var postData = [String: Any]();
        postData["userId"] = self.gatheringInvitaionViewControllerDelegate.loggedInUser.userId;
        postData["showCovidLocationData"] = sender.showCovidData;
        
        let url = "\(apiUrl)\(UserService().post_userdetails)";
        UserService().commonPostCall(postData: postData, token: self.gatheringInvitaionViewControllerDelegate.loggedInUser.token, apiEndPoint: url, complete: {(response) in
            
            self.gatheringInvitaionViewControllerDelegate.loggedInUser.showCovidLocationData = sender.showCovidData;
            User().updateUserValuesInUserDefaults(user: self.gatheringInvitaionViewControllerDelegate.loggedInUser);
           
            if (sender.showCovidData == true) {
                self.locationAlertView.covidDataViewContainer.isHidden = false;
                self.locationAlertView.showLatestCovidInfoView.isHidden = true;
                
                self.locationAlertView.bottomSeparatorView.frame = CGRect.init(x: self.locationAlertView.bottomSeparatorView.frame.origin.x, y: self.locationAlertView.covidDataViewContainer.frame.origin.y + self.locationAlertView.covidDataViewContainer.frame.height + 12, width: self.locationAlertView.bottomSeparatorView.frame.width, height: self.locationAlertView.bottomSeparatorView.frame.height);
                
                
                self.locationAlertView.lblGetDirections.frame = CGRect.init(x: self.locationAlertView.lblGetDirections.frame.origin.x, y: self.locationAlertView.bottomSeparatorView.frame.origin.y + self.locationAlertView.bottomSeparatorView.frame.height + 9, width: self.locationAlertView.lblGetDirections.frame.width, height: self.locationAlertView.lblGetDirections.frame.height);
                
                let yPositionOfAlert = self.gatheringInvitaionViewControllerDelegate.view.frame.height/2 - 550/2;
                self.locationAlertView.alertWhiteView.frame = CGRect.init(x: self.locationAlertView.alertWhiteView.frame.origin.x, y: yPositionOfAlert, width: self.locationAlertView.alertWhiteView.frame.width, height: 550);
                
            } else {
                self.locationAlertView.covidDataViewContainer.isHidden = true;
                self.locationAlertView.showLatestCovidInfoView.isHidden = false;
                
                self.locationAlertView.bottomSeparatorView.frame = CGRect.init(x: self.locationAlertView.bottomSeparatorView.frame.origin.x, y: self.locationAlertView.showLatestCovidInfoView.frame.origin.y + self.locationAlertView.showLatestCovidInfoView.frame.height, width: self.locationAlertView.bottomSeparatorView.frame.width, height: self.locationAlertView.bottomSeparatorView.frame.height);
                
                self.locationAlertView.lblGetDirections.frame = CGRect.init(x: self.locationAlertView.lblGetDirections.frame.origin.x, y: self.locationAlertView.bottomSeparatorView.frame.origin.y + self.locationAlertView.bottomSeparatorView.frame.height + 9, width: self.locationAlertView.lblGetDirections.frame.width, height: self.locationAlertView.lblGetDirections.frame.height);
                
                
                let yPositionOfAlert:CGFloat = CGFloat(self.gatheringInvitaionViewControllerDelegate.view.frame.height/2) - CGFloat((389 + 40 - 148)/2);
                self.locationAlertView.alertWhiteView.frame = CGRect.init(x: self.locationAlertView.alertWhiteView.frame.origin.x, y: yPositionOfAlert, width: self.locationAlertView.alertWhiteView.frame.width, height: (389 - 148) + 40);

            }
        });
    }
    
    @objc func aboutThisDataIconPressed() {
           
           let viewController = self.gatheringInvitaionViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "WeblinkInAppViewController") as! WeblinkInAppViewController;
           viewController.urlToOpen = "\(covidDisclaimerLink)"; self.gatheringInvitaionViewControllerDelegate.navigationController?.pushViewController(viewController, animated: true);
       }
}

public class LocationImageTagGesture: UITapGestureRecognizer {
    var selectedImageIndex: Int!;
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
