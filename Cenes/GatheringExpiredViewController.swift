//
//  GatheringExpiredViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 09/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import SideMenu

class GatheringExpiredViewController: UIViewController {
    
    @IBOutlet weak var profileBtn: UIImageView!
    
    @IBOutlet weak var btnCreateNewGath: UIButton!
    
    @IBOutlet weak var homeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavBar();
        // Do any additional setup after loading the view.
        self.btnCreateNewGath.setTitleColor(cenesLabelBlue, for: .normal);
        self.btnCreateNewGath.layer.cornerRadius = 40;
        
        profileBtn.setRounded();
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        if (loggedInUser.photo != nil) {
            profileBtn.sd_setImage(with: URL(string: loggedInUser.photo), placeholderImage: UIImage(named: defaultProfileImage));
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileBtnClicked(tapGestureRecognizer:)))
        profileBtn.isUserInteractionEnabled = true
        profileBtn.addGestureRecognizer(tapGestureRecognizer)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavBar()
    }
    
    func setupNavBar() -> Void {
        self.navigationController?.isNavigationBarHidden = true;
    }
    @objc func profileBtnClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    @IBAction func homeBtnClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnCreateNewGathListener(_ sender: Any) {
        let createGatheringView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createGathering") as! CreateGatheringViewController
        self.navigationController?.pushViewController(createGatheringView, animated: true)
        

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
