//
//  OnboardingStep5ViewController.swift
//  Cenes
//
//  Created by Macbook on 18/08/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class OnboardingStep5ViewController: UIViewController {
    @IBOutlet weak var step5title: UILabel!
    
    @IBOutlet weak var borderBottom: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        step5title.text = onboardingStep5Title;
        step5title.fs_top = 276
        step5title.fs_left = 13;
        step5title.fs_right = 13;
        step5title.textColor = UIColor.white
        step5title.adjustsFontSizeToFitWidth  = true
        step5title.font = step5title.font.withSize(40)
        step5title.sizeToFit()
        // Do any additional setup after loading the view.
        
        borderBottom.frame = CGRect( 0,  self.view.bounds.height - 60, self.view.bounds.width, 1.0)
        borderBottom.backgroundColor = UIColor.white
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
