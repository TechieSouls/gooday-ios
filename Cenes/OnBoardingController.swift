//
//  OnBoardingController.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/11/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit

//class OnBoardingController: UIViewController ,UIPageViewControllerDataSource ,UIPageViewControllerDelegate  {
class OnBoardingController: UIViewController ,UIPageViewControllerDataSource ,UIPageViewControllerDelegate  {
        
    var pageViewController : UIPageViewController!
    var pageIndex = 0
    var totalPages = 5;
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStarted: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    func getStepOne() -> OnBoardingStep1ViewController {
        return self.storyboard?.instantiateViewController(withIdentifier: "OnBoardingStep1ViewController") as! OnBoardingStep1ViewController
    }
    
    func getStepTwo() -> OnBoardingStep2ViewController {
        return self.storyboard?.instantiateViewController(withIdentifier: "OnBoardingStep2ViewController") as! OnBoardingStep2ViewController
    }
    
    func getStepThree() -> OnboardingStep3ViewController {
        return self.storyboard?.instantiateViewController(withIdentifier: "OnboardingStep3ViewController") as! OnboardingStep3ViewController
    }
    
    func getStepFour() -> OnboardingStep4ViewController {
        return self.storyboard?.instantiateViewController(withIdentifier: "OnboardingStep4ViewController") as! OnboardingStep4ViewController
    }
    func getStepFive() -> OnboardingStep5ViewController {
        return self.storyboard?.instantiateViewController(withIdentifier: "OnboardingStep5ViewController") as! OnboardingStep5ViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.titleLabel?.textColor = UIColor.white
        nextButton.titleLabel?.textColor = UIColor.white

        // Do any additional setup after loading the view.
        //  pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        setupPageControl()
        reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// This class is meant for Onbarding view controller instance.This is required for first time application launch
    ///
    /// - Returns: OnBoardingController
    
    class func onboardingViewController() -> OnBoardingController{
        return UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() as! OnBoardingController
    }
    
    
    /// This method is called for resetting the page inside UIPageViewControllerDataSource
    
    func reset()
    {
        /* Getting the page View controller */
        let pageContentViewController = self.viewControllerAtIndex(index: pageIndex)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.view.bringSubview(toFront: pageViewController.view)
        view.bringSubview(toFront: pageControl)
        
       // pageControl.currentPage = pageIndex
        view.bringSubview(toFront: getStarted)
        view.bringSubview(toFront: skipButton)
        view.bringSubview(toFront: nextButton)
        self.pageViewController.didMove(toParentViewController: self)
        //Button will show only in last page of onboarding page
      //  resetPageControl(index :pageIndex)
        
    }
    
    @IBAction func getStartedPressed(_ sender: Any) {
        setting.setValue(1, forKey: "onboarding")
        UIApplication.shared.keyWindow?.rootViewController = LoginViewController.MainViewController()
        
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        pageIndex = pageIndex + 1
        self.reset()
        
        resetPageControl(index : pageIndex)
        
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        setting.setValue(1, forKey: "onboarding")
        UIApplication.shared.keyWindow?.rootViewController = LoginViewController.MainViewController()
    }
    
    
    /// This function fills up with the data per page according to index
    ///
    /// - Parameter index: page index
    /// - Returns: pageContentViewController
    
    func viewControllerAtIndex(index : Int) ->UIViewController? {

      //  pageIndex = index
        
      //  resetPageControl(index: index)

        //let  pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        if (index == 0) {
             return getStepOne()
        } else if (index == 1) {
             return getStepTwo()
        } else if (index == 2) {
            return getStepThree()
        } else if (index == 3) {
            return getStepFour()
        } else if (index == 4) {
            return getStepFive()
        } /*else {
            pageContentViewController.imageName = images[index]
            pageContentViewController.titleText = pageTitles[index]
            pageContentViewController.descText =  pageDescs[index]
        }
        pageContentViewController.pageIndex = index
        pageIndex = index
        return pageContentViewController*/
        return getStepOne()
    }
    
    /// This method is called inside presentationCount for changing the appearance of page dot
    
    private func setupPageControl() {
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = commonColor
        pageControl.hidesForSinglePage = true
        
        pageControl.numberOfPages = totalPages
        
        resetPageControl(index : 0)
        
    }
    
    ///UIPageViewControllerDataSource ,UIPageViewControllerDelegate method implimentation
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
    
        var index = pageIndex
        
        if index < totalPages && index != 4{
            
            index = index + 1
            
            return self.viewControllerAtIndex(index: index)
        }
        
        return nil
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = pageIndex
        
        if index > 0 {
            
            index = index - 1
            
            return self.viewControllerAtIndex(index: index)
        }
        
        return nil
    }
    func resetPageControl(index :Int)
    {
        
         debugPrint("index: ", index)
        
         pageIndex = index

         pageControl.currentPage = index
        
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            
            skipButton.isHidden = true
            nextButton.isHidden = true
            pageControl.isHidden = true
            getStarted.isHidden = false
        }
        else{
            
            getStarted.isHidden = true
            pageControl.isHidden = false
            skipButton.isHidden = false
            nextButton.isHidden = false
        }
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(completed)
        {
            
        //   debugPrint(pageViewController.viewControllers!.first!.view.tag )
            
            resetPageControl(index : pageViewController.viewControllers!.first!.view.tag )
        }
    }
    
    

    
    
    
    /*override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //  pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        setupPageControl()
        reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// This class is meant for Onbarding view controller instance.This is required for first time application launch
    ///
    /// - Returns: OnBoardingController
    
    class func onboardingViewController() -> OnBoardingController{
        return UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() as! OnBoardingController
    }
    
    
    /// This method is called for resetting the page inside UIPageViewControllerDataSource
    
    func reset()
    {
        /* Getting the page View controller */
        let pageContentViewController = self.viewControllerAtIndex(index: pageIndex)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.view.bringSubview(toFront: pageViewController.view)
         view.bringSubview(toFront: pageControl)
         pageControl.numberOfPages = pageTitles.count
         pageControl.currentPage = pageIndex
        view.bringSubview(toFront: getStarted)
        view.bringSubview(toFront: skipButton)
        view.bringSubview(toFront: nextButton)
        self.pageViewController.didMove(toParentViewController: self)
        //Button will show only in last page of onboarding page
        resetPageControl(index :pageIndex)
        
    }
    
    @IBAction func getStartedPressed(_ sender: Any) {
        setting.setValue(1, forKey: "onboarding")
        UIApplication.shared.keyWindow?.rootViewController = LoginViewController.MainViewController()

    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        pageIndex = pageIndex + 1
        self.reset()
        
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        setting.setValue(1, forKey: "onboarding")
        UIApplication.shared.keyWindow?.rootViewController = LoginViewController.MainViewController()
    }
    
    
    /// This function fills up with the data per page according to index
    ///
    /// - Parameter index: page index 
    /// - Returns: pageContentViewController
    
    func viewControllerAtIndex(index : Int) ->UIViewController? {
        
        if((pageTitles.count == 0) || (index >= pageTitles.count)) {
            return nil
        }
       
        let  pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        if (index == 0) {
            pageContentViewController.imageName = "onboarding_step1"
            pageContentViewController.titleText = ""
            pageContentViewController.descText =  ""
        } else if (index == 1) {
            pageContentViewController.imageName = "onboarding_step2"
            pageContentViewController.titleText = ""
            pageContentViewController.descText =  ""
        } else {
            pageContentViewController.imageName = images[index]
            pageContentViewController.titleText = pageTitles[index]
            pageContentViewController.descText =  pageDescs[index]
        }
        pageContentViewController.pageIndex = index
        pageIndex = index
        return pageContentViewController
        
    }
    
    /// This method is called inside presentationCount for changing the appearance of page dot
    
    private func setupPageControl() {
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = commonColor
        pageControl.hidesForSinglePage = true

    }
    
    ///UIPageViewControllerDataSource ,UIPageViewControllerDelegate method implimentation
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        resetPageControl(index: index)
        if(index >= images.count){
            return nil
        }
        index += 1
        return self.viewControllerAtIndex(index: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).pageIndex!
        resetPageControl(index: index)
        if(index <= 0){
            return nil
        }
        index -= 1
    
        return self.viewControllerAtIndex(index: index)
    }
    func resetPageControl(index :Int)
    {
        pageControl.currentPage = index
        if pageControl.currentPage  >= pageTitles.count-1 {
            skipButton.isHidden = true
            nextButton.isHidden = true
            pageControl.isHidden = true
            getStarted.isHidden = false
            
        }else{
            
            getStarted.isHidden = true
            pageControl.isHidden = false
            skipButton.isHidden = false
            nextButton.isHidden = false
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(completed)
        {
            resetPageControl(index :pageIndex)
        }
    }*/


}
