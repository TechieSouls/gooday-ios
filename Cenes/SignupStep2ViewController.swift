//
//  SignupStep2ViewController.swift
//  Cenes
//
//  Created by Macbook on 23/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SignupStep2ViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var keyPadView: UIView!
    
    @IBOutlet weak var lblBox1: UILabel!
    
    @IBOutlet weak var lblBox2: UILabel!
    
    @IBOutlet weak var lblBox3: UILabel!
    
    @IBOutlet weak var lblBox4: UILabel!

    @IBOutlet weak var verificationCodeGuideText: UILabel!
    
    var userService: UserService = UserService();
    var verificationCode: String = "";
    var countryCode: String = "";
    var phoneNumber: String = "";
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // self.view.addSubview(keyPadView);
        //self.setupAutoLayout();
        self.hideKeyboardWhenTappedAround();
        
        self.intializeComponents();
        
        self.userService = UserService();
        self.verificationCodeGuideText.text = "Please type the verification code sent to \(phoneNumber).";

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func intializeComponents() {
        
        self.lblBox1.textAlignment = .center;
        self.lblBox2.textAlignment = .center;
        self.lblBox3.textAlignment = .center;
        self.lblBox4.textAlignment = .center;
        
        self.lblBox1.textColor = UIColor.white;
        self.lblBox2.textColor = UIColor.white;
        self.lblBox3.textColor = UIColor.white;
        self.lblBox4.textColor = UIColor.white;
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

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
