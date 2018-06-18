//
//  PhotosCell.swift
//  Cenes
//
//  Created by Redblink on 14/11/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import IoniconsSwift

class PhotosCell: UICollectionViewCell {
    
    @IBOutlet weak var AddedImage: UIImageView!
    
    @IBOutlet weak var crossButton: UIButton!
    
    var cellDiary : DiaryCellOne!
    
    var indexPath : IndexPath!
    
    @IBOutlet weak var backWhiteView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        crossButton.setImage(Ionicons.iosCloseOutline.image(40, color: UIColor.black), for: .normal)
    }
    
    @IBAction func crossButtonPressed(_ sender: UIButton) {
        
        if self.cellDiary != nil {
            self.cellDiary.deletePhotoCEll(tag: sender.tag,cell:self)
        }
        
    }
}
