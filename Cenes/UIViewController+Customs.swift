//
//  UIViewController+Customs.swift
//  Deploy
//
//  Created by Cenes_Dev on 09/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import MessageUI

extension UIViewController {
    
    func errorAlert(message: String) -> Void {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func hideKeyboardWhenTappedOnTableviewAround(tableViewArea: UITableView) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableViewArea.addGestureRecognizer(tap)
    }
    
    func isEmailValid(email: String) -> Bool{
        var emailRegex = "";
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-200, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastWithoutDuration(message : String) -> UILabel {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-200, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        return toastLabel;
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    public func addActionSheetForiPad(actionSheet: UIAlertController) {
        if let popoverPresentationController = actionSheet.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
    }
    
    func helpAndFeedbackIconPressed(mfMailComposerDelegate: MFMailComposeViewControllerDelegate) {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let faqAction: UIAlertAction = UIAlertAction(title: "FAQ", style: .default) { action -> Void in
            //self.selectPicture();
            //if let requestUrl = NSURL(string: "\(faqLink)") {
                //UIApplication.shared.openURL(requestUrl as URL)
                UIApplication.shared.open(URL.init(string: faqLink)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([String:Any]()), completionHandler: nil);
            }
        
        let handfAction: UIAlertAction = UIAlertAction(title: "Help & Feedback", style: .default) { action -> Void in
            
            let iphoneDetails = "\(UIDevice.modelName) \(UIDevice.current.systemVersion)";
            
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = mfMailComposerDelegate
                mail.setToRecipients(["support@cenesgroup.com"])
                mail.setMessageBody("\(iphoneDetails) \n", isHTML: false)
                self.present(mail, animated: true, completion: nil)
            } else {
                print("Cannot send mail")
                // give feedback to the user
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        //cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(faqAction)
        actionSheetController.addAction(handfAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        addActionSheetForiPad(actionSheet: actionSheetController)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    var profilePicTapGuesture: UITapGestureRecognizer {
        return UITapGestureRecognizer.init(target: self, action: #selector(profilePicTapped(sender:)))
    };
    
    @objc func profilePicTapped(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        if (sender.view?.tag == -1) {
            newImageView.tag = -1;
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        if (sender.view?.tag != -1) {
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        if (sender.view?.tag != -1) {
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
        }
        sender.view?.removeFromSuperview()
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    class GatheringTapGesture: UITapGestureRecognizer {
        var chatMessage: String!;
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
