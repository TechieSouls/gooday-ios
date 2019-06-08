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
    
    var itemIndex: Int = 0;
    var imageName = "" {
        
        didSet {
            if let imageView = onbaordingImg {
                imageView.image = UIImage(named : imageName);
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onbaordingImg.image = UIImage(named : imageName);
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
