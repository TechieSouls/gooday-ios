//
//  GatheringInfoTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import GoogleMaps

class GatheringInfoTableViewCell: UITableViewCell, MessageProtocol, SelectedLocationProtocol, GatheringInfoCellProtocol {

    @IBOutlet weak var locationBar: UIView!
    @IBOutlet weak var messageBar: UIView!
    @IBOutlet weak var imageBar: UIView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var totalCasesLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var locationPhoneLabel: UILabel!

    @IBOutlet weak var covidInfoContainerView: UIView!
    @IBOutlet weak var covidInfoContainerBottomSeparator: UIView!
    @IBOutlet weak var locationArrowBtn: UIImageView!
    @IBOutlet weak var locationMap: GMSMapView!
    @IBOutlet weak var covidLocationDataInfoView: UIView!
    @IBOutlet weak var donotShowDataLabel: UILabel!
    @IBOutlet weak var showCovidDataLabelView: UIView!
    
    @IBOutlet weak var aboutThisDataIcon: UIImageView!;

    @IBOutlet weak var uploadingImageSpinner: UIActivityIndicatorView!
    
    var createGatheringDelegate: CreateGatheringV2ViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let locationBarTap = UITapGestureRecognizer.init(target: self, action: #selector(locationBarPressed));
        locationBar.addGestureRecognizer(locationBarTap);
        
        let messageBarTap = UITapGestureRecognizer.init(target: self, action: #selector(messageBarPressed));
        messageBar.addGestureRecognizer(messageBarTap);
        
        let imageBarTap = UITapGestureRecognizer.init(target: self, action: #selector(imageBarPressed));
        imageBar.addGestureRecognizer(imageBarTap);
        
        let locationArrowTap = UITapGestureRecognizer.init(target: self, action: #selector(locationArrowPressed));
        locationArrowBtn.addGestureRecognizer(locationArrowTap);
        

        let showCovidDataBarTap = CovidShowHideTapGesture.init(target: self, action: #selector(updateShowCovidDataStatus(sender:)));
        showCovidDataBarTap.showCovidData = true;
        showCovidDataLabelView.addGestureRecognizer(showCovidDataBarTap);

        let hideCovidDataBarTap = CovidShowHideTapGesture.init(target: self, action: #selector(updateShowCovidDataStatus(sender:)));
        hideCovidDataBarTap.showCovidData = false;
        donotShowDataLabel.addGestureRecognizer(hideCovidDataBarTap);

        let aboutThisIconTap = UITapGestureRecognizer.init(target: self, action: #selector(aboutThisDataIconPressed));
        aboutThisDataIcon.addGestureRecognizer(aboutThisIconTap);

        
        uploadingImageSpinner.isHidden = true;
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        locationMap.camera = camera;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func locationBarPressed() {
        createGatheringDelegate.performSegue(withIdentifier: "createGatheringLocationSeague", sender: createGatheringDelegate);
        
    }
    
    @objc func messageBarPressed() {
        createGatheringDelegate.performSegue(withIdentifier: "createGathMessageSeague", sender: createGatheringDelegate);
    }
    
    @objc func imageBarPressed() {
        createGatheringDelegate.openShareSheetForCoverImage();
    }
    
    @objc func locationArrowPressed() {
        
        if (self.createGatheringDelegate.loggedInUser.showCovidLocationData == true) {
            if (covidInfoContainerView.isHidden == false) {
                createGatheringDelegate.createGathDto.isCovidMapOpened = false;
                covidInfoContainerView.isHidden = true;
                locationArrowBtn.image = UIImage.init(named: "gath_info_right_arrow");

            } else {
                createGatheringDelegate.createGathDto.isCovidMapOpened = true;
                covidInfoContainerView.isHidden = false;
                locationArrowBtn.image = UIImage.init(named: "gath_info_down_arrow");

            }
        } else {
            if (showCovidDataLabelView.isHidden == false) {
                createGatheringDelegate.createGathDto.isCovidMapOpened = false;
                showCovidDataLabelView.isHidden = true;
                locationArrowBtn.image = UIImage.init(named: "gath_info_right_arrow");

            } else {
                createGatheringDelegate.createGathDto.isCovidMapOpened = true;
                showCovidDataLabelView.isHidden = false;
                locationArrowBtn.image = UIImage.init(named: "gath_info_down_arrow");
            }
        }
        
        createGatheringDelegate.createGathTableView.reloadData();
    }
    
    func messageDonePressed(message: String) {
        createGatheringDelegate.event.description = message;
        messageLabel.isHidden = false;
        
        //Code to show hide Event Preview Button.
        createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.messageField] = true;
        //createGatheringDelegate.showHidePreviewGatheringButton();
    }
    
    func locationSelected(location: Location) {
        locationLabel.isHidden = false;
        
        if (location.placeId == nil) {
            locationArrowBtn.isUserInteractionEnabled = false;
            locationLabel.text = "\(String(location.location)) [CL]";
            covidInfoContainerView.isHidden = true;
            createGatheringDelegate.createGathDto.isCovidMapOpened = false;
            self.createGatheringDelegate.createGathTableView.reloadData();

        } else {
            locationArrowBtn.isUserInteractionEnabled = true;
            covidInfoContainerView.isHidden = false;
            locationArrowBtn.image = UIImage.init(named: "gath_info_down_arrow");

            createGatheringDelegate.createGathDto.isCovidMapOpened = true;
            locationLabel.text = location.location;
            
            let heightToAdd = 153 + ((self.createGatheringDelegate.view.frame.width*80)/100 - 153)
            locationMap.frame = CGRect.init(x: locationMap.frame.origin.x, y: locationMap.frame.origin.y, width: locationMap.frame.width, height: heightToAdd);
            
            covidLocationDataInfoView.frame = CGRect.init(x: covidLocationDataInfoView.frame.origin.x, y: locationMap.frame.origin.y + (locationMap.frame.height - covidLocationDataInfoView.frame.height), width: covidLocationDataInfoView.frame.width, height: covidLocationDataInfoView.frame.height);
            
            messageBar.frame = CGRect.init(x: messageBar.frame.origin.x, y: covidLocationDataInfoView.frame.origin.y + covidLocationDataInfoView.frame.height + 15, width: messageBar.frame.width, height: messageBar.frame.height);

            imageBar.frame = CGRect.init(x: imageBar.frame.origin.x, y: messageBar.frame.origin.y + messageBar.frame.height + 15, width: imageBar.frame.width, height: imageBar.frame.height);

        }
        
        //Setting Location Data.
        createGatheringDelegate.event.location = location.location;
        if (location.latitudeDouble != nil) {
            createGatheringDelegate.event.latitude = String(location.latitudeDouble);
        }
        if (location.longitudeDouble != nil) {
            createGatheringDelegate.event.longitude = String(location.longitudeDouble);
        }
        if (location.placeId != nil) {
            createGatheringDelegate.event.placeId = location.placeId;
        }
        if (location.openNow != nil) {
            if (location.openNow == true) {
                openNowLabel.text = "Open";
                openNowLabel.textColor = UIColor.green
            } else {
                openNowLabel.text = "Closed";
                openNowLabel.textColor = UIColor.red
            }
        } else {
            openNowLabel.text = "No Data";
            openNowLabel.textColor = UIColor.lightGray
        }
        
        if (location.phoneNumber != nil) {
            locationPhoneLabel.text = location.phoneNumber;
        } else {
            locationPhoneLabel.text = "No Data";
            locationPhoneLabel.textColor = UIColor.lightGray

        }
        //Code to show hide Event Preview Button.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        if (createGatheringDelegate.event.latitude != nil && createGatheringDelegate.event.latitude != "" && locationMap != nil) {
            let api = "\(apiUrl)\(GatheringService().post_covid_stats)";
            var postData = [String: Any]();
            postData["covidTimestamp"] = Date().millisecondsSince1970;
            if let countryName = location.country {
                postData["countryCode"] = countryName;
            }
            if let state = location.state {
                postData["state"] = state;
            }
            if let county = location.county  {
                postData["county"] = county;
            }
            createGatheringDelegate.createGathTableView.reloadData();

            GatheringService().gatheringCommonPostAPI(api: api, postData: postData, token: createGatheringDelegate.loggedInUser.token, complete: {(response) in
                
                let success = response.value(forKey: "success") as! Bool
                if (success == true) {
                    
                    let latDegrees = CLLocationDegrees.init(self.createGatheringDelegate.event.latitude)
                    let longDegrees = CLLocationDegrees.init(self.createGatheringDelegate.event.longitude)

                    
                    self.locationMap.clear();
                    // Creates a marker in the center of the map.
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: latDegrees!, longitude: longDegrees!)

                    let covidDataDict = response.value(forKey: "data") as! NSDictionary;
                    if let cityDict = covidDataDict.value(forKey: "city") as? NSDictionary {
                        
                        self.totalCasesLabel.text = "\((cityDict.value(forKey: "newCases") as! String))";
                        marker.title = location.county;

                        /*var marketHtml = "<html>";
                        marketHtml.append("<body>");
                        marketHtml.append("<table>");
                            marketHtml.append("<tr><td>Confirmed</td><td>\(cityDict.value(forKey: "confirmed") as! String)</td></tr>");
                            marketHtml.append("<tr><td>Recovered</td><td>\(cityDict.value(forKey: "recovered") as! String)</td></tr>");
                            marketHtml.append("<tr><td>Deaths</td><td>\(cityDict.value(forKey: "deaths") as! String)</td></tr>");
                        marketHtml.append("</table>");
                        marketHtml.append("</body></html>");
                         marker.snippet = marketHtml;
                         */

                        marker.snippet = "Confirmed \t \(cityDict.value(forKey: "confirmed") as! String)\nRecovered\t \(cityDict.value(forKey: "recovered") as! String)\nDeaths   \t\t    \(cityDict.value(forKey: "deaths") as! String)"
                    } else if let state = covidDataDict.value(forKey: "state") as? NSDictionary {
                        self.totalCasesLabel.text = "\((state.value(forKey: "newCases") as! String))";
                        marker.title = location.state;

                        /*var marketHtml = "<html>";
                        marketHtml.append("<body>");
                        marketHtml.append("<table>");
                            marketHtml.append("<tr><td>Confirmed</td><td>\(state.value(forKey: "confirmed") as! String)</td></tr>");
                            marketHtml.append("<tr><td>Recovered</td><td>\(state.value(forKey: "recovered") as! String)</td></tr>");
                            marketHtml.append("<tr><td>Deaths</td><td>\(state.value(forKey: "deaths") as! String)</td></tr>");
                        marketHtml.append("</table>");
                        marketHtml.append("</body></html>");
                        marker.snippet = marketHtml;*/
                        
                        marker.snippet = "Confirmed \t \(state.value(forKey: "confirmed") as! String)\nRecovered\t \(state.value(forKey: "recovered") as! String)\nDeaths   \t\t    \(state.value(forKey: "deaths") as! String)"
                    } else if let country = covidDataDict.value(forKey: "country") as? NSDictionary {
                        self.totalCasesLabel.text = "\((country.value(forKey: "newCases") as! String))";

                        marker.title = location.country;

                        /*var marketHtml = "<html>";
                        marketHtml.append("<body>");
                        marketHtml.append("<table>");
                            marketHtml.append("<tr><td>Confirmed</td><td>\(country.value(forKey: "confirmed") as! String)</td></tr>");
                            marketHtml.append("<tr><td>Recovered</td><td>\(country.value(forKey: "recovered") as! String)</td></tr>");
                            marketHtml.append("<tr><td>Deaths</td><td>\(country.value(forKey: "deaths") as! String)</td></tr>");
                        marketHtml.append("</table>");
                        marketHtml.append("</body></html>");
                        marker.snippet = marketHtml;*/
                        
                        marker.snippet = "Confirmed \t \(country.value(forKey: "confirmed") as! String)\nRecovered\t \(country.value(forKey: "recovered") as! String)\nDeaths\t\t    \(country.value(forKey: "deaths") as! String)"
                    }
                    marker.map = self.locationMap
                    let camera = GMSCameraPosition.camera(withLatitude: latDegrees!, longitude: longDegrees!, zoom: 6.0)
                    self.locationMap.camera = camera;
                    self.locationMap.animate(toLocation: marker.position);
                    self.locationMap.selectedMarker = marker;
                }
                self.createGatheringDelegate.createGathTableView.reloadData();
            });
        }
        createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.locationField] = true;
        //createGatheringDelegate.showHidePreviewGatheringButton();
    }
    
    func imageSelected() {
        
        if (createGatheringDelegate != nil) {
            //Code to show hide Event Preview Button.
            createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.imageField] = true;
            //createGatheringDelegate.showHidePreviewGatheringButton();

        } else {
            createGatheringDelegate.showAlert(title: "Error", message: "Cannot upload from screenshot")
        }
    }
    
    
    func uploadImageAndGetUrl(imageToUpload: UIImage) {
        
        self.createGatheringDelegate.previewGatheirngButton.isUserInteractionEnabled = false;
        self.imageLabel.isHidden = true;
        self.uploadingImageSpinner.isHidden = false;
        self.uploadingImageSpinner.startAnimating();
        GatheringService().uploadEventImageV3(image: imageToUpload, loggedInUser: createGatheringDelegate.loggedInUser, complete: {(response) in
            
            self.uploadingImageSpinner.isHidden
                = true;
            self.uploadingImageSpinner.stopAnimating();
            self.imageLabel.isHidden = false;
            self.createGatheringDelegate.previewGatheirngButton.isUserInteractionEnabled = true;

            let success = response.value(forKey: "success") as! Bool;
            if (success == true) {
                if (response.value(forKey: "data") != nil) {
                    
                    print(images);
                    let images = response.value(forKey: "data") as! NSDictionary;
                    
                    if (images.value(forKey: "large") != nil) {
                        self.createGatheringDelegate.event.eventPicture = images.value(forKey: "large") as! String;
                    }
                    
                    if (images.value(forKey: "thumbnail") != nil) {
                        self.createGatheringDelegate.event.thumbnail = images.value(forKey: "thumbnail") as! String;
                    } else {
                        self.createGatheringDelegate.event.thumbnail = images.value(forKey: "large") as! String;
                    }
                    
                }
                
            }
        });
    }
    
    @objc func updateShowCovidDataStatus(sender: CovidShowHideTapGesture) {
        
        var postData = [String: Any]();
        postData["userId"] = self.createGatheringDelegate.loggedInUser.userId;
        postData["showCovidLocationData"] = sender.showCovidData;
        
        let url = "\(apiUrl)\(UserService().post_userdetails)";
        UserService().commonPostCall(postData: postData, token: self.createGatheringDelegate.loggedInUser.token, apiEndPoint: url, complete: {(response) in
            
            self.createGatheringDelegate.loggedInUser.showCovidLocationData = sender.showCovidData;
            User().updateUserValuesInUserDefaults(user: self.createGatheringDelegate.loggedInUser);
            self.createGatheringDelegate.createGathTableView.reloadData();
        });
    }
    
    @objc func aboutThisDataIconPressed() {
        
        let viewController = self.createGatheringDelegate.storyboard?.instantiateViewController(withIdentifier: "WeblinkInAppViewController") as! WeblinkInAppViewController;
        viewController.urlToOpen = "\(covidDisclaimerLink)"; self.createGatheringDelegate.navigationController?.pushViewController(viewController, animated: true);
    }
    
    func uploadImageLabelOnly() {
        self.imageLabel.isHidden = false;
    }
}
