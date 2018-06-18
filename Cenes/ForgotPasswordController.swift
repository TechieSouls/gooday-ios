//
//  ForgotPasswordController.swift
//  Cenes
//
//  Created by Redblink on 16/01/18.
//  Copyright © 2018 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ForgotPasswordController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        
        emailTF.resignFirstResponder()
        
        if Util.isValidEmail(testStr: emailTF.text!){
            // call webservice
            startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
            
            WebService().resetPassword(email: emailTF.text!, complete: { (returnedDict) in
                self.stopAnimating()
                if returnedDict.value(forKey: "Error") as? Bool == true {
                    
                    self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                    
                }else{
                    
                    let alertController = UIAlertController(title: "Email Sent", message: "Reset Password link has been sent to your Email", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                        print ("Ok")
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            
            
        }else{
            self.showAlert(title: "Validation", message: "Please enter valid email")
        }
        
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
