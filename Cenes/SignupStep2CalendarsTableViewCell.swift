//
//  SignupStep2CalendarsTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 13/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class SignupStep2CalendarsTableViewCell: UITableViewCell, SignupStep2CalendarsTableViewProtocol {


    @IBOutlet weak var leftSeparator: UIView!
    
    @IBOutlet weak var rightSeparator: UIView!
    
    @IBOutlet weak var googleBubbleView: UIView!
    
    @IBOutlet weak var googleGradientBubbleView: UIView!
    
    
    @IBOutlet weak var outlookBubbleView: UIView!
    
    @IBOutlet weak var outlookGradientBubbleView: UIView!
    
    
    @IBOutlet weak var appleBubbleView: UIView!
    @IBOutlet weak var appleGradientBubbleView: UIView!
    
    @IBOutlet weak var googleIcon: UIImageView!
    
    @IBOutlet weak var outlookIcon: UIImageView!
    
    @IBOutlet weak var appleIcon: UIImageView!
    
    var signupSuccessStep2ViewControllerDelegate: SignupSuccessStep2ViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let cgColors = [UIColor.white.cgColor, UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75).cgColor]
        leftSeparator.layer.insertSublayer(getViewBottomBorderGradient(uiView: leftSeparator, cgColors: cgColors), at: 0);
        
        let cgRightViewColors = [UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75).cgColor, UIColor.white.cgColor]
        rightSeparator.layer.insertSublayer(getViewBottomBorderGradient(uiView: rightSeparator, cgColors: cgRightViewColors), at: 0);
        
        
        
        googleBubbleView.roundedView();
        outlookBubbleView.roundedView();
        appleBubbleView.roundedView();
        googleGradientBubbleView.roundedView();
        outlookGradientBubbleView.roundedView();
        appleGradientBubbleView.roundedView();
        
        
        googleBubbleView.backgroundColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75)
        outlookBubbleView.backgroundColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75)
        appleBubbleView.backgroundColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75)
        
        /**  GOOGLE Gradient View **/
        googleGradientBubbleView.layer.shadowOffset = CGSize(width: 0, height: 1)
        googleGradientBubbleView.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
        googleGradientBubbleView.layer.shadowOpacity = 1
        googleGradientBubbleView.layer.shadowRadius = 3
        let gradient = CAGradientLayer()
        gradient.frame = googleGradientBubbleView.bounds;
        gradient.colors = [UIColor(red:0.78, green:0.42, blue:0.74, alpha:0.75).cgColor, UIColor(red:0.53, green:0.43, blue:0.67, alpha:0.75).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        googleGradientBubbleView.layer.addSublayer(gradient)
        googleGradientBubbleView.addSubview(googleIcon);
        
        
        /**  OUTLOOK Gradient View **/
        outlookGradientBubbleView.layer.shadowOffset = CGSize(width: 0, height: 1)
        outlookGradientBubbleView.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
        outlookGradientBubbleView.layer.shadowOpacity = 1
        outlookGradientBubbleView.layer.shadowRadius = 3
        
        let outlookGradient = CAGradientLayer()
        outlookGradient.frame = outlookGradientBubbleView.frame
        outlookGradient.colors = [
            UIColor(red:0.93, green:0.61, blue:0.15, alpha:0.75).cgColor,
            UIColor(red:0.91, green:0.49, blue:0.27, alpha:0.75).cgColor
        ]
        outlookGradient.locations = [0, 1]
        outlookGradient.startPoint = CGPoint(x: 0, y: 0.5)
        outlookGradient.endPoint = CGPoint(x: 1, y: 0.5)
        outlookGradientBubbleView.layer.addSublayer(outlookGradient)
        outlookGradientBubbleView.addSubview(outlookIcon)
        
        /***  APPLE Gradient View ***/
        appleGradientBubbleView.layer.shadowOffset = CGSize(width: 0, height: 1)
        appleGradientBubbleView.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
        appleGradientBubbleView.layer.shadowOpacity = 1
        appleGradientBubbleView.layer.shadowRadius = 3
        
        let appleGradient = CAGradientLayer()
        appleGradient.frame = appleGradientBubbleView.frame
        appleGradient.colors = [
            UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor,
            UIColor(red:0.12, green:0.18, blue:0.33, alpha:0.75).cgColor
        ]
        appleGradient.locations = [0, 1]
        appleGradient.startPoint = CGPoint(x: 0.5, y: 1)
        appleGradient.endPoint = CGPoint(x: 0.5, y: 0)
        appleGradientBubbleView.layer.addSublayer(appleGradient)
        appleGradientBubbleView.addSubview(appleIcon)
        
        
        let googleButtonTap = UITapGestureRecognizer.init(target: self, action: #selector(googleBubbleViewPressed));
        googleBubbleView.addGestureRecognizer(googleButtonTap);
        
        let oogleGradientButtonTap = UITapGestureRecognizer.init(target: self, action: #selector(googleBubbleViewPressed));
        googleGradientBubbleView.addGestureRecognizer(oogleGradientButtonTap);
        
        let outlookButtonTap = UITapGestureRecognizer.init(target: self, action: #selector(outlookBubbleViewPressed));
        outlookBubbleView.addGestureRecognizer(outlookButtonTap);
        
        let outlookGradientButtonTap = UITapGestureRecognizer.init(target: self, action: #selector(outlookBubbleViewPressed));
        outlookGradientBubbleView.addGestureRecognizer(outlookGradientButtonTap);
        
        let appleButtonTap = UITapGestureRecognizer.init(target: self, action: #selector(appleBubbleViewPressed));
        appleBubbleView.addGestureRecognizer(appleButtonTap);
        
        let appleGradientButtonTap = UITapGestureRecognizer.init(target: self, action: #selector(appleBubbleViewPressed));
        appleGradientBubbleView.addGestureRecognizer(appleGradientButtonTap);
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getViewBottomBorderGradient(uiView: UIView, cgColors: [CGColor]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect.init(0, uiView.frame.height-1, uiView.frame.width, 1)
        gradient.colors = cgColors
        gradient.startPoint = CGPoint(x: 0, y: 1);
        gradient.endPoint = CGPoint(x: 1, y: 1);
        return gradient;
    }
    
    func highlightCalendarCircles(calendar: String) {
        if (calendar == "Google") {
            googleBubbleView.isHidden = true;
            googleGradientBubbleView.isHidden = false;
        } else if (calendar == "Outlook"){
            outlookBubbleView.isHidden = true;
            outlookGradientBubbleView.isHidden = false;
        } else if (calendar == "Apple") {
            appleBubbleView.isHidden = true;
            appleGradientBubbleView.isHidden = false;
        }
    }
    
    
    @objc func googleBubbleViewPressed() {
        signupSuccessStep2ViewControllerDelegate.googleSyncBegins();
    }
    
    @objc func outlookBubbleViewPressed() {
       /* if (outlookBubbleView.isHidden == true) {
            outlookBubbleView.isHidden = false;
            outlookGradientBubbleView.isHidden = true;
        } else {
            outlookBubbleView.isHidden = true;
            outlookGradientBubbleView.isHidden = false;
        }*/
        signupSuccessStep2ViewControllerDelegate.outlookSyncBegins();

    }
    
    @objc func appleBubbleViewPressed() {
        signupSuccessStep2ViewControllerDelegate.appleSyncBegins();
    }
}
