//
//  DiaryCellOne.swift
//  Cenes
//
//  Created by Redblink on 13/11/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class DiaryCellOne: UITableViewCell {
    
    @IBOutlet weak var titleTF: UITextField!
    
    var createDiary : CreateDiaryViewController!
    
    @IBOutlet weak var timeTF: UITextField!
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var photosHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var friendsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryTF: UITextField!
    
    @IBOutlet weak var photosTF: UITextField!
    
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var addFriendsTF: UITextField!
    
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    
    var showArrayFriends = [Bool]()
    
    
    func setShowArrayFriends(){
        for _ in self.createDiary.diaryData.eventUsers {
            self.showArrayFriends.append(false)
        }
    }
    var showArrayPhotos = [Bool]()

    
    func setShowArrayPhotos(){
        for _ in self.createDiary.diaryData.diaryPhotoModel{
            self.showArrayPhotos.append(false)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyBoard))
        self.addGestureRecognizer(tapGesture)
        self.friendsCollectionView.register(UINib(nibName: "FriendsViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "friendCell")
        self.photosCollectionView.register(UINib(nibName: "PhotosCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PhotosCell")
        self.friendsCollectionView.register(UINib(nibName: "FriendsAddCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FriendsAddCell")
        
        
        
        // Initialization code
    }
    
    
    
    func setEdit(){
        self.setShowArrayPhotos()
        self.setShowArrayFriends()
    }
    
    
    @IBAction func deletePressed(_ sender: Any) {
        self.createDiary.deleteDiary()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func hideKeyBoard(){
        self.titleTF?.resignFirstResponder()
        self.timeTF?.resignFirstResponder()
        self.entryTF?.resignFirstResponder()
        self.photosTF?.resignFirstResponder()
        self.addFriendsTF?.resignFirstResponder()
        self.locationTF?.resignFirstResponder()
    }
    
    
    func deleteCEll(tag:Int,cell:FriendsViewCell){
        print("\(tag) to be Deleted")
        self.createDiary.diaryData.eventUsers.remove(at: tag)
        if createDiary.diaryData.eventUsers.count == 0 {
            self.showArrayFriends.remove(at: tag)
             self.createDiary.setUPHeight()
        }else{
        self.friendsCollectionView.deleteItems(at: [cell.indexPath])
        self.showArrayFriends.remove(at: tag)
        self.friendsCollectionView.reloadItems(at: self.friendsCollectionView.indexPathsForVisibleItems)
        self.createDiary.setUPHeight()
        }
    }
    
    func deletePhotoCEll(tag:Int,cell:PhotosCell){
        print("\(tag) to be Deleted")
        self.createDiary.diaryData.diaryPhotoModel.remove(at: tag)
        self.photosCollectionView.deleteItems(at: [cell.indexPath])
        self.showArrayPhotos.remove(at: tag)
        self.photosCollectionView.reloadItems(at: self.photosCollectionView.indexPathsForVisibleItems)
        self.createDiary.setUPHeight()
    }
    
}


extension DiaryCellOne : UICollectionViewDataSource ,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == friendsCollectionView {
            if createDiary.diaryData.eventUsers.count == 0 {
                return 0
            }else{
            return createDiary.diaryData.eventUsers.count + 1
            }
        }else{
            return createDiary.diaryData.diaryPhotoModel.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.friendsCollectionView {
        
            if indexPath.row != self.createDiary.diaryData.eventUsers.count {
        let  cell = friendsCollectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! FriendsViewCell
        
        let friend = createDiary.diaryData.eventUsers[indexPath.row]
        
        cell.nameLabel.text =  friend.name
            
        cell.addGestureRecognizer(self.longPressGesture())
        
        cell.tag = indexPath.row
        cell.indexPath = indexPath
        cell.crossButotn.tag = indexPath.row
        
        
        if self.showArrayFriends[indexPath.row] == true {
            cell.crossButotn.isHidden = false
            cell.backWhiteView.isHidden = false
        }else{
            cell.crossButotn.isHidden = true
            cell.backWhiteView.isHidden = true
        }
        
        cell.cellDiary = self
        
        let photoUrl1 = friend.photoUrl
            
            if let icon = friend.profileImage {
                cell.profileImage.image = icon
            } else {
                if friend.photoUrl != nil && friend.photoUrl != ""{
                    WebService().profilePicFromFacebook(url: photoUrl1!, completion: { image in
                        cell.profileImage.image = image
                    })
                }else{
                    cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
                }
                
            }
            
        return cell
            }else{
                let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsAddCell", for: indexPath) as! FriendsAddCell
                cell.createDiary = self.createDiary
                return cell
            }
        }else{
            
            
            let  cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
            
            let photo = createDiary.diaryData.diaryPhotoModel[indexPath.row]
            
            cell.addGestureRecognizer(self.longPressGesture())
            
            cell.tag = indexPath.row
            cell.indexPath = indexPath
            cell.crossButton.tag = indexPath.row
            
            if self.showArrayPhotos[indexPath.row] == true {
                cell.crossButton.isHidden = false
                cell.backWhiteView.isHidden = false
            }else{
                cell.crossButton.isHidden = true
                cell.backWhiteView.isHidden = true
            }
            
            cell.cellDiary = self

            cell.AddedImage.image = photo.diaryPhoto
            return cell
        }
    }
    
    func longPressGesture() -> UILongPressGestureRecognizer {
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(DiaryCellOne.longPress))
        lpg.minimumPressDuration = 0.5
        return lpg
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            
            let cell = sender.view as? FriendsViewCell
            let cell2 = sender.view as? PhotosCell
            if cell != nil {
                cell?.crossButotn.isHidden = !(cell?.crossButotn.isHidden)!
                cell?.backWhiteView.isHidden = !(cell?.backWhiteView.isHidden)!
                self.showArrayFriends[(sender.view?.tag)!] = true
                cell?.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
                
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
                    
                    cell?.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                    
                }, completion:{(success) in
                    
                })
            }
            if cell2 != nil {
                cell2?.crossButton.isHidden = !(cell2?.crossButton.isHidden)!
                cell2?.backWhiteView.isHidden = !(cell2?.backWhiteView.isHidden)!
                self.showArrayPhotos[(sender.view?.tag)!] = true
                cell2?.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
                
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
                    
                    cell2?.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                    
                }, completion:{(success) in
                    
                })
            }
            
            
        }
    }
    
}

