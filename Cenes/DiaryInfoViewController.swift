//
//  DiaryInfoViewController.swift
//  Cenes
//
//  Created by Redblink on 15/11/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class DiaryInfoViewController: UIViewController {
    
    @IBOutlet weak var diaryTitle: UILabel!
    
    @IBOutlet weak var diaryTime: UILabel!
    
    @IBOutlet weak var userNames: UILabel!
    
    @IBOutlet weak var diaryTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var diaryLocation: UILabel!
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var diaryDetail: UITextView!
    
    @IBOutlet weak var userNamesHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var diaryDetailHeightConstraint: NSLayoutConstraint!
    
    var imageDownloadsInProgress = [IndexPath : IconDownloader]()
    
    
    var diaryData : DiaryData!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("func viewwill apear claled")
        
        self.diaryTitle.text = self.diaryData.title
        self.diaryDetail.text = self.diaryData.diaryDetail
        self.diaryLocation.text = self.diaryData.locationName
        if self.diaryData.diaryTime != nil {
            self.diaryTime.text = Util.getDiaryInfoDateString(timeStamp: "\(self.diaryData.diaryTime!)")
        }else{
            self.diaryTime.text = "No Time selected"
        }
        
        if self.diaryData.eventUsers.count > 0 {
            var nameArray = [String]()
            for cenesUser in self.diaryData.eventUsers{
                nameArray.append(cenesUser.name)
            }
            
            let nameString = nameArray.joined(separator: ",")
            self.userNames.text = nameString
            
            let size = self.userNames.sizeThatFits(self.userNames.bounds.size) as CGSize
            if size.height < 43 {
                self.userNamesHeightConstraint.constant = 43
            }else if size.height > 43 {
                self.userNamesHeightConstraint.constant = 100
            }else{
                self.userNamesHeightConstraint.constant = size.height
            }
            
            
        }else{
            self.userNames.text = "No Users Added"
        }
        
        let size = self.diaryTitle.sizeThatFits(self.diaryTitle.bounds.size) as CGSize
        if size.height < 48 {
            self.diaryTitleConstraint.constant = 48
        }else if size.height > 80 {
            self.diaryTitleConstraint.constant = 80
        }else{
            self.diaryTitleConstraint.constant = size.height
        }
        
        self.diaryDetail.text = self.diaryData.diaryDetail
        
        let sizeDetail = self.diaryDetail.sizeThatFits(self.diaryDetail.bounds.size) as CGSize
        if sizeDetail.height < 20 {
            self.diaryDetailHeightConstraint.constant = 20
        }else if sizeDetail.height > 146 {
            self.diaryDetailHeightConstraint.constant = 146
        }else {
            self.diaryDetailHeightConstraint.constant = sizeDetail.height
        }
        
        
        self.photosCollectionView.register(UINib(nibName: "PhotosCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PhotosCell")
        
        if self.diaryData.diaryPhotoModel.count > 0 {
            self.photosCollectionView.reloadData()
        }
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        if self.diaryData.createdById == uid {
                self.setUpNavBar()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpNavBar() {
       
            let backButton = UIButton.init(type: .custom)
            backButton.setTitle("Cancel", for: UIControl.State.normal)
            backButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            backButton.layer.cornerRadius = backButton.frame.height/2
            backButton.clipsToBounds = true
            backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
            
            let barButton = UIBarButtonItem.init(customView: backButton)
            self.navigationItem.leftBarButtonItem = barButton
            
            let nextButton = UIButton.init(type: .custom)
            
            nextButton.setTitle("Edit", for: .normal)
            nextButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
            nextButton.clipsToBounds = true
            nextButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
            let rightButton = UIBarButtonItem.init(customView: nextButton)
            
            self.navigationItem.rightBarButtonItem = rightButton
            
        }
    
    @objc func backPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editPressed(){
        self.performSegue(withIdentifier: "editDiary", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editDiary" {
            let navigation = segue.destination as! UINavigationController
            let editDiary = navigation.topViewController as! CreateDiaryViewController
            editDiary.diaryData = self.diaryData
            editDiary.isEditMode = true
        }
    }

    func startIconDownload(diaryPhoto: PhotoModel, forIndexPath indexPath: IndexPath) {
        guard self.imageDownloadsInProgress[indexPath] == nil else { return }
        
        let iconDownloader = IconDownloader(cenesUser: nil, cenesEventData: nil, notificationData: nil, indexPath: indexPath, photoDiary: diaryPhoto)
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
        guard self.diaryData.diaryPhotoModel.count != 0 else { return }
        
        let visibleIndexPaths = self.photosCollectionView.indexPathsForVisibleItems
        for indexPath in visibleIndexPaths {
                let diaryPhoto = self.diaryData.diaryPhotoModel[indexPath.row]
                if diaryPhoto.diaryPhoto == nil {
                    if diaryPhoto.diaryPhotoUrl != nil && diaryPhoto.diaryPhotoUrl != ""{
                        self.startIconDownload(diaryPhoto: diaryPhoto, forIndexPath: indexPath)
                    }
                }else{
                    
                }
            
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.loadImagesForOnscreenRows()
    }
    
    
    
}

extension DiaryInfoViewController: IconDownloaderDelegate {
    func iconDownloaderDidFinishDownloadingImage(_ iconDownloader: IconDownloader, error: NSError?) {
        guard let cell = self.photosCollectionView.cellForItem(at:iconDownloader.indexPath as IndexPath) as? PhotosCell else {
            print("Not got cell")
            //self.friendsView.reloadItems(at: [iconDownloader.indexPath])
            return }
        if let error = error {
            print("error downloading Image")
            //fatalError("Error loading thumbnails: \(error.localizedDescription)")
        } else {
            UIView.transition(with: cell.AddedImage!,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: { cell.AddedImage?.image = iconDownloader.photoDiary.diaryPhoto
            },
                              completion: nil)
            
            //  print(iconDownloader.cenesUser.name+" user profile updated")
        }
        
        if let  cont = (self.presentedViewController as? UINavigationController)?.viewControllers.first as? CreateDiaryViewController {
            cont.DiaryCell?.photosCollectionView.reloadData()
        }
        self.imageDownloadsInProgress.removeValue(forKey: iconDownloader.indexPath as IndexPath)
    }
}


extension DiaryInfoViewController : UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryData.diaryPhotoModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
            let photoDiary = self.diaryData.diaryPhotoModel[indexPath.row]
        
            let  cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
        
        
            if let icon = photoDiary.diaryPhoto {
                cell.AddedImage.image = icon
            } else {
                if photoDiary.diaryPhotoUrl != nil && photoDiary.diaryPhotoUrl != ""{
                    self.startIconDownload(diaryPhoto: photoDiary, forIndexPath: indexPath)
                    cell.AddedImage.image = #imageLiteral(resourceName: "DiaryDefault")
                }else{
                    cell.AddedImage.image = #imageLiteral(resourceName: "DiaryDefault")
                }
                
            }
        
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.size.width - 40)/3
        
        return CGSize(width: width, height: width);
    }
    
}


