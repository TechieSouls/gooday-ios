//
//  ReminderDetailViewController.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 8/1/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit

class ReminderDetailViewController: UITableViewController ,UITextViewDelegate{

        var selectedDate:Date?
        var calanderSelection = false
        var dateString :String?
        var reminderDate:Date?
        var name:String?
        var dataObject:ReminderData?
        @IBOutlet weak var remiderTextField: UITextField!
        @IBOutlet weak var dateTextField: UITextField!
        @IBOutlet weak var textView: UITextView!
    
        @IBOutlet var table: UITableView!
    
        override func viewDidLoad() {
            
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : commonColor]

            self.navigationController?.navigationBar.tintColor = commonColor
            textView.delegate = self
            if(name != nil)
            {
                if let i = reminderDataDetail.index(where: { $0.name == name }) {
                    dataObject = reminderDataDetail[i]
                    remiderTextField.text = dataObject?.name
                    dateTextField.text = dataObject?.dateStr
                }
            }
            
//            table.rowHeight = UITableViewAutomaticDimension
//            table.estimatedRowHeight = 240 // Something reasonable to help ios render your cells
            
           
    }
    
    @IBAction func TextFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
   
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
       
        dateFormatter.dateFormat = "MM/dd/yyyy  H:mm a"
        reminderDate = sender.date
        dateString = dateFormatter.string(from: reminderDate!)
        dateTextField.text = dateString
        
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
             
        override func viewWillDisappear(_ animated: Bool) {

            if(remiderTextField.text == nil)
            {
                print("remiderTextField is nil")
                return
            }
            if(reminderDate  != nil)
            {
                let reminder = Reminders()
                reminder.scheduleNotification(at: reminderDate!)
            }
           
            if(dataObject == nil)
            {
                dataObject = ReminderData(name: remiderTextField.text!)
                reminderDataDetail.append(dataObject!)
            }
            if(dateString != nil)
            {
                dataObject?.dateStr = dateString!
            }
           
        }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    // MARK: UITextViewDelegate
//    func textViewDidChange(_ textView: UITextView) {
//     
//        // Calculate if the text view will change height, then only force
//        // the table to update if it does.  Also disable animations to
//        // prevent "jankiness".
//        
//        let startHeight = textView.frame.size.height
//        let calcHeight = textView.sizeThatFits(textView.frame.size).height  //iOS 8+ only
//        
//        if startHeight != calcHeight {
//            
//            UIView.setAnimationsEnabled(false) // Disable animations
//            self.tableView.beginUpdates()
//            self.tableView.endUpdates()
//            
//            // Might need to insert additional stuff here if scrolls
//            // table in an unexpected way.  This scrolls to the bottom
//            // of the table. (Though you might need something more
//            // complicated if editing in the middle.)
//            
//            let scrollTo = self.tableView.contentSize.height - self.tableView.frame.size.height
//            self.tableView.setContentOffset(CGPoint(x: 0,y :scrollTo), animated: false)
//            
//            UIView.setAnimationsEnabled(true)  // Re-enable animations.
//        }
//    }
}
