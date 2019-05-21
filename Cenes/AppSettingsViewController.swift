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
        let deleteTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(deleteBarPressed));
        deleteAccountView.addGestureRecognizer(deleteTapGesture)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func deleteBarPressed() {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "AppSettingsEditViewController") as! AppSettingsEditViewController;
        self.navigationController?.pushViewController(navController, animated: true);
    }
}
