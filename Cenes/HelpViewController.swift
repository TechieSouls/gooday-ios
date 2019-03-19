//
//  HelpViewController.swift
//  Cenes
//
//  Created by Macbook on 30/07/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Instabug
import SideMenu

class HelpViewController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var faqBannerView: UIImageView!
    @IBOutlet weak var reportBtn: UIButton!
    
    var fromSideMenu = false
    var loggedInUser: User!;
    var profileImage = UIImage(named: "profile icon");
    var image: UIImage!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = themeColor;
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        if(self.image == nil) {
            if self.loggedInUser.photo != nil {
                let webServ = WebService()
                webServ.profilePicFromFacebook(url:  String(self.loggedInUser.photo), completion: { image in
                    self.profileImage = image
                    self.setUpNavBar()
                })
            }
        } else {
            self.profileImage? = image
            self.setUpNavBar();
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action:  #selector(self.ImageTapped));
        self.faqBannerView.addGestureRecognizer(tapGesture);
        
        self.reportBtn.setTitleColor(cenesLabelBlue, for: .normal);
        self.reportBtn.layer.cornerRadius = 30;
        self.reportBtn.layer.borderColor = cenesLabelBlue.cgColor;
        self.reportBtn.layer.borderWidth = 2.0
        
    }
    
    @IBAction func reportButtonPressed(_ sender: Any) {
        BugReporting.promptOptions = [IBGPromptOption.bug, IBGPromptOption.feedback];
        BugReporting.invoke();
    }
    
    @objc func ImageTapped() {
        let url = URL(string: faqLink)
        UIApplication.shared.open(url!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavBar();
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        if self.loggedInUser.photo != nil {
            let webServ = WebService()
            webServ.profilePicFromFacebook(url:  String(self.loggedInUser.photo), completion: { image in
                self.profileImage = image
                self.setUpNavBar()
            })
        }
        
    }
    
    func setUpNavBar(){
        
        let profileButton = UIButton.init(type: .custom)
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.setImage(self.profileImage, for: UIControlState.normal)
        profileButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        profileButton.layer.cornerRadius = profileButton.frame.height/2
        profileButton.clipsToBounds = true
        profileButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        profileButton.backgroundColor = UIColor.white
        
        let barButton = UIBarButtonItem.init(customView: profileButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        let homeButton = UIButton.init(type: .custom)
        homeButton.setImage(UIImage(named: "homeSelected"), for: .normal)
        homeButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        homeButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem.init(customView: homeButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func homeButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func profileButtonPressed(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
}


