//
//  BaseOnboardingViewController.swift
//  Cenes
//
//  Created by Ashutosh Tiwari on 8/24/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseOnboardingViewController: UIViewController ,UIPageViewControllerDataSource ,UIPageViewControllerDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet weak var separatorView : UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var bottomOuterView: UIView!
    
    @IBOutlet var pageControl: UIPageControl!
    
    var pageViewController : UIPageViewController!
    var pageIndex = 1
    
    let profile = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profile") as? PCameraViewController
    let holiday = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "holiday") as? WorldHolidayCalendarViewController
    let meTime = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeTime") as? MeTimeViewController
    let calendar = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendar") as? AddCalendarViewController
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.pageControl.numberOfPages = 4
        
        
        
        self.title = "Complete Your Profile"
        self.navigationItem.hidesBackButton = true
        separatorView.layer.shadowOffset = CGSize(width: 0, height: -1)
        separatorView.layer.shadowRadius = 1;
        separatorView.layer.shadowOpacity = 0.5;
        separatorView.layer.masksToBounds = false
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: commonColor]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        setupPageControl()
        
        reset()
        
        self.setpageIndex(index: self.pageIndex)
        
        holiday?.baseView = self
        meTime?.baseView = self
    }
    
    
    
    func setpageIndex(index:Int){
        self.pageControl.currentPage = index
        self.pageIndex = index
        
        print("Curernt page \(index)")
        if pageIndex == 3 {
            self.nextButton.setTitle("FINISH", for: .normal)
        }else{
            self.nextButton.setTitle("NEXT", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    @IBAction func userDidSelectLater(sender:UIButton){
        
        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
    }
    
    @IBAction func userDidSelectNext(sender:UIButton){
        
    }
    
    
    func reset()
    {
        /* Getting the page View controller */
        
       
        
        let pageContentViewController = self.viewControllerAtIndex(index: pageIndex)
        
        let viewControllers = [pageContentViewController!]
        
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
        
        
            self.addChildViewController(self.pageViewController)
            self.view.addSubview(self.pageViewController.view)
        
            self.view.bringSubview(toFront: self.pageViewController.view)
            
        
            print(self.pageViewController.view.frame)
        
          self.pageViewController.didMove(toParentViewController: self)
        
            self.view.bringSubview(toFront: self.bottomOuterView)
        }

    
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let webServ = WebService()
        
        if pageIndex == 0 {
            if profile?.imageSelected == true {
                
                webServ.uploadProfilePic(image: profile?.image.image, complete: { (returnedDict) in
                    appDelegate?.profileImageSet(image: (self.profile?.image.image!)!)
                })
            }
            
            pageIndex = pageIndex + 1
            reset()
            self.setpageIndex(index: pageIndex)
            
        }else if pageIndex == 1 {
            
            if self.holiday?.countryNameTextField.text != "" {
                startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
                webServ.holidayCalendar(calenderName: (self.holiday?.selectedCountry)!, complete: { (sucess) in
                    print("webservice response oomplete")
                     self.stopAnimating()
                    self.pageIndex = self.pageIndex + 1
                    self.reset()
                    self.setpageIndex(index: self.pageIndex)
                })
            }else{
                self.pageIndex = self.pageIndex + 1
                self.reset()
                self.setpageIndex(index: pageIndex)
            }
            
        }else if pageIndex == 2 {
            
            meTime?.userDidSelectNext()
            pageIndex = pageIndex + 1
            reset()
            self.setpageIndex(index: pageIndex)
            
            
        }else if pageIndex == 3 {
            
            self.calendar?.userDidSelectNext()
        }
        
        
        
        
        
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        
        if pageIndex == 3 {
            self.calendar?.userDidSelectNext()
        }else{
        pageIndex = pageIndex + 1
        reset()
            self.setpageIndex(index: pageIndex)
        }
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
    
    func viewControllerAtIndex(index : Int) ->UIViewController? {
        
        if((pageTitles.count == 0) || (index >= pageTitles.count + 1 )) {
            return nil
        }
        
        pageIndex = index
        
        switch index {
        case 0:
            return profile
        case 1:
            
            return holiday
        case 2:
            return meTime
        case 3:
            return calendar
        default:
            print("default")
        }
        
        return nil
        
    }
    
    /// This method is called inside presentationCount for changing the appearance of page dot
    
    private func setupPageControl() {
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = commonColor
        pageControl.hidesForSinglePage = true
        
    }
    
    ///UIPageViewControllerDataSource ,UIPageViewControllerDelegate method implimentation
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        print("after wards\(viewController.description)")
        
        
        
        if type(of: viewController) == PCameraViewController.self {
            self.setpageIndex(index: 0)
            return holiday
        }else if type(of: viewController) == WorldHolidayCalendarViewController.self {
            self.setpageIndex(index: 1)
            return meTime
        }
        else if type(of: viewController) == MeTimeViewController.self {
           self.setpageIndex(index: 2)
            return calendar
            
        }else  if type(of: viewController) == AddCalendarViewController.self {
           self.setpageIndex(index: 3)
            return nil
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
       print("before wards\(viewController.description)")
        print(self.pageViewController.view.frame)
        
        if type(of: viewController) == PCameraViewController.self {
            self.setpageIndex(index: 0)
            return nil
        }else if type(of: viewController) == WorldHolidayCalendarViewController.self {
            self.setpageIndex(index: 1)
            return profile
        }
        else if type(of: viewController) == MeTimeViewController.self {
            self.setpageIndex(index: 2)
            return holiday
            
        }else  if type(of: viewController) == AddCalendarViewController.self {
            
            self.setpageIndex(index: 3)
            return meTime
        }
        
        return nil
        
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(completed)
        {
            print("completed animateions")
        }
    }
}
