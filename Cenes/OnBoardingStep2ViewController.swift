//
//  OnBoardingStep2ViewController.swift
//  Cenes
//
//  Created by Macbook on 17/08/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class OnBoardingStep2ViewController: UIViewController {

    
    @IBOutlet weak var step2Title: UILabel!
    
    @IBOutlet weak var step2Description: UILabel!
    
    @IBOutlet weak var borderBottom: UIView!
    
    class func MainViewController() -> UIViewController{
        
        let viewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingStep2ViewController")
        
        return viewController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        step2Title.text = onboardingStep2Title;
        step2Title.fs_top = 80
        step2Title.fs_left = 16;
        step2Title.fs_right = 50;
        step2Title.textColor = UIColor.white
        step2Title.adjustsFontSizeToFitWidth  = true
        step2Title.font = step2Title.font.withSize(40)
        step2Title.sizeToFit()
        
        
        step2Description.text = onboardingStep2Desc;
        //step2Description.fs_top = 200
        //step2Description.fs_left = 30;
        //step2Description.fs_right = 50;

        step2Description.frame = CGRect(x: 30, y: 200, width: self.view.bounds.width - 50, height: 400)
        step2Description.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        step2Description.font =  step2Description.font.withSize(20)
        
        step2Description.numberOfLines = 0;
        step2Description.textColor = UIColor.white
        step2Description.adjustsFontSizeToFitWidth  = true
        step2Description.font = step2Description.font.withSize(20)
        step2Description.sizeToFit()
        step2Description.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    
        borderBottom.frame = CGRect(0,self.view.bounds.height - 60, self.view.bounds.width, 1.0)
        borderBottom.backgroundColor = UIColor.white

        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    */

}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat)
    {
        self.init(x:x, y:y, width:w, height:h)
    }
}
