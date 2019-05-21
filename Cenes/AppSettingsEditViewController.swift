//
//  AppSettingsEditViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class AppSettingsEditViewController: UIViewController {

    @IBOutlet weak var appSettingsEditTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appSettingsEditTableView.register(UINib.init(nibName: "DeleteAccountTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DeleteAccountTableViewCell");
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func navigateToCountryList() {
        let navController = storyboard?.instantiateViewController(withIdentifier: "CountriesViewController") as! CountriesViewController;
        self.navigationController?.pushViewController(navController, animated: true);
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
        return cell;
    }
}
