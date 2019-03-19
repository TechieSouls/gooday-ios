//
//  DeleteCell.swift
//  Cenes
//
//  Created by Redblink on 16/10/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class DeleteCell: UITableViewCell {

    var gatheringView : CreateGatheringViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        //self.gatheringView.deleteGathering()
    }
}
