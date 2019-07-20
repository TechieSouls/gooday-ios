//
//  GatheringInfoTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GatheringInfoTableViewCell: UITableViewCell, MessageProtocol, SelectedLocationProtocol, GatheringInfoCellProtocol {

    @IBOutlet weak var locationBar: UIView!
    @IBOutlet weak var messageBar: UIView!
    @IBOutlet weak var imageBar: UIView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    
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
    
    func messageDonePressed(message: String) {
        createGatheringDelegate.event.description = message;
        messageLabel.isHidden = false;
        
        //Code to show hide Event Preview Button.
        createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.messageField] = true;
        createGatheringDelegate.showHidePreviewGatheringButton();
    }
    
    func locationSelected(location: Location) {
        locationLabel.isHidden = false;
        
        if (location.placeId == nil) {
            locationLabel.text = "\(String(location.location)) [CL]";
        } else {
            locationLabel.text = location.location;
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
        
        //Code to show hide Event Preview Button.
        createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.locationField] = true;
        createGatheringDelegate.showHidePreviewGatheringButton();
    }
    
    func imageSelected() {
        imageLabel.isHidden = false;
        
        if (createGatheringDelegate != nil) {
            //Code to show hide Event Preview Button.
            createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.imageField] = true;
            createGatheringDelegate.showHidePreviewGatheringButton();

        } else {
            createGatheringDelegate.showAlert(title: "Error", message: "Cannot upload from screenshot")
        }
    }
    
}
