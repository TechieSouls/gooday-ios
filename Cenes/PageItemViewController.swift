//
//  PageItemViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 05/06/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class PageItemViewController: UIViewController {

    @IBOutlet weak var onbaordingImg: UIImageView!
    
    @IBOutlet weak var obTitle: UILabel!
    
    @IBOutlet weak var obDescription: UILabel!
    
    var itemIndex: Int = 0;
    var imageName = "" {
        
        didSet {
            if let imageView = self.onbaordingImg {
                imageView.image = UIImage(named : imageName);
            }
        }
    }
    
    var uititleStr = "" {
        didSet {
            if let uititle = obTitle {
                uititle.text = uititleStr
            }
        }
    }
    
    var uiDescStr = "" {
        didSet {
            if let uititle = obTitle {
                uititle.text = uiDescStr
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //onbaordingImg.image = UIImage(named : imageName);
        //obTitle.text = uititleStr;
        //obDescription.text = uiDescStr;
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
