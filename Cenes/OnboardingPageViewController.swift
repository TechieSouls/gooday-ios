//
//  OnboardingPageViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 05/06/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var getStartedBtnView: UIView!
    @IBOutlet weak var getStartedBtn: UIButton!
    
    var pageViewController : UIPageViewController!;
    let onboardingImages = ["onboarding_step1", "onboarding_step2", "onboarding_step3"];
    
    class func MainViewController() -> OnboardingPageViewController {
        let onboardingBoard: UIStoryboard = UIStoryboard.init(name: "Onboarding", bundle: nil);
        return onboardingBoard.instantiateViewController(withIdentifier: "OnboardingPageViewController") as! OnboardingPageViewController;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createPageViewController();
        setupPageControll();
        
        getStartedBtn.setTitleColor(UIColor.white, for: .normal)
        getStartedBtnView.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.2)
        getStartedBtnView.layer.shadowOffset = CGSize(width: 0, height: 5)
        getStartedBtnView.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
        getStartedBtnView.layer.shadowOpacity = 1
        getStartedBtnView.layer.shadowRadius = 10
        self.view.addSubview(getStartedBtnView)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func createPageViewController() {
        
        let onboardingBoard: UIStoryboard = UIStoryboard.init(name: "Onboarding", bundle: nil);
        let swipePageController = onboardingBoard.instantiateViewController(withIdentifier: "SwipePageController") as! UIPageViewController;
        
        swipePageController.dataSource = self;
        if (onboardingImages.count  > 0) {
         
            let firstController = getItemController(0)!
            let startingController = [firstController];
            swipePageController.setViewControllers(startingController, direction: .forward, animated: true, completion: nil)
        }
        
        pageViewController = swipePageController;
        addChildViewController(pageViewController);
        self.view.addSubview(pageViewController.view);
        //pageViewController.didMove(toParentViewController: self);
    }
    
    func setupPageControll() {
        
        let appearance = UIPageControl.appearance();
        appearance.backgroundColor = UIColor.black
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemViewController;
        print("Before : ",itemController.itemIndex)

        if (itemController.itemIndex > 0) {
            return getItemController(itemController.itemIndex-1);
        }
        
        return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        let itemController = viewController as! PageItemViewController;
        print("After : ",itemController.itemIndex)

        if (itemController.itemIndex < onboardingImages.count) {
            return getItemController(itemController.itemIndex+1);
        }
        
        return nil;
    }
    
    /*func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return onboardingImages.count;
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0;
    }*/
    
    func currentControllerIndex() -> Int {
        let pageItemController = self.currentControllerIndex();
        
        if let controller = pageItemController as? PageItemViewController {
            return controller.itemIndex;
        }
        return -1;
    }
    
    func currentController() -> UIViewController? {
        
        if (self.pageViewController.viewControllers!.count > 0) {
            return self.pageViewController.viewControllers![0]
        }
        return nil;
    }
    
    func getItemController(_ itemIndex: Int) -> PageItemViewController? {
    
        if (itemIndex < onboardingImages.count) {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PageItemViewController") as! PageItemViewController;
            viewController.itemIndex = itemIndex;
            viewController.imageName = onboardingImages[itemIndex];
            return viewController;
        }
        
        return nil;
    }
    
    
    @IBAction func getStartedPressed(_ sender: Any) {
        
        setting.setValue(UserSteps.OnBoardingScreens, forKey: "footprints")
        UIApplication.shared.keyWindow?.rootViewController = PhoneVerificationStep1ViewController.MainViewController()

    }
}
