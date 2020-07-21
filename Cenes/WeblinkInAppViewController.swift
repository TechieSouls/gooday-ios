//
//  WeblinkInAppViewController.swift
//  Cenes
//
//  Created by Cenes_Dev on 14/07/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import WebKit

class WeblinkInAppViewController: UIViewController, WKNavigationDelegate {

    let webView = WKWebView()
    var urlToOpen: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.frame = CGRect.init(x: view.frame.origin.x, y: 70, width: view.frame.width, height: view.frame.height);
        webView.navigationDelegate = self

        self.navigationController?.navigationBar.isHidden = false;
        //setupNavBar();
        let url = URL(string: urlToOpen)!
        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(webView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupNavBar()-> Void{
                
        self.navigationController?.navigationBar.backgroundColor = themeColor;
        
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage(named: "abondan_event_icon"), for: .normal)
        backButton.frame = CGRect.init(x: 0, y: 0, width: 20, height: 25)
        backButton.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        backButton.addTarget(self, action: #selector(ivBackButtonPressed), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem.init(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }

    @objc func ivBackButtonPressed() {
        self.navigationController?.popViewController(animated: true);
    }
}
