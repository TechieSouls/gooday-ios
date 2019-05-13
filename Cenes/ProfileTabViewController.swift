//
//  ProfileTabViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 27/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import MessageUI

class ProfileTabViewController: UIViewController, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var eventAttendedCountsView: UIView!
    
    @IBOutlet weak var eventHostedCount: UILabel!
    
    
    @IBOutlet weak var eventHostedCountView: UIView!
    
    @IBOutlet weak var eventAttenedCount: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var profileDtos = [ProfileDto]();
    var loggedInUser: User = User();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profilePic.setRounded()
        
        let curvedPercent: CGFloat = 0.08;
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:topView.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:topView.bounds.size.width, y: (topView.bounds.size.height - (topView.bounds.size.height * curvedPercent))))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:topView.bounds.size.height - (topView.bounds.size.height*curvedPercent)), controlPoint: CGPoint(x:topView.bounds.size.width/2, y:topView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        let shapeLayer = CAShapeLayer(layer: topView.layer)
        shapeLayer.path = arrowPath.cgPath
        shapeLayer.frame = topView.bounds
        shapeLayer.masksToBounds = true
        topView.layer.mask = shapeLayer
        topView.backgroundColor = themeColor;
        
        /*eventHostedCountView.layer.borderColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1).cgColor;
        eventHostedCountView.layer.borderWidth = 5;
        eventHostedCountView.layer.cornerRadius = eventHostedCountView.frame.height/2
        
        eventHostedCountView.layer.masksToBounds = false
        eventHostedCountView.layer.shadowColor = UIColor.gray.cgColor
        eventHostedCountView.layer.shadowOpacity = 1
        eventHostedCountView.layer.shadowOffset = CGSize(width: -1, height: 1)
        eventHostedCountView.layer.shadowRadius = 5

        eventAttendedCountsView.layer.borderColor = UIColor(red:0.93, green:0.61, blue:0.15, alpha:1).cgColor;
        eventAttendedCountsView.layer.borderWidth = 5;
        eventAttendedCountsView.layer.cornerRadius = eventAttendedCountsView.frame.height/2
        
        eventAttendedCountsView.layer.masksToBounds = false
        eventAttendedCountsView.layer.shadowColor = UIColor.gray.cgColor
        eventAttendedCountsView.layer.shadowOpacity = 1
        eventAttendedCountsView.layer.shadowOffset = CGSize(width: -1, height: 1)
        eventAttendedCountsView.layer.shadowRadius = 5*/
        
        profileTableView.register(UINib.init(nibName: "PeronalDetailsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PeronalDetailsTableViewCell");
        
        
        
        var profileDto = ProfileDto();
        profileDto.img = "personal_details_icon";
        profileDto.title = "Personal Details";
        profileDto.desc = "Username, Email, Password, Phone, DOB";
        profileDtos.append(profileDto);
        
        profileDto = ProfileDto();
        profileDto.img = "my_calendar_icon";
        profileDto.title = "My Calendars";
        profileDto.desc = "Calendar Sync, Holiday Calendar";
        profileDtos.append(profileDto);
        
        profileDto = ProfileDto();
        profileDto.img = "app_settings_icon";
        profileDto.title = "Personal Details";
        profileDto.desc = "Connected Accounts, Delete Account";
        profileDtos.append(profileDto);
        
        profileDto = ProfileDto();
        profileDto.img = "need_help_icon";
        profileDto.title = "Need Help?";
        profileDto.desc = "FAQ, Help & Feedback";
        profileDtos.append(profileDto);

    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true;
        self.tabBarController?.tabBar.isHidden = false;
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);

        var profilePicTapGesture = UITapGestureRecognizer.init(target: self, action: Selector("profilePicTapped"));
        profilePic.addGestureRecognizer(profilePicTapGesture);
        profilePic.sd_setImage(with: URL(string: loggedInUser.photo!), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
        
        profileName.text = loggedInUser.name;
        
        if (Connectivity.isConnectedToInternet) {
            let queryStr = "userId=\(String(loggedInUser.userId!))";
            UserService().findUserStatsByUserId(queryStr: queryStr, token: loggedInUser.token, complete: {(response) in
                let success = response.value(forKey: "success") as! Bool;
                if (success == true) {
                    let userStat = response.value(forKey: "data") as! NSDictionary;
                    self.eventHostedCount.text = "\(String(userStat.value(forKey: "eventsHostedCounts") as! Int64))";
                    self.eventAttenedCount.text = "\(String(userStat.value(forKey: "eventsAttendedCounts") as! Int64))";
                } else {
                    let message = response.value(forKey: "message") as! String;
                    self.errorAlert(message: message)
                }
            })
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func profilePicTapped() {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let removePhotoAction: UIAlertAction = UIAlertAction(title: "Remove Current Photo", style: .destructive) { action -> Void in
            //self.selectPicture();
        }
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            //self.takePicture();
        }
        takePhotoAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Choose from Library", style: .default) { action -> Void in
            //self.takePicture();
        }
        uploadPhotoAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        //cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(removePhotoAction)
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(uploadPhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }

}
