//
//  HomeViewController+extension.swift
//  Deploy
//
//  Created by Cenes_Dev on 12/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension NewHomeViewController :UITableViewDataSource,UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.homeDtoList.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeDtoList[section].sectionObjects.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let event = self.homeDtoList[indexPath.section].sectionObjects[indexPath.row];
        
        if (event.scheduleAs == "Event") {
            let identifier = "HomeCalendarTableViewCell"
            let cell: HomeCalendarTableViewCell! = self.homeTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeCalendarTableViewCell
            cell.calendarType.text = event.source;
            cell.calendarTitle.text = event.title
            return cell;
        } else if (event.scheduleAs == "Gathering") {
            let identifier = "HomeEventTableViewCell"
            let cell: HomeEventTableViewCell! = self.homeTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeEventTableViewCell
                cell.title.text = event.title;
                cell.time.text = Util.hhmma(timeStamp: Date.init(millis: event.startTime).toMillis())
                if (event.location != nil) {
                    cell.location.text = event.location;
                }
            return cell;
        } else if (event.scheduleAs == "Holiday") {
            let identifier = "HomeCalendarTableViewCell"
            let cell: HomeCalendarTableViewCell! = self.homeTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeCalendarTableViewCell
            cell.calendarTitle.text = event.title!
            //cell.calendarTitle.text = event.title
            return cell;
        }
        
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionTitle = self.homeDtoList[section].sectionName as! String
        
        print(sectionTitle);
        
        let identifier = "HomeEventHeaderViewCell"
        let cell: HomeEventHeaderViewCell! = self.homeTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeEventHeaderViewCell
        
        cell.headerLabel.text = sectionTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0;
    }
    
}
