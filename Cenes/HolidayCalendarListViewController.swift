//
//  HolidayCalendarListViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 12/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class HolidayCalendarListViewController: UIViewController {

    @IBOutlet weak var searchCountryTextBox: UITextField!
    
    @IBOutlet weak var countryListTableView: UITableView!
    
    var countryDataArray = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = themeColor;
        
        countryListTableView.register(UINib(nibName: "CountryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CountryTableViewCell")
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HolidayCalendarListViewController: UITextViewDelegate {
    
}

extension HolidayCalendarListViewController: UITableViewDelegate, UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        //cell.countryName = self;
        //cell.countryFlag =
        
        
        return UITableViewCell();
    }
}
