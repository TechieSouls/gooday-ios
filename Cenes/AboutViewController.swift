//
//  AboutViewController.swift
//  Cenes
//
//  Created by Macbook on 11/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import SideMenu

class AboutViewController: UIViewController {

    @IBOutlet weak var versionUpdateBtn: UIButton!
    @IBOutlet weak var versionCurrentText: UILabel!
    
    var loggedInUser: User!;
    var profileImage = UIImage(named: "profile icon");
    var image: UIImage!;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = themeColor;
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        
        // Do any additional setup after loading the view.
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionCurrentText.text = "Version "+(version);
            
        }
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

    @IBAction func versionUpdateBtbPressed(_ sender: UIButton) {
        if let url = URL(string: aboutUsVersionUpdateLink) {
            UIApplication.shared.open(url)
        }
    }
    
    func setUpNavBar(){
        
        let profileButton = UIButton.init(type: .custom)
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.setImage(self.profileImage, for: UIControl.State.normal)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
