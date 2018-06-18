import Foundation
import UIKit

protocol IconDownloaderDelegate: class {
    func iconDownloaderDidFinishDownloadingImage(_ iconDownloader: IconDownloader, error: NSError?)
}

class IconDownloader {
    static let iconSize = CGFloat(48)

    weak var delegate: IconDownloaderDelegate?

    var cenesUser: CenesUser!
    var cenesEventData : CenesCalendarData!
    var notificationData : NotificationData!
    var photoDiary : PhotoModel!
    var indexPath: IndexPath
    var sessionTask: URLSessionDataTask?
    
    init(cenesUser: CenesUser!,cenesEventData: CenesCalendarData!,notificationData : NotificationData!, indexPath: IndexPath ,photoDiary :PhotoModel!) {
        self.cenesUser = cenesUser
        self.cenesEventData = cenesEventData
        self.indexPath = indexPath
        self.notificationData = notificationData
        self.photoDiary = photoDiary
    }
    
    
    func startDownload() {
        
        var request : URLRequest!
        if cenesUser != nil{
            request = URLRequest(url: URL(string: self.cenesUser.photoUrl)!)
        }else if cenesEventData != nil {
            request = URLRequest(url: URL(string: self.cenesEventData.eventImageURL)!)
        }else if notificationData != nil {
            request = URLRequest(url: URL(string: self.notificationData.notificationImageURL)!)
        }else if photoDiary != nil {
            request = URLRequest(url: URL(string: self.photoDiary.diaryPhotoUrl)!)
        }
        
        self.sessionTask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error as NSError? {
                if error.code == NSURLErrorAppTransportSecurityRequiresSecureConnection {
                    // If you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                    // then your Info.plist has not been properly configured to match the target server.
                    fatalError()
                } else {
                    self.delegate?.iconDownloaderDidFinishDownloadingImage(self, error: error as NSError?)
                }
            } else {
                OperationQueue.main.addOperation {
                    guard let data = data else { return }
                    guard let image = UIImage(data: data) else { return }
                    if image.size.width == IconDownloader.iconSize && image.size.height == IconDownloader.iconSize {
                        let itemSize = CGSize(width: IconDownloader.iconSize, height: IconDownloader.iconSize)
                        UIGraphicsBeginImageContextWithOptions(itemSize, false, 0)
                        let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
                        image.draw(in: imageRect)
                        if self.cenesUser != nil{
                            self.cenesUser.profileImage = UIGraphicsGetImageFromCurrentImageContext()
                        }else if self.cenesEventData != nil {
                            self.cenesEventData.eventImage = UIGraphicsGetImageFromCurrentImageContext()
                        }else if self.notificationData != nil {
                            self.notificationData.notificationImage = UIGraphicsGetImageFromCurrentImageContext()
                        }else if self.photoDiary != nil {
                            self.photoDiary.diaryPhoto = UIGraphicsGetImageFromCurrentImageContext()
                        }
                        
                        UIGraphicsEndImageContext()
                    } else {
                        if self.cenesUser != nil{
                            self.cenesUser.profileImage = image
                        }else if self.cenesEventData != nil {
                            self.cenesEventData.eventImage = image
                        }else if self.notificationData != nil {
                            self.notificationData.notificationImage = image
                        }else if self.photoDiary != nil {
                            self.photoDiary.diaryPhoto = image
                        }
                    }
                    self.delegate?.iconDownloaderDidFinishDownloadingImage(self, error: nil)
                }
            }
        }) 

        self.sessionTask?.resume()
    }

    func cancelDownload() {
        self.sessionTask?.cancel()
    }
}
