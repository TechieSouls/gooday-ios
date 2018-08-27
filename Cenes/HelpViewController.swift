//
//  HelpViewController.swift
//  Cenes
//
//  Created by Macbook on 30/07/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class HelpViewController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var helpFeedbackButtonBlock: UIImageView!
    
    @IBOutlet weak var helpFeedbackCloseBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        self.navigationItem.hidesBackButton = true;
        self.helpFeedbackButtonBlock.isUserInteractionEnabled = true;
        
        let TapGesture = UITapGestureRecognizer(target: self, action:  #selector(self.ImageTapped));
        self.helpFeedbackButtonBlock.addGestureRecognizer(TapGesture)
        
        self.helpFeedbackCloseBtn.isUserInteractionEnabled = true;
        let closeTappedGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeButtonTapped));
        self.helpFeedbackCloseBtn.addGestureRecognizer(closeTappedGesture);
    }
    
    @objc func closeButtonTapped() {
        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
    }
    
    @objc func ImageTapped() {
        if let url = URL(string: "https://m.me/cenesapp?utm_source=CenesApp&utm_medium=feedback&utm_campaign=FeedbackScreen") {
            UIApplication.shared.open(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}


