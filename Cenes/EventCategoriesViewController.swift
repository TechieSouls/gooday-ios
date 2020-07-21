//
//  EventCategoriesViewController.swift
//  Cenes
//
//  Created by Cenes_Dev on 30/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class EventCategoriesViewController: UIViewController {

    @IBOutlet weak var eventCategoriesTableView: UITableView!;
    
    var eventCategories = [EventCategory]();
    var event: Event!;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any addi  tional setup after loading the view.
        eventCategoriesTableView.register(UINib(nibName: "EventCategoryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "EventCategoryTableViewCell"); 

        eventCategories = sqlDatabaseManager.findAllEventCategories();
        self.title = "Your Public Event";
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

extension EventCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventCategories.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eventCategory = eventCategories[indexPath.row];
            let cell: EventCategoryTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "EventCategoryTableViewCell") as? EventCategoryTableViewCell)!
        cell.categoryTitle.text = eventCategory.name;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CreatePublicGatheringViewController") as! CreatePublicGatheringViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
}

