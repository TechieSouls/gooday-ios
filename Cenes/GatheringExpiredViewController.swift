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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBar();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavBar()
    }
    
    func setupNavBar() -> Void {
        self.navigationController?.navigationBar.isHidden = true;
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    @IBAction func backArrowPessed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCreateNewGathListener(_ sender: Any) {
        let createGatheringView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
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
