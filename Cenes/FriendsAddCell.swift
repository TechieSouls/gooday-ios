//
//  FriendsAddCell.swift
//  Cenes
//
//  Created by Redblink on 24/11/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class FriendsAddCell: UICollectionViewCell {
    
    var createDiary : CreateDiaryViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addPressed(_ sender: Any) {
        if createDiary != nil {
            createDiary.addFriendsButton()
        }
    }
}
