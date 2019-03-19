//
//  NewMeTimeViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class NewMeTimeViewController: UIViewController {

    @IBOutlet weak var meTimeItemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = themeColor;
        meTimeItemsTableView.backgroundColor = themeColor;
        
        meTimeItemsTableView.register(UINib(nibName: "MeTimeDescTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MeTimeDescTableViewCell")
        meTimeItemsTableView.register(UINib(nibName: "MeTimeItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MeTimeItemTableViewCell")
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
