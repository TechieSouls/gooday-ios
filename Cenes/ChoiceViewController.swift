//
//  ChoiceViewController.swift
//  Cenes
//
//  Created by Macbook on 15/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController {

    @IBOutlet weak var signupMobileBtn: UIButton!
    
    @IBOutlet weak var firstViewContainer: UIView!
    
    @IBOutlet weak var secondViewContainer: UIView!
    
    
    @IBOutlet weak var threeButtonsView: UIView!
    
    @IBOutlet weak var facebookViewBtn: UIView!
    
    @IBOutlet weak var googleViewBtn: UIView!
    
    @IBOutlet weak var emailViewBtn: UIView!
    
    @IBOutlet weak var termsAndConditionsText: UILabel!
    
    class func MainViewController() -> UINavigationController{
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav") as! UINavigationController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.firstViewContainer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2)
        //self.secondViewContainer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2)
        
        // Do any additional setup after loading the view.
        /*self.signupMobileBtn.layer.borderColor = UIColor.orange.cgColor
        self.signupMobileBtn.layer.borderWidth = 1
        self.signupMobileBtn.layer.cornerRadius = 20*/
        
        facebookViewBtn.roundedView();
        googleViewBtn.roundedView();
        emailViewBtn.roundedView();
        
        let threeButtonsViewGradient = CAGradientLayer()
        threeButtonsViewGradient.frame = CGRect.init(0, 0, threeButtonsView.frame.width, 1)
        threeButtonsViewGradient.colors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor(red:0.91, green:0.49, blue:0.48, alpha:0.75).cgColor, UIColor(red:0.78, green:0.42, blue:0.74, alpha:0.75).cgColor, UIColor.white.cgColor]
        threeButtonsViewGradient.startPoint = CGPoint(x: 0, y: 1);
        threeButtonsViewGradient.endPoint = CGPoint(x: 1, y: 1);
        
        threeButtonsView.layer.insertSublayer(threeButtonsViewGradient, at: 0);
        
        
        let facebookTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(facebookViewPressed));
        facebookViewBtn.addGestureRecognizer(facebookTapGesture);
        
        let googleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(googleViewPressed));
        googleViewBtn.addGestureRecognizer(googleTapGesture);
        
        let emailTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(emailViewPressed));
        emailViewBtn.addGestureRecognizer(emailTapGesture);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.firstViewContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/5)
        //self.secondViewContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
        
        PhonebookService.getPermissionForContacts();
        
        //navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = themeColor;
        self.navigationController?.navigationBar.isHidden = true;

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 248.0/255.0, green: 159.0/255.0, blue: 30.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 142.0/255.0, green: 115.0/255.0, blue: 179.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func facebookViewPressed() {
        
    }
    
    @objc func googleViewPressed() {
        
    }
    
    @objc func emailViewPressed() {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "SignupSuccessViewController") as! SignupSuccessViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }

}
