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
import CoreData

let lightGreyColor = "AAADAF"
let orangeNoTextColor = "F07852"

let appDelegate = UIApplication.shared.delegate as? AppDelegate

func getPersistentContainer() -> NSPersistentContainer{
    let persistentContainer = NSPersistentContainer(name: "Cenes")
    persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return persistentContainer
}

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
    
    class func isPhoneLength(phone: String) -> Bool {
        if phone.characters.count > 0 {
            return true
        } else {
            return false
        }
    }
    
  class  func getTimeFromTimestamp(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.string(from: dateFromServer as Date)
        
        return date
    }
    
    class  func hhmma(timeStamp: Int64) -> String{
        let timeinterval : TimeInterval = Double(timeStamp) / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.string(from: dateFromServer as Date)
        
        return date
    }
    
    class func getddMMMEEEE(timeStamp: Int64) -> String{
        let timeinterval : TimeInterval = Double(timeStamp) / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        //.dateFormat = "h:mm a"
        dateFormatter.dateFormat = "dMMM"
        var date1Str = dateFormatter.string(from: dateFromServer as Date).uppercased()
        
        dateFormatter.dateFormat = "EEEE"
        let date2Str = dateFormatter.string(from: dateFromServer as Date).uppercased()
        return "\(date1Str) \(date2Str)";
    }
    
   class func getDateString(timeStamp:String)-> String {
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        var dateString = dateFormatter.string(from: dateFromServer as Date)
        dateString += "\n"
        dateFormatter.dateFormat = "EEE"
        dateString += dateFormatter.string(from: dateFromServer as Date)
        return dateString
    }
    
    class func getDateFromTimestamp(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        //.dateFormat = "h:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.string(from: dateFromServer as Date).capitalized
        
        let dateobj = dateFormatter.date(from: date)
        
        
        dateFormatter.dateFormat = "EEEE, MMMM d"
        date = dateFormatter.string(from: dateFromServer as Date).capitalized
        if NSCalendar.current.isDateInToday(dateobj!) == true {
            date = "TODAY \(date)"
        }else if NSCalendar.current.isDateInTomorrow(dateobj!) == true{
            date = "TOMORROW \(date)"
        }
        
        
        return date
    }
    
    class func getDiaryDateFromTimestamp(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        //.dateFormat = "h:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.string(from: dateFromServer as Date).capitalized
        
        let dateobj = dateFormatter.date(from: date)
        
        
        dateFormatter.dateFormat = "EEEE, MMMM d"
        date = dateFormatter.string(from: dateFromServer as Date).capitalized
        return date
    }
    
    class func getDiaryInfoDateString(timeStamp:String)-> String {
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        let dateString = dateFormatter.string(from: dateFromServer as Date)
        return dateString
    }
    
    class func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
    }
    
    func hoursBetweenDates(startDate: Date, endDate: Date) -> Int {
        let distanceBetweenDates: TimeInterval? = endDate.timeIntervalSince(startDate)
        let secondsInAnHour: Double = 3600
        //let secondsInDays: Double = 86400
        //let secondsInWeek: Double = 604800
        
        let hoursBetweenDates = Int((distanceBetweenDates! / secondsInAnHour))
        //let daysBetweenDates = Int((distanceBetweenDates! / secondsInDays))
        //let weekBetweenDates = Int((distanceBetweenDates! / secondsInWeek))
        return hoursBetweenDates;
    }
    
    static var GOOGLE_SERVER_ID = "54828242588-k1gmql38960e0b30fjs4qq6477um040m.apps.googleusercontent.com";
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
    
    func addPaddingToTextFieldProfileView() {
        let paddingView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
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
        return true
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64(self.timeIntervalSince1970 * 1000.0)
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
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

