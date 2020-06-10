//
//  ImageSliderViewController.swift
//  Cenes
//
//  Created by Cenes_Dev on 10/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class ImageSliderViewController: UIViewController {

    @IBOutlet weak var imageSliderScrollView: UIScrollView!;
    @IBOutlet weak var imageSliderPageControl: UIPageControl!;
    @IBOutlet weak var backButton: UIButton!;

    var photos: [String]!;
    var selectedIndex: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        self.imageSliderPageControl.numberOfPages = photos.count;
        self.imageSliderPageControl.currentPage = selectedIndex;
        createImageSlider();
        self.imageSliderScrollView.isPagingEnabled = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func createImageSlider() {
        
        var contentSizeOfScrollView: CGFloat = 0.0;
        for subView in  imageSliderScrollView.subviews {
            subView.removeFromSuperview();
        }
        for img in photos {
            
            let sliderImage = UIImageView();
            sliderImage.frame = CGRect.init(x: contentSizeOfScrollView, y: 0, width: self.view.frame.width, height: imageSliderScrollView.frame.height);
            sliderImage.sd_setImage(with: URL.init(string: img), completed: nil);
            sliderImage.contentMode = .scaleAspectFit;
            contentSizeOfScrollView = contentSizeOfScrollView + self.view.frame.width;
            imageSliderScrollView.addSubview(sliderImage);
        }
        imageSliderScrollView.contentSize.width = contentSizeOfScrollView;
        
        let xOffset = self.view.frame.width * CGFloat(selectedIndex);
        let point = CGPoint(x: xOffset, y: 0);
        self.imageSliderScrollView.contentOffset = point
        self.imageSliderPageControl.currentPage = selectedIndex;
    }
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        self.navigationController?.popViewController(animated: true);
    }

}

extension ImageSliderViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        self.imageSliderPageControl.currentPage = Int(pageIndex)
        
    }
}
