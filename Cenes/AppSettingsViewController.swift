//
//  AppSettingsViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class AppSettingsViewController: UIViewController {

    @IBOutlet weak var deleteAccountView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = themeColor;
        self.title = "App Settings";
        self.tabBarController?.tabBar.isHidden = true;
        
        let deleteTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(deleteBarPressed));
        deleteAccountView.addGestureRecognizer(deleteTapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar();
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.isHidden = false;
        
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "abondan_event_icon"), for: UIControlState.normal)
        backButton.setImage(#imageLiteral(resourceName: "abondan_event_icon"), for: UIControlState.selected)
        backButton.addTarget(self, action:#selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        backButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        let backBarButton = UIBarButtonItem.init(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = backBarButton
    }

    @objc func deleteBarPressed() {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "AppSettingsEditViewController") as! AppSettingsEditViewController;
        self.navigationController?.pushViewController(navController, animated: true);
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
    }
}
