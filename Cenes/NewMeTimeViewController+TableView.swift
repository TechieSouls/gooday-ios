//
//  NewMeTimeViewController+TableView.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension NewMeTimeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell();
        switch indexPath.row {
        case 0:
            let identifier = "MeTimeDescTableViewCell"
            cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeDescTableViewCell)!
        default:
            let identifier = "MeTimeItemTableViewCell"
            cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeItemTableViewCell)!
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 100;
        default:
            return 100;
        }
    }
}
