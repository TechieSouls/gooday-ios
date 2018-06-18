//
//  PCameraViewController.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 8/8/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import IoniconsSwift
import MobileCoreServices
class PCameraViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var separatorView : UIView!
    var imageSelected = false
    
    let picController = UIImagePickerController()
    class func MainViewController() -> UIViewController{
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profile")

        return viewController
        
    }

    
    override func viewWillLayoutSubviews() {
        
        print(self.image.bounds)
        let image = #imageLiteral(resourceName: "profile icon").compressImage(newSizeWidth: Float(self.image.bounds.width), newSizeHeight: Float(self.image.bounds.size.width), compressionQuality: 1.0)
        if self.image.image == nil {
        self.image.image = image
        self.image.layer.cornerRadius = 0//self.image.frame.size.width / 2 + 20
        self.image.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        separatorView.layer.shadowOffset = CGSize(width: 0, height: -1)
        separatorView.layer.shadowRadius = 1;
        separatorView.layer.shadowOpacity = 0.5;
        separatorView.layer.masksToBounds = false
        
        
        
        self.title = "Complete Your Profile"
        // Do any additional setup after loading the view.
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.text = String(format: "%@ \r %@ \r","Complete your profile so your","friends can recognize you")
        
        picController.delegate = self
        if(imageFacebookURL != nil)
        {
            let webServ = WebService()
            webServ.profilePicFromFacebook(url: imageFacebookURL!, completion: { image in
                self.image.image = image
                self.imageSelected = true
                self.image.layer.cornerRadius = self.image.frame.size.width / 2
                
            })
        }
        
    
    }
    
     func userDidSelectLater(sender: UIButton) {
        let holiday = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "holiday") as? WorldHolidayCalendarViewController
        self.navigationController?.pushViewController(holiday!, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        WebService().setPushToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
         if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picController.sourceType = UIImagePickerControllerSourceType.camera
            picController.delegate = self
            picController.allowsEditing = true
            picController.mediaTypes = [kUTTypeImage as String]
            present(picController, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectPicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                picController.delegate = self
                picController.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                picController.allowsEditing = true
                self.present(picController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.image.image = image
            self.imageSelected = true
            self.image.layer.cornerRadius = self.image.frame.size.width / 2
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    @IBAction  func userDidSelectNext(sender:UIButton){
        let webServ = WebService()
        
        if self.image.image != nil {
            let uploadImage = self.image.image?.compressImage(newSizeWidth: 100, newSizeHeight: 100, compressionQuality: 1.0)
            webServ.uploadProfilePic(image: uploadImage, complete: { (returnedDict) in
                appDelegate?.profileImageSet(image: self.image.image!)
            })
        }
        
//        let holiday = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "holiday") as? WorldHolidayCalendarViewController
//        self.navigationController?.pushViewController(holiday!, animated: true)
        //UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
    }
    
   /* @IBAction func doItLaterTapped(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
