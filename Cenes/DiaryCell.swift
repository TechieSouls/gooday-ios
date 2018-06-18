//
//  DiaryCell.swift
//  Cenes
//
//  Created by Redblink on 14/11/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet weak var DiaryImage: UIImageView!
    
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var diaryTitle: UILabel!
    
    
    @IBOutlet weak var diaryDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        borderView.layer.borderWidth = 2
    }
    
    
}
