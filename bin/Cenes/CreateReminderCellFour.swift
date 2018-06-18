//
//  CreateReminderCellFour.swift
//  Cenes
//
//  Created by Redblink on 25/09/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import IoniconsSwift

class CreateReminderCellFour: UITableViewCell {
    
    
    @IBOutlet weak var friendsView: UICollectionView!
    var createReminderView : CreateReminderViewController!
    
    
    @IBOutlet weak var upperView: UIView!
    
    
    @IBOutlet weak var lowerView: UIView!
    
    @IBOutlet weak var peopleIcon: UIImageView!
    
    var showArray = [Bool]()
    
    func setShowArray(){
        for _ in self.createReminderView.FriendArray {
            self.showArray.append(false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.friendsView.register(UINib(nibName: "FriendsViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "friendCell")
        self.peopleIcon.image = Ionicons.androidPeople.image(30, color: UIColor.darkGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadFriends(){
        self.friendsView.reloadData()
    }
    
}

extension CreateReminderCellFour : UICollectionViewDataSource ,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createReminderView.FriendArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! FriendsViewCell
        
        let friend = createReminderView.FriendArray[indexPath.row]
        
        cell.nameLabel.text =  friend.name
        cell.addGestureRecognizer(longPressGesture())
        
        cell.tag = indexPath.row
        cell.crossButotn.tag = indexPath.row
        
        cell.cellFour = self
        cell.indexPath = indexPath
        
        if self.showArray[indexPath.row] == true {
            cell.crossButotn.isHidden = false
            cell.backWhiteView.isHidden = false
        }else{
            cell.crossButotn.isHidden = true
            cell.backWhiteView.isHidden = true
        }
        
        let photoUrl1 = friend.photoUrl
        
        if photoUrl1 != nil {
            WebService().profilePicFromFacebook(url: photoUrl1!, completion: { image in
                cell.profileImage.image = image
            })
        }else{
            cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
            
        }
        return cell
        
    }
    
    func longPressGesture() -> UILongPressGestureRecognizer {
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(CreateReminderCellFour.longPress))
        lpg.minimumPressDuration = 0.5
        return lpg
    }
    
    func longPress(_ sender: UILongPressGestureRecognizer) {
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
        self.createReminderView.FriendArray.remove(at: tag)
        self.friendsView.deleteItems(at: [cell.indexPath])
        self.showArray.remove(at: tag)
        self.friendsView.reloadItems(at: self.friendsView.indexPathsForVisibleItems)
        self.createReminderView.createReminderTableView.reloadData()
    }
    
    
}
