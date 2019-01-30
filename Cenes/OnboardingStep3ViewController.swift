//
//  OnboardingStep3ViewController.swift
//  Cenes
//
//  Created by Macbook on 18/08/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class OnboardingStep3ViewController: UIViewController {

    @IBOutlet weak var Step3Title: UILabel!
    
    @IBOutlet weak var Step3Description: UILabel!
    @IBOutlet weak var borderBottom: UIView!
    
    class func MainViewController() -> UIViewController{
        
        let viewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingStep2ViewController")
        
        return viewController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        Step3Title.text = onboardingStep3Title;
        Step3Title.frame = CGRect(x: 40, y: 100, width: 300, height: 400)

        //Step3Title.fs_top = 80
        
        Step3Title.textColor = UIColor.white
        Step3Title.adjustsFontSizeToFitWidth  = true
        Step3Title.font = Step3Title.font.withSize(35)
        Step3Title.sizeToFit()
        Step3Title.numberOfLines = 0;
        
        
        Step3Description.text = onboardingStep3Desc;
        //Step3Description.fs_top = 392
        //Step3Description.fs_left = 16;
        Step3Description.frame = CGRect(x: 30, y: self.view.bounds.height - 330, width: self.view.bounds.width - 40, height: 400)
        Step3Description.padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        Step3Description.font =  Step3Description.font.withSize(26)
        Step3Description.numberOfLines = 0;
        Step3Description.textColor = UIColor.white
        Step3Description.adjustsFontSizeToFitWidth  = true
        Step3Description.sizeToFit()
        Step3Description.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        
        borderBottom.frame = CGRect(0,self.view.bounds.height - 60, self.view.bounds.width, 1.0)
        borderBottom.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


