//
//  OnboardingStep4ViewController.swift
//  Cenes
//
//  Created by Macbook on 18/08/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class OnboardingStep4ViewController: UIViewController {

    @IBOutlet weak var Step4Title: UILabel!
    
    @IBOutlet weak var Step4Description: UILabel!
    
    @IBOutlet weak var borderBottom: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Step4Title.text = onboardingStep4Title;
        //Step4Title.fs_top = 80
        Step4Title.frame = CGRect(x: 40, y: 100, width: 270, height: 200)

        Step4Title.textColor = UIColor.white
        Step4Title.adjustsFontSizeToFitWidth  = true
        Step4Title.font = Step4Title.font.withSize(40)
        Step4Title.sizeToFit()
        
        Step4Description.frame = CGRect(x: 30, y: 200, width: 270, height: 400)
        Step4Description.text = onboardingStep4Desc;
        Step4Description.padding = UIEdgeInsets(top: 25, left: 15, bottom: 25, right: 15)
        Step4Description.font =  Step4Description.font.withSize(20)
        Step4Description.numberOfLines = 0;
        Step4Description.textColor = UIColor.white
        Step4Description.adjustsFontSizeToFitWidth = true
        Step4Description.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        let attrString = NSMutableAttributedString(string: onboardingStep4Desc)
        var style = NSMutableParagraphStyle()
        style.lineSpacing = 5 // change line spacing between paragraph like 36 or 48
        //style.minimumLineHeight = 20 // change line spacing between each line like 30 or 40
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: onboardingStep4Desc.characters.count))
        Step4Description.attributedText = attrString
        // Do any additional setup after loading the view.
        
        borderBottom.frame = CGRect(0,self.view.bounds.height - 60, self.view.bounds.width, 1.0)
        borderBottom.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        
        if let insets = padding {
            textWidth -= insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedStringKey.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        
        return contentSize
    }
}


