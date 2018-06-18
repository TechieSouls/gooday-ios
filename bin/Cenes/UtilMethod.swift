//
//  UtilMethod.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/19/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

let lightGreyColor = "AAADAF"
let orangeNoTextColor = "F07852"

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class Util{
    
        class func intFromHexString(hexStr: String) -> UInt32 {
            var hexInt: UInt32 = 0
            // Create scanner
            let scanner = Scanner(string: hexStr)
            // Tell scanner to skip the # character
            scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
            // Scan hex value
            scanner.scanHexInt32(&hexInt)
            return hexInt
        }
        
        class func colorWithHexString(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
            
            // Convert hex string to an integer
            let hexint = Int(intFromHexString(hexStr: hexString))
            let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
            let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
            let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
            let alpha = alpha!
            
            // Create color object, specifying alpha as well
            let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            return color
        }
    
    class func getDateFromTimestamp(timeStamp:NSNumber) -> Date{
        let timeinterval : TimeInterval = timeStamp.doubleValue / 1000 // convert it in to NSTimeInteral
        let date = Date(timeIntervalSince1970:timeinterval) // you can the Date object from here
        
        return date
    }
    
    class func getAlarmStringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        let date = dateFormatter.string(from: date)
        return date
    }
    
    class func getTotalWeekdays(weekdays: [Int]) -> String {
        if weekdays.count == 7 {
            return "Every day"
        }
        
        if weekdays.isEmpty {
            return "Never"
        }
        
        var ret = String()
        var weekdaysSorted:[Int] = [Int]()
        
        weekdaysSorted = weekdays.sorted(by: <)
        
        for day in weekdaysSorted {
            switch day{
            case 1:
                ret += "S  "
            case 2:
                ret += "M  "
            case 3:
                ret += "T  "
            case 4:
                ret += "W  "
            case 5:
                ret += "T  "
            case 6:
                ret += "F   "
            case 7:
                ret += "S   "
            default:
                //throw
                break
            }
        }
        return ret
    }

    
    class func isValidEmail(testStr:String) -> Bool {
        
        
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: testStr)
        
        return result
    }
    
    class func isPwdLenth(password: String) -> Bool {
        
        if password.characters.count >= 4 {
            return true
        }else{
            return false
        }
    }
    
    class func isnameLenth(name: String) -> Bool {
        
        if name.characters.count > 0 {
            return true
        }else{
            return false
        }
    }
    
}
extension UIViewController
{
    func showAlert(title : String ,message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            print ("Ok")
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension UITextField{
    func addPaddingToTextField() {
        let paddingView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func createBorderedTextField() {
        //self.layer.borderColor = themeBorderColor.CGColor
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 1.0
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

extension UIImage {
    
    func compressImage(newSizeWidth: Float, newSizeHeight: Float, compressionQuality: Float) -> UIImage {
        let image = self
        let imgData: Data? = UIImageJPEGRepresentation(image, 1)
        //1 it represents the quality of the image.
        
        print("Size of Image(bytes):\(UInt((imgData?.count)!))")
        
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        let maxHeight: Float = newSizeHeight
        let maxWidth: Float = newSizeWidth
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = compressionQuality
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        var imageData: Data? = UIImageJPEGRepresentation(img!, CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        
        print("Size of Image(bytes):\(UInt((imageData?.count)!))")
        
        return UIImage(data: imageData!)!
        
    }
}

