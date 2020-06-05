//
//  CenesTabController.swift
//  Cenes
//
//  Created by Redblink on 02/11/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import SideMenu

@available(iOS 11.0, *)
class CenesTabController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate?.cenesTabBar = self
        
        if SideMenuManager.default.menuLeftNavigationController == nil {
            //let leftMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        
           // SideMenuManager.default.menuLeftNavigationController = leftMenu
        }else{
            
            //let pvc = SideMenuManager.default.menuLeftNavigationController?.presentedViewController
              SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: false, completion: nil)
            
            //let leftMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
            
            //SideMenuManager.default.menuLeftNavigationController = leftMenu
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let home = (self.viewControllers![0] as? UINavigationController)?.viewControllers.first as? HomeViewController
                home?.viewDidAppear(true)
            }
            
           // leftMenu.present(pvc!, animated: true, completion: nil)
        }
            
        //SideMenuManager.default.menuAddPanGestureToPresent(toView: (self.view)!)
        //SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: (self.view)!)
        
        SideMenuManager.default.menuWidth = 300
        
        
        // Set up a cool background image for demo purposes
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor(red: 241.0, green: 241.0, blue: 241.0, alpha: 1.0)
        
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        //
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
