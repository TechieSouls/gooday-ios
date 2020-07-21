//
//  GatheringScrollPreviewViewController.swift
//  Cenes
//
//  Created by Cenes_Dev on 26/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class PublicGatheringPreviewViewController: UIViewController {

    @IBOutlet weak var gatheringScrollTableView: UITableView!
    
    var event: Event!;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gatheringScrollTableView.register(UINib.init(nibName: "GatheringInfoBeforePreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "GatheringInfoBeforePreviewTableViewCell");
        gatheringScrollTableView.register(UINib.init(nibName: "GatheringOwnerAndDesTableViewCell", bundle: nil), forCellReuseIdentifier: "GatheringOwnerAndDesTableViewCell");
        gatheringScrollTableView.register(UINib.init(nibName: "GatheringLocationWithImagesTableViewCell", bundle: nil), forCellReuseIdentifier: "GatheringInfoBeforePreviewTableViewCell");
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension PublicGatheringPreviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        return UITableViewCell();
    }
    
    
    
}
