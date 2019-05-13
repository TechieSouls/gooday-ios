//
//  SignupSuccessStep2ViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 13/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

protocol SignupStep2FormTableViewCellProtocol {
    
    func datePickerDone(date: Date);
}

class SignupSuccessStep2ViewController: UIViewController {

    
    @IBOutlet weak var signupStep2TableView: UITableView!
    
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var datepickerButtonBar: UIView!
    
    @IBOutlet weak var datePickerCancelButton: UIButton!
    
    @IBOutlet weak var datePickerDoneButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var signupStep2FormTableViewCellProtocolDelegate: SignupStep2FormTableViewCellProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datepickerButtonBar.backgroundColor = themeColor;
        
        signupStep2TableView.register(UINib.init(nibName: "SignupStep2FormTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SignupStep2FormTableViewCell");
        
        signupStep2TableView.register(UINib.init(nibName: "SignupStep2CalendarsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SignupStep2CalendarsTableViewCell");
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func photoIconClicked() {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            //self.takePicture();
        }
        takePhotoAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Choose From Library", style: .default) { action -> Void in
            //self.selectPicture();
        }
        uploadPhotoAction.setValue(selectedColor, forKey: "titleTextColor")
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(uploadPhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    @IBAction func datePickerCancelButtonPressed(_ sender: Any) {
        datePickerView.isHidden = true;
    }
    
    @IBAction func datePickerDoneButtonPressed(_ sender: Any) {
        datePickerView.isHidden = true;
        signupStep2FormTableViewCellProtocolDelegate.datePickerDone(date: datePicker.clampedDate);
    }
}

extension SignupSuccessStep2ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                return 465;
            case 1:
                return 293;
            default:
                return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell: SignupStep2FormTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SignupStep2FormTableViewCell") as! SignupStep2FormTableViewCell;
            cell.signupSuccessStep2ViewControllerDelegate = self;
            
            self.signupStep2FormTableViewCellProtocolDelegate = cell;
            return cell;

        case 1:
            let cell: SignupStep2CalendarsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SignupStep2CalendarsTableViewCell") as! SignupStep2CalendarsTableViewCell;
            return cell;
            
        default:
            print("Default")
        }
        
        return UITableViewCell();
    }
}
