//
//  SignupCountryCodeViewController.swift
//  Cenes
//
//  Created by Macbook on 29/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

protocol SelectedCountryProtocol {
    func selectedCountryCode(countryCode: String);
}

class SignupCountryCodeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var seacrhInputText: UITextField!
    
    @IBOutlet weak var countryTable: UITableView!
    
    @IBAction func searchInputTextChanged(_ sender: Any) {
        self.prepareData(searchText: seacrhInputText.text!)
    }
    
    var selectedCountryCodeDelegate: SelectedCountryProtocol?;
    var countriesDict: [String: [CountryCodeService]] = ["": []];
    var countryHeaders: [String] = [];
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(countryHeaders.count)
        return self.countriesDict[self.countryHeaders[section]]!.count;
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
         print(countryHeaders.count)
        return self.countryHeaders.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(countryHeaders.count)
        return self.countryHeaders.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView();
        let headerLabel = UILabel();
        headerLabel.text = countryHeaders[section]
        headerLabel.frame = CGRect(x: 25, y: 5, width: self.view.bounds.width, height: 25)
        view.addSubview(headerLabel);
        return view;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let countryCell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryCodeTableViewCell
        
        /*if (countryCell == nil) {
            countryCell = UITableViewCell(style: .default, reuseIdentifier: "countryCell") as! CountryCodeTableViewCell
        }*/
        var countryCodeSer: [CountryCodeService] = self.countriesDict[self.countryHeaders[indexPath.section]]!;
        print(indexPath.row)
            let countryData: CountryCodeService = countryCodeSer[indexPath.row];
            countryCell.countryName.text = countryData.getName();
            countryCell.countryCode.text = countryData.getPhoneCode()
            countryCell.countryFlag.image = countryData.getFlagMasterResID(countryCode: countryData);
            //countryCell.countryFlag.frame = CGRect(0, 0, 100, 100)
            countryCell.countryFlag.layer.borderWidth = 1
            countryCell.countryFlag.layer.masksToBounds = true
            countryCell.countryFlag.layer.cornerRadius = countryCell.countryFlag.frame.width/2;          return countryCell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRow(at: indexPath!) as! CountryCodeTableViewCell;
        print(currentCell.countryCode.text);
        
        self.selectedCountryCodeDelegate?.selectedCountryCode(countryCode: currentCell.countryCode.text!);
        
        
        //self.performSegue(withIdentifier: "countryTableRowClickSegue", sender: self)
        
        //self.navigationController?.popViewController(animated: true);
        
        self.dismiss(animated: true, completion: nil )

    }

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SignupSetp1ViewController {
            
            let path = countryTable.indexPathForSelectedRow;
            let countryCell = countryTable.cellForRow(at: path!) as? CountryCodeTableViewCell
            vc.countryCode = (countryCell?.countryCode.text)!;
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.seacrhInputText.delegate = self;
        self.seacrhInputText.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = #imageLiteral(resourceName: "search_icon")
        self.seacrhInputText.leftView = imageView
        self.prepareData(searchText: "null");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func prepareData(searchText: String) {
        
        self.countryHeaders = [];
        self.countriesDict = ["": []];

        let countryCodeService = CountryCodeService();
        
        var countries: [CountryCodeService] = [];
        let countriesTemp: [CountryCodeService] = countryCodeService.getLibraryMasterCountriesEnglish();
        if (searchText == "null" || searchText.count == 0) {
            countries = countriesTemp;
        } else {
            
            for var idx in (0..<countriesTemp.count) {
                if ((countriesTemp[idx].getName().lowercased().range(of: searchText.lowercased())) != nil) {
                    countries.append(countriesTemp[idx]);
                }
            }
        }
        //var countryHeaderMap: [String: [String]] = ["": []];
        for i in (0..<countries.count) {
            
            let countryObject: CountryCodeService = countries[i];
            
            let header: String = String(countryObject.getName().prefix(1));
            
            if (!self.countryHeaders.contains(header)) {
                self.countryHeaders.append(header);
            }
            
            var countryCode: [CountryCodeService] = [];
            if (self.countriesDict[header] != nil) {
                countryCode = self.countriesDict[header]!;
            }
            countryCode.append(countryObject);
            self.countriesDict[header] = countryCode.sorted { $0.getName() < $1.getName()};
        }
        var headersTemp: [String] = self.countryHeaders;
        
        
        self.countryHeaders = headersTemp.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        
        self.countryTable.reloadData();

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.backgroundColor = UIColor.clear
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
