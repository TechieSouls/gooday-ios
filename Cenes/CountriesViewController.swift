//
//  CountriesViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 17/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

protocol AppSettingsProtocol {
    func selectedCountry(countryCodeService: CountryCodeService);
}

class CountriesViewController: UIViewController {

    @IBOutlet weak var countryTableView: UITableView!
    
    @IBOutlet weak var backButton: UIImageView!
    
    var countriesDict: [String: [CountryCodeService]] = ["": []];
    var countryStrip: [String]!;
    var appSettingsProtocolDelegate: AppSettingsProtocol!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = themeColor;
        self.countryTableView.backgroundColor = themeColor;
        
        countryTableView.register(UINib.init(nibName: "CountryItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CountryItemTableViewCell");
        
        let backButtonTap = UITapGestureRecognizer.init(target: self, action: #selector(backButtonPressed))
        backButton.addGestureRecognizer(backButtonTap);
        
        countryStrip = ProfileManager().getAlphabeticStrip();
        self.loadCountriesData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    func loadCountriesData() {
        var countries: [CountryCodeService] = [];
        let countriesTemp: [CountryCodeService] = CountryCodeService().getLibraryMasterCountriesEnglish();
        countries = countriesTemp;
        //var countryHeaderMap: [String: [String]] = ["": []];
        for i in (0..<countries.count) {
            
            let countryObject: CountryCodeService = countries[i];
            
            //let headerAlphabet: String = countryObject.getName().substring(toIndex: 1).uppercased();
            let headerAlphabet: String = String(countryObject.getName().prefix(1)).uppercased();
            if (self.countriesDict[headerAlphabet] == nil) {
                
                var countriesArr: [CountryCodeService] = [CountryCodeService]();
                countriesArr.append(countryObject);
                self.countriesDict[headerAlphabet] = countriesArr;
            } else {
                
                var countriesArr = self.countriesDict[headerAlphabet];
                countriesArr?.append(countryObject);
                self.countriesDict[headerAlphabet] = countriesArr!.sorted { $0.getName() < $1.getName()};

            }
        }
        self.countryTableView.reloadData();
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
    }
}

extension CountriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countryStrip.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (countriesDict[countryStrip[section]] != nil) {
            return countriesDict[countryStrip[section]]!.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (countriesDict[countryStrip[indexPath.section]] == nil) {
            return UITableViewCell();
        }
        
        let countryObject = countriesDict[countryStrip[indexPath.section]]![indexPath.row];
        let cell: CountryItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CountryItemTableViewCell") as! CountryItemTableViewCell;
        
        cell.name.text = countryObject.getName();
        cell.countryCode.text = countryObject.getPhoneCode();
        
        return cell;
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (countriesDict[countryStrip[indexPath.section]] == nil) {
            return 0;
        }
        return 50;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "";
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return countryStrip;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let countryObject = countriesDict[countryStrip[indexPath.section]]![indexPath.row];
        appSettingsProtocolDelegate.selectedCountry(countryCodeService: countryObject);
        self.navigationController?.popViewController(animated: false);
    }
}
