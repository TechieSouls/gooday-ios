//
//  OnBoardingStep1ViewController.swift
//  Cenes
//
//  Created by Macbook on 17/08/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class OnBoardingStep1ViewController: UIViewController {

    @IBOutlet weak var bottomBOrder: UIView!
    class func MainViewController() -> UIViewController{
        
        let viewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingStep1ViewController")
        
        return viewController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomBOrder.frame = CGRect(0,self.view.bounds.height - 60, self.view.bounds.width, 1.0)
        bottomBOrder.backgroundColor = UIColor.white
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

extension UIImage {
    func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    
    func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
    
}

