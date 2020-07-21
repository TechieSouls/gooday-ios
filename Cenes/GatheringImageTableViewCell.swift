//
//  GatheringImageTableViewCell.swift
//  Cenes
//
//  Created by Cenes_Dev on 26/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GatheringImageTableViewCell: UITableViewCell, GatheringImageTableViewCellDelegate {
    
    @IBOutlet weak var gatheringImagePlaceholder: UIImageView!;
    @IBOutlet weak var gatheringImage: UIImageView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageSelected(selectedImg: UIImage) {
        gatheringImagePlaceholder.isHidden = true;
        gatheringImage.isHidden = false;
        gatheringImage.image = selectedImg;
    }
}
