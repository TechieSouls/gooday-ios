//
//  ChoiceViewController+Facebook.swift
//  Deploy
//
//  Created by Cenes_Dev on 20/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FacebookCore


extension ChoiceViewController {
    
    
    ///FBSDKLoginButtonDelegate method implimentation
    
    
    
    
    func getFBUserInfo() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"id,name,email,gender,picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        request.start { (response, result) in
            switch result {
            case .success(let value):
                let dictValue = value.dictionaryValue
                let tokenStr = FBSDKAccessToken.current().tokenString
                imageFacebookURL = ((dictValue?["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
                let webServ = WebService()
                webServ.facebookSignUp(facebookAuthToken:tokenStr!, facebookID: dictValue?["id"]! as! String , complete: { (returnedDict) in
                    
                    if returnedDict.value(forKey: "Error") as? Bool == true {
                        self.showAlert(title: "Error", message:(returnedDict["ErrorMsg"] as? String)!)
                        
                    }
                    else{
                        
                        
                        setting.setValue(2, forKey: "onboarding")
                        
                        
                        webServ.facebookEvent(facebookAuthToken: tokenStr!,cenesToken: setting.value(forKey: "token") as! String, facebookID: dictValue?["id"]! as! String, complete: { (returnedDict) in
                            
                            if returnedDict.value(forKey: "Error") as? Bool == true {
                                
                                self.showAlert(title: "Error", message:(returnedDict["ErrorMsg"] as? String)!)
                                
                            }
                            
                        })
                        let dict = returnedDict.value(forKey: "data") as? NSDictionary
                        
                        let isNew = dict?.value(forKey: "isNew") as? Bool
                        
                        if isNew != nil {
                            
                            DispatchQueue.main.async {
                                UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                                WebService().setPushToken()
                            }
                            
                            let url = dict?.value(forKey: "photo") as? String
                            if url != nil && url != "" {
                                if url != nil && url != "" {
                                    let webServ = WebService()
                                    webServ.profilePicFromFacebook(url: url!, completion: { image in
                                        DispatchQueue.main.async {
                                            print("Image Downloaded")
                                            appDelegate?.profileImageSet(image: image!)
                                            appDelegate?.cenesTabBar?.loadViewIfNeeded()
                                            let index = appDelegate?.cenesTabBar?.selectedIndex
                                            let navController = appDelegate?.cenesTabBar?.viewControllers?[index!] as! UINavigationController
                                            navController.viewControllers.first?.viewDidLayoutSubviews()
                                        }
                                    })
                                }
                            }
                        }else{
                            let camera = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onbooardingNavigation") as? UINavigationController
                            UIApplication.shared.keyWindow?.rootViewController = camera
                        }
                    }
                    
                })
                break
            case .failed(let error):
                print(error)
            }
        }
    }

}
