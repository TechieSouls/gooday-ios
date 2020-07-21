//
//  PublicGatheringPreviewViewController.swift
//  Cenes
//
//  Created by Cenes_Dev on 03/07/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class PublicGatheringPreviewViewController: UIViewController {

    @IBOutlet weak var publicGatheringTableView: UITableView!
    @IBOutlet weak var postEventBtn: UIButton!

    var event: Event!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
           publicGatheringTableView.register(UINib(nibName: "GatheringInfoBeforePreviewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringInfoBeforePreviewTableViewCell")

           publicGatheringTableView.register(UINib(nibName: "GatheringImageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringImageTableViewCell")
           
           publicGatheringTableView.register(UINib(nibName: "GatheringOwnerAndDesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringOwnerAndDesTableViewCell")

           publicGatheringTableView.register(UINib(nibName: "GatheringLocationWithImagesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringLocationWithImagesTableViewCell");
               
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

extension PublicGatheringPreviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
            case 0:
            
                break;
            case 1:
            
                break;
            case 3:
            
                break;
            case 4:
            
                break;
            
            default:
                return UITableViewCell();
        }
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
            
            case 0:
                
                break;
            default:
                return 0;
        }
        
        return 0;
    }
}
