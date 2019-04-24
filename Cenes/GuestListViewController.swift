//
//  GuestListViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 11/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GuestListViewController: UIViewController {

    
    @IBOutlet weak var guestListTableView: UITableView!
    
    @IBOutlet weak var closeIcon: UIImageView!
    
    
    @IBOutlet weak var invitedUiView: UIView!
    
    @IBOutlet weak var acceptedUIView: UIView!

    @IBOutlet weak var declinedUIView: UIView!
    
    
    @IBOutlet weak var invitedUIViewUILabel: UILabel!
    
    @IBOutlet weak var acceptedUIViewUILabel: UILabel!
    
    @IBOutlet weak var declinedUIViewUILabel: UILabel!
    
    var eventMembers: [EventMember]!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let closeImageTapGesture = UITapGestureRecognizer(target: self, action: Selector("closeIconPressed"));
        closeIcon.addGestureRecognizer(closeImageTapGesture);
        
        
        // Do any additional setup after loading the view.
        guestListTableView.register(UINib(nibName: "GuestListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GuestListTableViewCell")
        
        invitedUiView.layer.borderColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor;
        invitedUiView.layer.borderWidth = 5;
        invitedUiView.layer.shadowOffset = CGSize(width: 0, height: 2)
        invitedUiView.layer.shadowColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.5).cgColor
        invitedUiView.layer.shadowOpacity = 1
        invitedUiView.layer.shadowRadius = 2
        invitedUiView.roundedView();

        invitedUIViewUILabel.textColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        
        acceptedUIView.roundedView();
        acceptedUIView.layer.borderWidth = 5
        acceptedUIView.layer.borderColor = UIColor.white.cgColor
        
        declinedUIView.roundedView();
        declinedUIView.layer.borderWidth = 5
        declinedUIView.layer.borderColor = UIColor.white.cgColor
        
        invitedUIViewUILabel.text = String(eventMembers.count);
        
        var acceptedCount = 0;
        var declinedCount = 0;
        for eventMem in eventMembers {
            if (eventMem.status == "Going") {
                acceptedCount = acceptedCount + 1;
            } else if (eventMem.status == "NotGoing") {
                declinedCount = declinedCount + 1;
            }
        }
        acceptedUIViewUILabel.text = String(acceptedCount);
        declinedUIViewUILabel.text = String(declinedCount);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @objc func closeIconPressed() {
        print("Close Clicked")
        self.dismiss(animated: true, completion: nil);
    }
}

extension GuestListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventMembers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eventMember = self.eventMembers[indexPath.row];
        
        let cell: GuestListTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "GuestListTableViewCell", for: indexPath) as! GuestListTableViewCell;
        
        if (eventMember.user != nil) {
            
            cell.cenesName.text = eventMember.user.name;
            if (eventMember.user.photo != nil) {
                cell.profilePic.sd_setImage(with: URL(string: eventMember.user.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
            }
        }
        
        if (eventMember.userContact != nil) {
            cell.contactName.isHidden = false;
            cell.contactName.text = eventMember.userContact.name;
        } else {
            cell.contactName.isHidden = true;
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
}
