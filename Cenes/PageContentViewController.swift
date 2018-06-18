//
//  PageContentViewController.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/11/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit


class PageContentViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var separatorView : UIView!
    
    var pageIndex: Int?
    var titleText : String!
    var imageName : String!
    var descText : String!
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.image.image = UIImage(named: imageName)
        self.label.text = self.titleText
        self.labelTwo.text = self.descText
        
        //separatorView.layer.cornerRadius = 5;
        separatorView.layer.shadowOffset = CGSize(width: 0, height: -1)
        separatorView.layer.shadowRadius = 1;
        separatorView.layer.shadowOpacity = 0.5;
        separatorView.layer.masksToBounds = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.  
    }
    
    
    /// Impimentaion of getStarted Button action
    /// Onbarding will be used only once when user launch firstime.
    /// We will set the value of onbarding as 1 which will be accessed in appdelegate class to choose the initial view controller
    /// - Parameter sender: <#sender description#>
    
    
   
}
