//
//  AlarmInfoTableViewCell.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/19/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class AlarmInfoTableViewCell: UITableViewCell {

    var alarmInfoLabel: UILabel!
    var bottomSeperator: UILabel!
    
    func createViews() {
        
        if alarmInfoLabel == nil {
            alarmInfoLabel = UILabel.init(frame: CGRect.zero)
            alarmInfoLabel.translatesAutoresizingMaskIntoConstraints = false
            alarmInfoLabel.textColor = UIColor.gray
        }
        self.addSubview(alarmInfoLabel)
        
        if bottomSeperator == nil {
            bottomSeperator = UILabel.init(frame: CGRect.zero)
            bottomSeperator.translatesAutoresizingMaskIntoConstraints = false
            bottomSeperator.backgroundColor = UIColor.gray
        }
        self.addSubview(bottomSeperator)
    }
    
    func createConstraints() {
        let viewsDict: [String: Any] = ["Label": alarmInfoLabel, "BottomSeperator": bottomSeperator]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[Label]-20-|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[BottomSeperator]|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[Label]-2-|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        
        self.addConstraint(NSLayoutConstraint.init(item: bottomSeperator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))

        self.addConstraint(NSLayoutConstraint.init(item: bottomSeperator, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -1))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
