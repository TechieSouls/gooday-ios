//
//  AppSettingsEditViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IoniconsSwift

class AppSettingsEditViewController: UIViewController, AppSettingsProtocol, NVActivityIndicatorViewable {

    @IBOutlet weak var appSettingsEditTableView: UITableView!
    
    var countryCodeService: CountryCodeService!;
    var loggedInUser: User!;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.appSettingsEditTableView.backgroundColor = themeColor;
        self.view.backgroundColor = themeColor;
        self.tabBarController?.tabBar.isHidden = true;
        self.title = "Delete Account";
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        appSettingsEditTableView.register(UINib.init(nibName: "DeleteAccountTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DeleteAccountTableViewCell");
        
        
        let countryCodeServices = CountryCodeService().getLibraryMasterCountriesEnglish();
        
        HttpService().getMethodWithoutToken(url: "https://api6.ipify.org/?format=json", complete: {(response) in
            
            if (response.value(forKey: "ip") != nil) {
                let ipAddress = response.value(forKey: "ip") as! String;
                
                
                let queryStr = "ipAddress=\(String(ipAddress))";
                UserService().getCountryByIpAddressWithoutToken(queryStr: queryStr, complete: {(response) in
                    
                    let success = response.value(forKey: "success") as! Bool;
                    var countryCode = "";
                    if (success == true) {
                        let countryDict = response.value(forKey: "data") as! NSDictionary;
                        countryCode = countryDict.value(forKey: "iso_code") as! String;
                    } else {
                        countryCode = ((Locale.current as NSLocale).object(forKey: .countryCode) as? String)!;
                    }
                    
                    for countryCodeServiceObj in countryCodeServices {
                        if (countryCode.uppercased() == countryCodeServiceObj.getNameCode().uppercased()) {
                            self.countryCodeService = countryCodeServiceObj;
                            break;
                        }
                    }
                    
                    self.appSettingsEditTableView.reloadData();
                })
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar();
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.isHidden = false;
        
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "abondan_event_icon"), for: UIControlState.normal)
        backButton.setImage(#imageLiteral(resourceName: "abondan_event_icon"), for: UIControlState.selected)
        backButton.addTarget(self, action:#selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        backButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        let backBarButton = UIBarButtonItem.init(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    func navigateToCountryList() {
        let navController = storyboard?.instantiateViewController(withIdentifier: "CountriesViewController") as! CountriesViewController;
        navController.appSettingsProtocolDelegate = self;
        self.navigationController?.pushViewController(navController, animated: true);
    }
    
    func selectedCountry(countryCodeService: CountryCodeService) {
        self.countryCodeService = countryCodeService;
        self.appSettingsEditTableView.reloadData();
    }
    
    func deleteUserRequest(postData: [String: Any]) {
        
        self.startAnimating(loadinIndicatorSize, message: "", type: NVActivityIndicatorType.ballRotateChase);
        
        UserService().deleteUserByPhoneAndPassword(postData: postData, token: loggedInUser.token, complete: {(response) in
            
            self.stopAnimating()

            let success = response.value(forKey: "success") as! Bool;
            
            if (success == false) {
                let message = response.value(forKey: "message") as! String;
                self.showAlert(title: "Alert", message: message);
            } else {
                self.resetDefaults();
                
                
                UIApplication.shared.keyWindow?.rootViewController = PhoneVerificationStep1ViewController.MainViewController();
            }
        })
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize();
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
}

extension AppSettingsEditViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: DeleteAccountTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DeleteAccountTableViewCell") as! DeleteAccountTableViewCell;
        cell.appSettingsEditViewControllerDelegate = self;
        if (countryCodeService != nil) {
            cell.countryLabel.text = countryCodeService.getName();
            cell.countryCode.text = countryCodeService.getPhoneCode();
        } else {
            cell.countryLabel.text = "Select Your Country"
        }
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240;
    }
}
