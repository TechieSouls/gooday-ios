//
//  WorldHolidayCalendarViewController.swift
//  Cenes
//
//  Created by Ashutosh Tiwari on 8/24/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class WorldHolidayCalendarViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var countryNameTextField : UITextField!
    @IBOutlet weak var countryPickerView : UIPickerView!
    @IBOutlet weak var separatorView : UIView!
    
    var countryDataArray = [NSMutableDictionary]()
    
    var selectedCountry = ""
    
    @IBOutlet weak var globeIcon: UIImageView!
    var baseView : BaseOnboardingViewController!
    
    var fromSideMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryDataArray =  [["name":"Australian Holidays","value":"en.australian#holiday@group.v.calendar.google.com","image":"flag_au.png"],
        ["name":"Austrian Holidays","value":"en.austrian#holiday@group.v.calendar.google.com","image":"flag_br.png"],
        ["name":"Brazilian Holidays","value":"en.brazilian#holiday@group.v.calendar.google.com","image":"flag_at.png"],
        ["name":"Canadian Holidays","value":"en.canadian#holiday@group.v.calendar.google.com","image":"flag_ca.png"],
        ["name":"China Holidays","value":"en.china#holiday@group.v.calendar.google.com","image":"flag_cn.png"],
        ["name":"Christian Holidays","value":"en.christian#holiday@group.v.calendar.google.com","image":"flag_christ.png"],
        ["name":"Danish Holidays","value":"en.danish#holiday@group.v.calendar.google.com","image":"flag_dk.png"],
        ["name":"Dutch Holidays","value":"en.dutch#holiday@group.v.calendar.google.com","image":"flag_dut.png"],
        ["name":"Finnish Holidays","value":"en.finnish#holiday@group.v.calendar.google.com","image":"flag_fi.png"],
        ["name":"French Holidays","value":"en.french#holiday@group.v.calendar.google.com","image":"flag_fr.png"],
        ["name":"German Holidays","value":"en.german#holiday@group.v.calendar.google.com","image":"flag_de.png"],
        ["name":"Greek Holidays","value":"en.greek#holiday@group.v.calendar.google.com","image":"flag_gr.png"],
        ["name":"Hong Kong (C) Holidays","value":"en.hong_kong_c#holiday@group.v.calendar.google.com","image":"flag_hk.png"],
        ["name":"Hong Kong Holidays","value":"en.hong_kong#holiday@group.v.calendar.google.com","image":"flag_hk.png"],
        ["name":"Indian Holidays","value":"en.indian#holiday@group.v.calendar.google.com","image":"flag_in.png"],
        ["name":"Indonesian Holidays","value":"en.indonesian#holiday@group.v.calendar.google.com","image":"flag_id.png"],
        ["name":"Iranian Holidays","value":"en.iranian#holiday@group.v.calendar.google.com","image":"flag_ir.png"],
        ["name":"Irish Holidays","value":"en.irish#holiday@group.v.calendar.google.com","image":"flag_ie.png"],
        ["name":"Islamic Holidays","value":"en.islamic#holiday@group.v.calendar.google.com","image":"flag_isl.png"],
        ["name":"Italian Holidays","value":"en.italian#holiday@group.v.calendar.google.com","image":"flag_it.png"],
        ["name":"Japanese Holidays","value":"en.japanese#holiday@group.v.calendar.google.com","image":"flag_jp.png"],
        ["name":"Jewish Holidays","value":"en.jewish#holiday@group.v.calendar.google.com","image":"flag_jew.png"],
        ["name":"Malaysian Holidays","value":"en.malaysia#holiday@group.v.calendar.google.com","image":"flag_my.png"],
        ["name":"Mexican Holidays","value":"en.mexican#holiday@group.v.calendar.google.com","image":"flag_mx.png"],
        ["name":"New Zealand Holidays","value":"en.new_zealand#holiday@group.v.calendar.google.com","image":"flag_nz.png"],
        ["name":"Norwegian Holidays","value":"en.norwegian#holiday@group.v.calendar.google.com","image":"flag_nw.png"],
        ["name":"Philippines Holidays","value":"en.philippines#holiday@group.v.calendar.google.com","image":"flag_ph.png"],
        ["name":"Polish Holidays","value":"en.polish#holiday@group.v.calendar.google.com","image":"flag_pl.png"],
        ["name":"Portuguese Holidays","value":"en.portuguese#holiday@group.v.calendar.google.com","image":"flag_pt.png"],
        ["name":"Russian Holidays","value":"en.russian#holiday@group.v.calendar.google.com","image":"flag_ru.png"],
        ["name":"Singapore Holidays","value":"en.singapore#holiday@group.v.calendar.google.com","image":"flag_sg.png"],
        ["name":"South Africa Holidays","value":"en.sa#holiday@group.v.calendar.google.com","image":"flag_za.png"],
        ["name":"South Korean Holidays","value":"en.south_korea#holiday@group.v.calendar.google.com","image":"flag_kr.png"],
        ["name":"Spain Holidays","value":"en.spain#holiday@group.v.calendar.google.com","image":"flag_es.png"],
        ["name":"Swedish Holidays","value":"en.swedish#holiday@group.v.calendar.google.com","image":"flag_se.png"],
        ["name":"Taiwan Holidays","value":"en.taiwan#holiday@group.v.calendar.google.com","image":"flag_tw.png"],
        ["name":"Thai Holidays","value":"en.thai#holiday@group.v.calendar.google.com","image":"flag_th.png"],
        ["name":"UK Holidays","value":"en.uk#holiday@group.v.calendar.google.com","image":"flag_ac.png"],
        ["name":"US Holidays","value":"en.usa#holiday@group.v.calendar.google.com","image":"flag_us.png"],
        ["name":"Vietnamese Holidays","value":"en.vietnamese#holiday@group.v.calendar.google.com","image":"flag_vn.png"]]
        
        
        
        countryNameTextField.inputView = countryPickerView
        countryPickerView.removeFromSuperview()
        // Do any additional setup after loading the view.
        countryPickerView.delegate = self
        countryPickerView.dataSource  = self
        separatorView.layer.shadowOffset = CGSize(width: 0, height: -1)
        separatorView.layer.shadowRadius = 1;
        separatorView.layer.shadowOpacity = 0.5;
        separatorView.layer.masksToBounds = false
        
        if fromSideMenu {
            self.navigationItem.hidesBackButton = true
            let backButton = UIButton.init(type: .custom)
            backButton.setTitle("Cancel", for: UIControlState.normal)
            backButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            backButton.layer.cornerRadius = backButton.frame.height/2
            backButton.clipsToBounds = true
            backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
            
            let barButton = UIBarButtonItem.init(customView: backButton)
            self.navigationItem.leftBarButtonItem = barButton
             self.separatorView.isHidden = true
            
        }
        self.globeIcon.image = #imageLiteral(resourceName: "holidayglobeBlue")
    }
    
    @objc func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        
        print(self.globeIcon.bounds)
        print("self globel icon bound =\(self.globeIcon.frame)")
        let image = #imageLiteral(resourceName: "holidayglobeBlue").compressImage(newSizeWidth: Float(self.globeIcon.bounds.width), newSizeHeight: Float(self.globeIcon.bounds.size.width), compressionQuality: 1.0)
        if self.globeIcon.image == nil {
            self.globeIcon.image = image
        }
    }
    
    func setUpNavBar(set:Bool){
        if set {
            
            if fromSideMenu {
               
                let doneButton = UIButton.init(type: .custom)
                doneButton.setTitle("Done", for: UIControlState.normal)
                doneButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
                doneButton.layer.cornerRadius = doneButton.frame.height/2
                doneButton.clipsToBounds = true
                doneButton.addTarget(self, action: #selector(dismissPickerView), for: .touchUpInside)
                let barButton = UIBarButtonItem.init(customView: doneButton)
                 self.navigationItem.rightBarButtonItem = barButton
                
            }else{
            baseView.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPickerView))
            }
        }else{
            if fromSideMenu {
                let saveButton = UIButton.init(type: .custom)
                saveButton.setTitle("Save", for: UIControlState.normal)
                saveButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
                saveButton.layer.cornerRadius = saveButton.frame.height/2
                saveButton.clipsToBounds = true
                saveButton.addTarget(self, action: #selector(saveHoliday), for: .touchUpInside)
                let barButton = UIBarButtonItem.init(customView: saveButton)
                self.navigationItem.rightBarButtonItem = barButton
                self.globeIcon.image = #imageLiteral(resourceName: "holidayglobeBlue")
            }else{
                baseView.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissPickerView(){
        self.countryNameTextField.endEditing(true)
    }
    
    @objc func saveHoliday(){
        if self.countryNameTextField.text != "" {
            startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
            WebService().holidayCalendar(calenderName: (self.selectedCountry), complete: { (sucess) in
                print("webservice response oomplete")
                self.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @IBAction  func userDidSelectNext(sender:UIButton){
        let calendar = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeTime") as? MeTimeViewController
        self.navigationController?.pushViewController(calendar!, animated: true)
    }
    
     func userDidSelectLater(sender: UIButton) {
        let calendar = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeTime") as? MeTimeViewController
        self.navigationController?.pushViewController(calendar!, animated: true)
    }
}

extension WorldHolidayCalendarViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.countryPickerView.isHidden = false
        self.setUpNavBar(set: true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.countryPickerView.isHidden = true
        self.setUpNavBar(set: false)
    }
}

extension WorldHolidayCalendarViewController : CountryPickerDelegate {
    func countryPicker(_ picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!) {
        self.countryNameTextField.text = name
    }
}

extension WorldHolidayCalendarViewController : UIPickerViewDelegate ,UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryDataArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if (view == nil)
        {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 24)) //[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
            let label = UILabel(frame: CGRect(x: 100, y: 3, width: self.view.bounds.size.width - 40, height: 24 ))
            label.backgroundColor = UIColor.clear
            label.tag = 1;
            
            view.addSubview(label)
            
            let flagView = UIImageView(frame: CGRect(x: 60, y: 3, width: 24, height: 24))//[[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 24, 24)];
            flagView.contentMode = .scaleAspectFit;
            flagView.tag = 2;
            view.addSubview(flagView)
            (view.viewWithTag(1) as! UILabel).text = countryDataArray[row]["name"] as? String
            (view.viewWithTag(2) as! UIImageView).image = UIImage(named: (countryDataArray[row]["image"] as? String)!)
            return view
        }else{
            
            (view?.viewWithTag(1) as! UILabel).text = countryDataArray[row]["name"] as? String
            (view?.viewWithTag(2) as! UIImageView).image = UIImage(named: (countryDataArray[row]["image"] as? String)!)
            return view!
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print((countryDataArray[row]["name"] as? String)!)
        self.countryNameTextField.text = countryDataArray[row]["name"] as? String
        selectedCountry = (countryDataArray[row]["value"] as? String)!
    }
    
}
