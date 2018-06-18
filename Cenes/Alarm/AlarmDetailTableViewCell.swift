//
//  AlarmDetailTableViewCell.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/18/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class AlarmDetailTableViewCell: UITableViewCell {

    var headerLabel: UILabel!
    var infoLabel: UILabel!
    
    let defaultFont = UIFont.systemFont(ofSize: 14)
//    alpha:CGFloat? = 1.0
    fileprivate func createLabel(with text: String, alignment: NSTextAlignment, font: UIFont? = UIFont.systemFont(ofSize: 14)) -> UILabel {
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = alignment
        label.text = text
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createViews() {
        if headerLabel == nil {
            headerLabel = createLabel(with: "Repeat", alignment:.left)
        }
        self.addSubview(headerLabel)
        
        if infoLabel == nil {
            infoLabel = createLabel(with: "M T W T F S S", alignment: .right)
        }
        self.addSubview(infoLabel)
    }
    
    func createConstraints() {
        let viewsDict: [String: Any] = ["Header": headerLabel, "InfoLabel": infoLabel]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[Header]-10@200-[InfoLabel]-35-|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        
        self.addConstraint(NSLayoutConstraint.init(item: infoLabel, attribute: .centerY, relatedBy: .equal, toItem: headerLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[Header]-|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))

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
