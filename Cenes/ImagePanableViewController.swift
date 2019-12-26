//
//  ImagePanableViewController.swift
//  Cenes
//
//  Created by Cenes_Dev on 24/12/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class ImagePanableViewController: UIViewController {

    @IBOutlet weak var profilePicEnlarged: UIImageView!;
    var profilePicEnlargedTemp: UIImageView!;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.profilePicEnlarged.image = profilePicEnlargedTemp.image;
        
        self.profilePicEnlarged.isUserInteractionEnabled = true;
        let tapGuestureListener = UITapGestureRecognizer.init(target: self, action: #selector(zoomedImageTapped));
        self.profilePicEnlarged.addGestureRecognizer(tapGuestureListener);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func zoomedImageTapped() {
        self.dismiss(animated: true, completion: nil);
    }

}
