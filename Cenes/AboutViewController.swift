//
//  AboutViewController.swift
//  Cenes
//
//  Created by Macbook on 11/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var versionUpdateBtn: UIButton!
    
    @IBOutlet weak var aboutUsCloseBtn: UIImageView!
    
    @IBOutlet weak var versionCurrentText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.versionUpdateBtn.layer.shadowOpacity = 0.1
        self.versionUpdateBtn.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        self.aboutUsCloseBtn.isUserInteractionEnabled = true;
        let closeTappedGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeButtonTapped));
        
        self.aboutUsCloseBtn.addGestureRecognizer(closeTappedGesture);
        
        // Do any additional setup after loading the view.
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionCurrentText.text = "Version "+(version);
            
        }
        
       // self.versionUpdateBtn.frame = CGRect(x: 0, y: self.view.bounds.height/2 - 50, width: self.view.bounds.width, height: 50)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func versionUpdateBtbPressed(_ sender: UIButton) {
        if let url = URL(string: aboutUsVersionUpdateLink) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func closeButtonTapped() {
        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
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
