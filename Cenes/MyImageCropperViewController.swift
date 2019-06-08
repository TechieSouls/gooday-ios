//
//  MyImageCropperViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 07/06/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

protocol CreateGatherigV2Protocol {
    func imageAfterCrop(cropperdImage: UIImage);
}
class MyImageCropperViewController: UIViewController {

    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var chooseBtn: UIButton!
    
    @IBOutlet weak var imageCropView: UIView!
    
    var createGatherigV2ProtocolDelegate: CreateGatherigV2Protocol!
    var imageToCrop: UIImage!;
    //var editView: MyEditImageView!;

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func chooseBtnPressed(_ sender: Any) {
       //let image = editView.getCroppedImage();
        //createGatherigV2ProtocolDelegate.imageAfterCrop(cropperdImage: image);
        //self.dismiss(animated: true, completion: nil);
    }
}
