//
//  HomeTableViewCellOne.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/23/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import IoniconsSwift

class HomeTableViewCellOne: UITableViewCell {
    
    var imageDownloadsInProgress = [IndexPath : IconDownloader]()
    
    @IBOutlet weak var eventView: UIView!
    
    @IBOutlet weak var friendsView: UICollectionView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var timeSubTitle: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!    
    @IBOutlet weak var image3: UIImageView!
    
    var FriendArray = [CenesUser]()
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var eventsImageOuterView: UIView!
    
    var HomeView : HomeViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        // Initialization code
        //timeImage.image = Ionicons.iosCircleOutline.image(25, color: UIColor.gray)
        timeSubTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        timeSubTitle.numberOfLines = 0
        timeTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        timeTitle.numberOfLines = 0
        locationView.isHidden = true
        eventsImageOuterView.isHidden = true
        self.friendsView.register(UINib(nibName: "HomeUserCellFirst", bundle: Bundle.main), forCellWithReuseIdentifier: "HomeUserCellFirst")
        self.friendsView.register(UINib(nibName: "HomeUserCellLast", bundle: Bundle.main), forCellWithReuseIdentifier: "HomeUserCellLast")
        
    }
    
    override func prepareForReuse() {
        print("preppare for reuse \(self.FriendArray.count))")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadFriends(){
       // print("Reloading data for \(self.timeLabel.text!) ")
        self.friendsView.reloadData()
    }
}

extension HomeTableViewCellOne : UICollectionViewDataSource ,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FriendArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row != 3{
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeUserCellFirst", for: indexPath) as! HomeUserCellFirst
        
        let user = FriendArray[indexPath.row]
        
        if let icon = user.profileImage {
            cell.profileImageView.image = icon
        } else {
            if user.photoUrl != nil && user.photoUrl != "" {
                self.startIconDownload(cenesUser: user, forIndexPath: indexPath)
                cell.profileImageView.image = #imageLiteral(resourceName: "profile icon")
            }else{
                cell.profileImageView.image = #imageLiteral(resourceName: "profile icon")
            }
            
        }
        
            if user.isOwner == true {
                cell.starImageView.isHidden = false
            }else{
                cell.starImageView.isHidden = true
            }
            
            
            
        return cell
        }else{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeUserCellLast", for: indexPath) as! HomeUserCellLast
            
            cell.countLabel.text = "+\(-3 + FriendArray.count)"
            
            return cell
        }
        
    }
    
    
    
    
    
    
    
    
    func startIconDownload(cenesUser: CenesUser, forIndexPath indexPath: IndexPath) {
        guard self.imageDownloadsInProgress[indexPath] == nil else { return }
        
        let iconDownloader = IconDownloader(cenesUser: cenesUser, cenesEventData: nil, notificationData: nil, indexPath: indexPath, photoDiary: nil)
        iconDownloader.delegate = self
        self.imageDownloadsInProgress[indexPath] = iconDownloader
        iconDownloader.startDownload()
       // print(cenesUser.name+" started download")
    }
    
    func terminateAllDownloads() {
        print("Terminated All Downloads")
        let allDownloads = Array(self.imageDownloadsInProgress.values)
        allDownloads.forEach { $0.cancelDownload() }
        self.imageDownloadsInProgress.removeAll()
    }
    
    func loadImagesForOnscreenRows() {
        guard self.FriendArray.count != 0 else { return }
        
        let visibleIndexPaths = self.friendsView.indexPathsForVisibleItems
        for indexPath in visibleIndexPaths {
            let cenesUser = self.FriendArray[indexPath.row]
            if cenesUser.profileImage == nil {
                if cenesUser.photoUrl != nil && cenesUser.photoUrl != "" {
                    self.startIconDownload(cenesUser: cenesUser, forIndexPath: indexPath)
                }
            }else{
                
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.loadImagesForOnscreenRows()
    }
    
}

extension HomeTableViewCellOne: IconDownloaderDelegate {
    func iconDownloaderDidFinishDownloadingImage(_ iconDownloader: IconDownloader, error: NSError?) {
        guard let cell = self.friendsView.cellForItem(at:iconDownloader.indexPath as IndexPath) as? HomeUserCellFirst else {
            //self.HomeView.tableView.reloadData()
            print("Not got cellCollectiionView")
            return }
        if let error = error {
            print("error downloading Image")
            //fatalError("Error loading thumbnails: \(error.localizedDescription)")
        } else {
            cell.profileImageView?.image = iconDownloader.cenesUser.profileImage
           // print(iconDownloader.cenesUser.name+" user profile updated")
        }
        self.imageDownloadsInProgress.removeValue(forKey: iconDownloader.indexPath as IndexPath)
    }
}

