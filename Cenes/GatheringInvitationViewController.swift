//
//  GatheringInvitationViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GatheringInvitationViewController: UIViewController {

    
    @IBOutlet weak var acceptedImageView: UIImageView!
    
    @IBOutlet weak var rejectedImageiew: UIImageView!
    
    var divisor : CGFloat!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        acceptedImageView.alpha = 0;
        rejectedImageiew.alpha = 0;
        
        //35 degree angle from center
        divisor = ((self.view.frame.width / 2) / 0.56)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        acceptedImageView.alpha = 0;
        rejectedImageiew.alpha = 0;
    }
    
    @IBAction func panToImageView(_ sender: UIPanGestureRecognizer) {
        
        let imageCard = sender.view!;
        
        let point = sender.translation(in: view);
        let xFromCenter = imageCard.center.x - self.view.center.x;
        let yFromCenter = imageCard.center.y - self.view.center.y;
        
        print("X From Center : ",xFromCenter, "y From Center : ", imageCard.center.y - self.view.center.y)
        
        imageCard.center = CGPoint(x: view.center.x+point.x, y: view.center.y+point.y);
        
        // 180 degree = 3.14 radian. We want 35 decree inclinition
        if (yFromCenter > -30) {
            if (xFromCenter < 0) {
                imageCard.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor);
                let rejectedAlpha = abs(xFromCenter) / self.view.center.x;
                rejectedImageiew.alpha = rejectedAlpha;
            } else {
                imageCard.transform = CGAffineTransform(rotationAngle:xFromCenter/divisor);
                let acceptedAlpha = abs(xFromCenter) / self.view.center.x;
                acceptedImageView.alpha = acceptedAlpha;
            }
        } else {
            imageCard.transform = .identity;
        }
        
        //The inviation card will move to center when the finger is up
        if (sender.state == UIGestureRecognizerState.ended) {
            UIView.animate(withDuration: 0.2, animations: {
                imageCard.center = self.view.center;
                imageCard.transform = .identity
                self.acceptedImageView.alpha = 0;
                self.rejectedImageiew.alpha = 0;
            })
        }
       
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
