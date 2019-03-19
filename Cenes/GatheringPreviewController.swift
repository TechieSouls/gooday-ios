//
//  GatheringPreviewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 23/02/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class GatheringPreviewController: UIViewController,NVActivityIndicatorViewable, UIActionSheetDelegate {
    
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);

    @IBOutlet weak var gatheringPreviewTable: UITableView!

    @IBOutlet weak var acceptDeclineView: UIView!
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var declineBtn: UIButton!
    //Variables:
    var event: Event?;
    var previewStackCellHeight: CGFloat!;
    var loggedInUser: User!;
    var host: EventMember!;
    var screenMode: String!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gatheringPreviewTable.register(UINib(nibName: "GatheringPreviewImageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringPreviewImageTableViewCell")
        gatheringPreviewTable.register(UINib(nibName: "GatheringPreviewTitleTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringPreviewTitleTableViewCell")
        gatheringPreviewTable.register(UINib(nibName: "GatheringPreviewDescTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringPreviewDescTableViewCell")
        gatheringPreviewTable.register(UINib(nibName: "GatheringDayTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringDayTableViewCell")
        gatheringPreviewTable.register(UINib(nibName: "GatheringTimeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringTimeTableViewCell")
        gatheringPreviewTable.register(UINib(nibName: "GatheringLocTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringLocTableViewCell")
        gatheringPreviewTable.register(UINib(nibName: "GatheringGuestTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringGuestTableViewCell")
        
        gatheringPreviewTable.rowHeight = UITableViewAutomaticDimension
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);

        setUpNavBar();
        acceptDeclineViewSetup();
        
        gatheringPreviewTable.backgroundColor = themeColor;
        
        host = getHost();
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setUpNavBar() {
        
        self.title = "Preview"
        
        //create a new button
        let button = UIButton(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "profile_back_icon.png"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        
        
        if (self.event != nil && self.event?.eventId != nil && self.event?.isEditMode == false) {
            
            //create a new button
            let button = UIButton(type: .custom)
            //set image for button
            button.setImage(UIImage(named: "gathering_edit_icon.png"), for: .normal)
            //add function for button
            button.addTarget(self, action: #selector(downloadSheet), for: .touchUpInside)
            //set frame
            button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            let barButton = UIBarButtonItem(customView: button)
            //assign button to navigationbar
            self.navigationItem.rightBarButtonItem = barButton
        } else {
            let nextButton = UIButton.init(type: .custom)
            
            nextButton.setTitle("Send", for: .normal)
            nextButton.setTitleColor(cenesLabelBlue, for: .normal)
            nextButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
            nextButton.clipsToBounds = true
            nextButton.addTarget(self, action: #selector(createGatheringbuttonPressed(_:)), for: .touchUpInside)
            let rightButton = UIBarButtonItem.init(customView: nextButton)
            
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    func acceptDeclineViewSetup() -> Void {
        
        if (self.event?.eventClickedFrom == "Notification") {
            
            //Lets keep the Accept aAnd Decline Button View hidden
            self.acceptDeclineView.isHidden = false;
            
            //Setting button text colors to white by defaut
            self.acceptBtn.setTitleColor(UIColor.white, for: .normal)
            self.declineBtn.setTitleColor(UIColor.white, for: .normal)
            
            //Lets find out the logged In users from list
            //of event members.
            var userAsAttendee = EventMember();
            for attendee in (event?.eventMembers)! {
                if (attendee.userId != nil && self.loggedInUser.userId == attendee.userId) {
                    userAsAttendee = attendee;
                }
            }
            
            if (userAsAttendee.eventMemberId != nil && userAsAttendee.userId != self.event?.createdById) {
                
                if (userAsAttendee.status == nil) {
                    //setting backgroud colors of button to cenes blue by default
                    //This is when user has not taken any action on the event
                    self.acceptBtn.backgroundColor = cenesLabelBlue;
                    self.declineBtn.backgroundColor = cenesLabelBlue;
                } else if (userAsAttendee.status == "Going") {
                    
                    //Disabling Accept Button, So that user cannot
                    //Press the button again
                    self.acceptBtn.isEnabled = false;
                    
                    //If the user has already accepted the gathering
                    //Then we will set the Accpet button background
                    // to Orange and Decline Button background to Grey
                    self.acceptBtn.backgroundColor = selectedColor;
                    self.declineBtn.backgroundColor = unselectedColor;
                } else if (userAsAttendee.status == "NotGoing") {
                    
                    //Disabling Decline Button, so that user cannot press the button again
                    self.declineBtn.isEnabled = false;
                    
                    //If the user has already declined the gathering
                    //Then we will set the Accpet button background
                    // to Grey and Decline Button background to Default
                    //Cenes blue color
                    self.acceptBtn.backgroundColor = unselectedColor;
                    self.declineBtn.backgroundColor = cenesLabelBlue;
                }
            }
            
        } else {
            self.acceptDeclineView.isHidden = true;
        }
    }

    func returnNumberOfRows() -> Int {
        
        var count: Int = 7;
        if (self.event?.location == nil) {
            count = count - 1;
        }
        
        if (self.event?.eventMembers == nil) {
            count = count - 1;
        }
        
        return 7;
    }
    
    func loadImage(url: String, imageView: UIImageView, placeholder: String) -> Void {
        
        imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: placeholder))
    }
    
    @IBAction func downloadSheet(_sender: AnyObject)
    {
        
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let editAction: UIAlertAction = UIAlertAction(title: "Edit", style: .default) { action -> Void in
            print("First Action pressed")
            
            self.event?.isEditMode = true;
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "createGathering") as! CreateGatheringViewController
            viewController.event = self.event!;
            self.navigationController?.pushViewController(viewController, animated: true);
        }
        editAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
    
        let shareToAction: UIAlertAction = UIAlertAction(title: "Share to...", style: .default) { action -> Void in
            var shareText = shareLinkText.replacingOccurrences(of: "[Host]", with: String(self.host.name));
            shareText = shareText.replacingOccurrences(of: "[Title]", with: String(self.event!.title));
            shareText = "\(shareText) \n \(shareEventUrl) \(String(self.event!.key))";
            let items = [shareText]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(ac, animated: true)
        }
        shareToAction.setValue(cenesLabelBlue, forKey: "titleTextColor")

        
        let copyLinkAction: UIAlertAction = UIAlertAction(title: "Copy Link", style: .default) { action -> Void in
            let shareLink = "\(shareEventUrl) \(String(self.event!.key))";
            
            UIPasteboard.general.string = shareLink;
            
            let message = "Link Copied..."
            Util.showToast(controller: self, message: message, seconds: 1)
        }
        copyLinkAction.setValue(cenesLabelBlue, forKey: "titleTextColor")

        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { action -> Void in
            
            self.startAnimating(loadinIndicatorSize, message: "Deleting...", type: NVActivityIndicatorType.lineScaleParty)
            GatheringService().deleteGatheringTask(eventId: (self.event?.eventId)!){(returnedDict) in
                
                self.stopAnimating();
                self.navigationController?.popToRootViewController(animated: true)
            };
        }

        let declineAction: UIAlertAction = UIAlertAction(title: "Decline", style: .destructive) { action -> Void in
             self.updateGatheringMemberStatus(status: "NotGoing");
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        cancelAction.setValue(cenesLabelBlue, forKey: "titleTextColor")

        // add actions
        //Edit Option Should be Available only for the those events
        //Which are created By LoggedInUser
        if (self.host.userId == self.loggedInUser.userId) {
            actionSheetController.addAction(editAction)
        }
        actionSheetController.addAction(shareToAction)
        actionSheetController.addAction(copyLinkAction)
        
        //Delete Option Should be Available only for the those events
        //Which are created By LoggedInUser
        if (self.host.userId == self.loggedInUser.userId) {
            actionSheetController.addAction(deleteAction)
        }
        //Delete Option Should be Available only for the those events
        //which are not created by LoggedInUser
        if (self.host.userId != self.loggedInUser.userId) {
            actionSheetController.addAction(declineAction)
        }
        
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    @IBAction func acceptBtnPressed(_ sender: Any) {
         self.updateGatheringMemberStatus(status: "Going");
    }
    
    @IBAction func declineBtnPressed(_ sender: Any) {
        self.updateGatheringMemberStatus(status: "NotGoing");
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createGatheringbuttonPressed(_ sender: Any) {
        
       
        let params = Event().toDictionary(event: self.event!);
        
        GatheringService().createGathering(uploadDict: params as! [String : Any], complete: { (returnedDict) in
            self.stopAnimating()
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                
                print("Got result from webservice\(returnedDict)")
                let dict = returnedDict["data"] as? NSDictionary
                
                
                
                /*if self.nonCenesUsers.count > 0 {
                    
                    var phoneNumbers: String = "";
                    for userContact in self.nonCenesUsers {
                        phoneNumbers = "\(userContact.phone),\(phoneNumbers)";
                    }
                    self.sendSMSText(phoneNumber: phoneNumbers.substring(toIndex: phoneNumbers.count-1));
                } */
            }
             self.navigationController?.popToRootViewController(animated: true)
        });
    }
    
    func getHost() -> EventMember {
        var host: EventMember? = EventMember();
        if (self.event != nil && self.event!.eventId != nil && self.event?.eventMembers != nil) {
            for eventMem in (self.event?.eventMembers)! {
                if (eventMem.userId != nil && eventMem.userId == self.event?.createdById) {
                    host = eventMem;
                    host?.photo = eventMem.user.photo;
                    break;
                }
            }
        }
        
        if (host == nil) {
            host!.name = self.loggedInUser.name;
            host!.photo = self.loggedInUser.photo;
            host!.userId = self.loggedInUser.userId;
        }
        return host!;
    }
    
    func updateGatheringMemberStatus(status: String) ->Void {
        let queryStr: String = "eventId=\(String(self.event!.eventId))&userId=\(String(self.loggedInUser.userId))&status=\(status)"
        
        self.startAnimating(loadinIndicatorSize, message: "Updating...", type: NVActivityIndicatorType.lineScaleParty)
        
        GatheringService().updateGatheringStatus(queryStr: queryStr){(returnedDict) in
            self.stopAnimating();
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
