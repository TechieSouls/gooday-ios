//
//  OnboardingPageViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 05/06/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var getStartedBtnView: UIView!
    @IBOutlet weak var getStartedBtn: UIButton!
    @IBOutlet weak var pageControlBox: UIPageControl!
    
    
    var itemIndex = 0;
    var pageIndex = 0;
    var pageViewController : UIPageViewController!;
    let onboardingTitles = ["INVITE GUESTS", "TIMEMATCH", "INVITATION"];
    let onboardingDescription = ["Make your next event more personal. Begin by inviting your friends on Cenes or straight from your contacts.", "Everyone has their own schedule. Sync your calendar with Cenes to let your friends know your availability.", "Create custom invitations for your guests to RSVP. Manage your social events right within our calendar."];

    let firstViewController = UIStoryboard.init(name: "Onboarding", bundle: Bundle.main).instantiateViewController(withIdentifier: "PageItemViewController") as! PageItemViewController

    let timematchController = UIStoryboard.init(name: "Onboarding", bundle: Bundle.main).instantiateViewController(withIdentifier: "TimeMatchOnboardingViewController") as! TimeMatchOnboardingViewController
    

    let invitationController = UIStoryboard.init(name: "Onboarding", bundle: Bundle.main).instantiateViewController(withIdentifier: "InvitationOnboardingViewController") as! InvitationOnboardingViewController

    
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
        self.view.addSubview(pageControlBox)

        pageControlBox.currentPage = 0;
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
        swipePageController.delegate = self

        if (onboardingTitles.count  > 0) {
         
            let firstController = getItemController(0)!
            let startingController = [firstController];
            swipePageController.setViewControllers(startingController, direction: .forward, animated: true, completion: nil)
        }
        
        pageViewController = swipePageController;
        addChild(pageViewController);
        self.view.addSubview(pageViewController.view);
    }
    
    func setupPageControll() {
        
        let appearance = UIPageControl.appearance();
        appearance.backgroundColor = UIColor.clear
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        if type(of: viewController) == PageItemViewController.self {
            
            print("viewControllerBefore",pageControlBox.currentPage);
            return nil
        } else if (type(of: viewController) == TimeMatchOnboardingViewController.self) {
            print("viewControllerBefore",pageControlBox.currentPage);

            return firstViewController;
        } else if (type(of: viewController) == InvitationOnboardingViewController.self) {
            print("viewControllerBefore",pageControlBox.currentPage);

            return timematchController;
        }
            return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if type(of: viewController) == PageItemViewController.self {
            print("viewControllerAfter",pageControlBox.currentPage);

            return timematchController;
        } else if (type(of: viewController) == TimeMatchOnboardingViewController.self) {
            print("viewControllerAfter",pageControlBox.currentPage);

            return invitationController;
        } else if (type(of: viewController) == InvitationOnboardingViewController.self) {
            print("viewControllerAfter",pageControlBox.currentPage);
            return nil;
        }
        return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if (completed) {
            
            let viewCont = pageViewController.viewControllers![0];
            if type(of: viewCont) == PageItemViewController.self {
                pageControlBox.currentPage = 0;
                print("didFinishAnimating",pageControlBox.currentPage);

            } else if (type(of: viewCont) == TimeMatchOnboardingViewController.self) {
                pageControlBox.currentPage = 1;
                print("didFinishAnimating",pageControlBox.currentPage);

            } else if (type(of: viewCont) == InvitationOnboardingViewController.self) {
                pageControlBox.currentPage = 2;
                print("didFinishAnimating",pageControlBox.currentPage);

            }
            
            
        }
    }
        
    func getItemController(_ itemIndex: Int) -> UIViewController? {
    
            self.pageIndex = itemIndex;
            if (itemIndex == 0) {
                let viewController = UIStoryboard.init(name: "Onboarding", bundle: Bundle.main).instantiateViewController(withIdentifier: "PageItemViewController") as! PageItemViewController
                return viewController;
            } else if (itemIndex == 1) {
                let viewController = UIStoryboard.init(name: "Onboarding", bundle: Bundle.main).instantiateViewController(withIdentifier: "TimeMatchOnboardingViewController") as! TimeMatchOnboardingViewController
                
                return viewController;
            }  else if (itemIndex == 2) {
                let viewController = UIStoryboard.init(name: "Onboarding", bundle: Bundle.main).instantiateViewController(withIdentifier: "InvitationOnboardingViewController") as! InvitationOnboardingViewController
                return viewController;
            }
        
        return nil;
    }
    
    
    @IBAction func getStartedPressed(_ sender: Any) {
        
        getStartedBtn.isUserInteractionEnabled = false;
        setting.setValue(UserSteps.OnBoardingScreens, forKey: "footprints")
        UIApplication.shared.keyWindow?.rootViewController = PhoneVerificationStep1ViewController.MainViewController()

    }
}
