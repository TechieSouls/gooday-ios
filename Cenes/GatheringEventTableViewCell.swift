//
//  GatheringEventTableViewCell.swift
//  Cenes
//
//  Created by Redblink on 11/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit

protocol GatheringEventCellDelegate : class {
    func imageButtonTApped(cell:GatheringEventTableViewCell)
    
}



class GatheringEventTableViewCell: UITableViewCell ,CreateGatheringViewControllerDelegate{
    
    
    
    
    @IBOutlet weak var gatheringImageView: UIImageView!
    
    var tapGesture : UITapGestureRecognizer!
    var imageDelegate : GatheringEventCellDelegate!
    var indexPathCell : IndexPath!
    var gView : CreateGatheringViewController!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectImageButtonPressed(_:)))
        self.gatheringImageView.isUserInteractionEnabled = true
        self.gatheringImageView.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadImage(){
        if(self.gView != nil && self.gView.gatheringImageURL != nil)
        {
            let webServ = WebService()
            webServ.profilePicFromFacebook(url: self.gView.gatheringImageURL, completion: { image in
                self.gatheringImageView.image = image
                self.gView.gatheringImage = image
            })
        }
    }
    
    @IBAction func selectImageButtonPressed(_ sender: Any) {
        
        print("buttonImagePressed")
        
        self.imageDelegate.imageButtonTApped(cell:self)
        
    }
    
    @IBAction func imagePickerButtonPressed(_ sender: Any) {
        print("ImagePicked")
    }
    
    func setEventImage(image : UIImage){
     self.gatheringImageView.image = image
    }
}
