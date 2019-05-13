//
//  SelectedCalendarViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class SelectedCalendarViewController: UIViewController {

    @IBOutlet weak var selectedCalendarTableView: UITableView!
    
    var calendarSelected: String!;
    var holidayCountries: [String]!;
    var cenesProperty: CenesProperty!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = themeColor;
        selectedCalendarTableView.backgroundColor = themeColor;
        
        selectedCalendarTableView.register(UINib.init(nibName: "ThirdPartyCalendarTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ThirdPartyCalendarTableViewCell");
        
        selectedCalendarTableView.register(UINib.init(nibName: "HolidayCalendarTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HolidayCalendarTableViewCell");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
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

class SelectedCalendar {
    static let HolidayCalendar: String = "Holiday";
    static let GoogleCalendar: String = "Google";
    static let OutlookCalendar: String = "Outlook";
    static let AppleCalendar: String = "Apple"
    
}
