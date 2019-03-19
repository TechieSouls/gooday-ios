//
//  GatheringTableViewCellThree.swift
//  Cenes
//
//  Created by Redblink on 05/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit


class GatheringPeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendsView: UICollectionView!
    var imageDownloadsInProgress = [IndexPath : IconDownloader]()
    
    @IBOutlet weak var lowerView: UIView!
    var createGatheringView : CreateGatheringViewController!
    
    var showArray = [Bool]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.friendsView.register(UINib(nibName: "FriendsViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "friendCell")
        // Initialization code
    }
    
    func setShowArray(){
        if (self.createGatheringView.event != nil && self.createGatheringView.event.eventMembers != nil) {
            for _ in self.createGatheringView.event.eventMembers {
                self.showArray.append(false)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadFriends(){
        self.friendsView.reloadData()
    }
    
}

extension GatheringPeopleTableViewCell : UICollectionViewDataSource ,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (createGatheringView.event.eventMembers != nil) {
            return createGatheringView.event.eventMembers.count
        }
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! FriendsViewCell
        
        //let user = createGatheringView.selectedFriends[indexPath.row]
        
        let eventMember = createGatheringView.event.eventMembers[indexPath.row];
        
        cell.nameLabel.text =  eventMember.name
        
        //if self.createGatheringView.loadSummary == false {
            cell.addGestureRecognizer(longPressGesture())
        //}
        cell.tag = indexPath.row
        cell.crossButotn.tag = indexPath.row
        
        if self.showArray[indexPath.row] == true {
            cell.crossButotn.isHidden = false
            cell.backWhiteView.isHidden = false
        }else{
            cell.crossButotn.isHidden = true
            cell.backWhiteView.isHidden = true
        }
        
        cell.cellThree = self
        cell.indexPath = indexPath
        /*if let icon = user.profileImage {
            cell.profileImage.image = icon
        } else {
            if user.photoUrl != nil && user.photoUrl != ""{
                self.startIconDownload(cenesUser: user, forIndexPath: indexPath)
                cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
            }else{
                cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
            }
            
        }*/
         /* if user.photo != nil && user.photo != ""{
            WebService().profilePicFromFacebook(url: user.photo, completion: { image in
                cell.profileImage.image = image
            });
         }else{
                cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
        } */
        
        if eventMember.user != nil && eventMember.user.photo != nil {
            WebService().profilePicFromFacebook(url: eventMember.user.photo, completion: { image in
                cell.profileImage.image = image
            });
        } else {
            cell.profileImage.image = #imageLiteral(resourceName: "cenes_user_no_image")
        }
        return cell
    }
    
    
    func longPressGesture() -> UILongPressGestureRecognizer {
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(GatheringPeopleTableViewCell.longPress))
        lpg.minimumPressDuration = 0.5
        return lpg
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        print(sender.view?.tag)
        
        if sender.state == .began {
        let cell = sender.view as! FriendsViewCell
        
        cell.crossButotn.isHidden = false
        cell.backWhiteView.isHidden = false
            
        self.showArray[(sender.view?.tag)!] = true
        
        cell.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
            
            cell.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            
        }, completion:{(success) in
            
        })
        }
    }
    
    func deleteCEll(tag:Int,cell:FriendsViewCell){
        print("\(tag) to be Deleted")
        //self.createGatheringView.FriendArray.remove(at: tag)
        self.createGatheringView.event.eventMembers.remove(at: tag)
        self.friendsView.deleteItems(at: [cell.indexPath])
        self.showArray.remove(at: tag)
        self.friendsView.reloadItems(at: self.friendsView.indexPathsForVisibleItems)
        self.createGatheringView.gatheringTableView.reloadData()
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
        let allDownloads = Array(self.imageDownloadsInProgress.values)
        allDownloads.forEach { $0.cancelDownload() }
        self.imageDownloadsInProgress.removeAll()
    }
    
    func loadImagesForOnscreenRows() {
        //guard self.createGatheringView.FriendArray.count != 0 else { return }
         guard self.createGatheringView.event.eventMembers.count != 0 else { return }
        let visibleIndexPaths = self.friendsView.indexPathsForVisibleItems
        for indexPath in visibleIndexPaths {
            /*let cenesUser = self.createGatheringView.FriendArray[indexPath.row]
            if cenesUser.profileImage == nil {
                if cenesUser.photoUrl != nil && cenesUser.photoUrl != ""{
                    self.startIconDownload(cenesUser: cenesUser, forIndexPath: indexPath)
                }
            }else{
                
            }*/
            
            let eventMem = self.createGatheringView.event.eventMembers[indexPath.row]
            
            if eventMem.user == nil && eventMem.user.photo == nil {
                //if cenesUser.photoUrl != nil && cenesUser.photoUrl != ""{
                 //   self.startIconDownload(cenesUser: cenesUser, forIndexPath: indexPath)
                //}
            } else {
                
            }
            
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         self.loadImagesForOnscreenRows()
    }
    
}

extension GatheringPeopleTableViewCell: IconDownloaderDelegate {
    func iconDownloaderDidFinishDownloadingImage(_ iconDownloader: IconDownloader, error: NSError?) {
        guard let cell = self.friendsView.cellForItem(at:iconDownloader.indexPath as IndexPath) as? FriendsViewCell else {
            print("Not got cell")
            self.friendsView.reloadItems(at: [iconDownloader.indexPath])
            return }
        if let error = error {
            print("error downloading Image")
            //fatalError("Error loading thumbnails: \(error.localizedDescription)")
        } else {
            cell.profileImage?.image = iconDownloader.cenesUser.profileImage
          //  print(iconDownloader.cenesUser.name+" user profile updated")
        }
        self.imageDownloadsInProgress.removeValue(forKey: iconDownloader.indexPath as IndexPath)
    }
}
