//
//  MeTimeDaysView.swift
//  Cenes
//
//  Created by Cenes_Dev on 29/04/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MeTimeDaysView: UIView {

    @IBOutlet weak var sunday: UIButton!
    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!

    @IBOutlet weak var startTimeView: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!

    @IBOutlet weak var endTimeView: UIView!
    @IBOutlet weak var endTimeLabel: UILabel!

    var metimeAddViewController: MeTimeAddViewController!;
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MeTimeDaysView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MeTimeDaysView
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        startTimeView.layer.borderWidth = 2;
        startTimeView.layer.borderColor = UIColor.white.cgColor;
        startTimeView.layer.cornerRadius = 25;
        
        endTimeView.layer.borderWidth = 2;
        endTimeView.layer.borderColor = UIColor.white.cgColor;
        endTimeView.layer.cornerRadius = 25;
    }
    
    @IBAction func dayCirclePressed(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        switch button.tag {
        case 0:
            metimeAddViewController.handleDayCirclePressed(button: button, label: "Sunday");
            break;
        case 1:
            metimeAddViewController.handleDayCirclePressed(button: button, label: "Monday");
            break;
        case 2:
            metimeAddViewController.handleDayCirclePressed(button: button, label: "Tuesday");
            break;
        case 3:
            metimeAddViewController.handleDayCirclePressed(button: button, label: "Wednesday");
            break;
        case 4:
            metimeAddViewController.handleDayCirclePressed(button: button, label: "Thursday");
            break;
        case 5:
            metimeAddViewController.handleDayCirclePressed(button: button, label: "Friday");
            break;
        case 6:
            metimeAddViewController.handleDayCirclePressed(button: button, label: "Saturday");
            break;
        default:
            print("Unknown language")
            return
        }
    }
}
