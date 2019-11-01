//
//  DiaryViewController.swift
//  Cenes
//
//  Created by Redblink on 13/11/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import GoogleSignIn
import FBSDKLoginKit
import SideMenu


class DiaryViewController: UIViewController,NVActivityIndicatorViewable {
    
    
    var profileImage = UIImage(named: "profile icon")
    
    var imageDownloadsInProgress = [IndexPath : IconDownloader]()
    
    @IBOutlet weak var diaryCollectionView: UICollectionView!
    
    
    var isFrom = ""
    
    var dataObjectArray = [DiaryModel]()
    var selectedDiary : DiaryData!
    var badgeCount: String? = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Diary"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.setUpNavBar()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDiaryInfo" {
            
            let diaryInfo = segue.destination as? DiaryInfoViewController
            diaryInfo?.diaryData = self.selectedDiary
            self.selectedDiary = nil
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        
        
        self.profileImage = appDelegate?.getProfileImage()
        
        self.setUpNavBar()
        if SideMenuManager.default.menuLeftNavigationController?.isNavigationBarHidden == true{
//        if SideMenuManager.menuLeftNavigationController?.isHidden == true{
            if self.isFrom == ""{
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.fetchDiaries()
        }
        }else{
                self.isFrom = ""
        }
        }
    }
    
    func fetchDiaries(){
        self.dataObjectArray.removeAll()
        self.diaryCollectionView.reloadData()
        let webservice = WebService()
      //  startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
                
        webservice.getDiaries() { (returnedDict) in
            self.stopAnimating()
            if returnedDict["Error"] as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                //print(returnedDict)
               self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
            }
        }
       
    }
    
    
    func parseResults(resultArray: NSArray){
        
        
        let dict = NSMutableDictionary()
        
        dict.setValue([DiaryData](), forKey: "Diary")
        let cenesDiary = DiaryModel()
        cenesDiary.sectionName = "Diary"
        cenesDiary.sectionObjects = [DiaryData]()
        self.dataObjectArray.append(cenesDiary)
        
        for i : Int in (0..<resultArray.count) {
            
            
            let outerDict = resultArray[i] as! NSDictionary
            
            
            
            
            
            let title = (outerDict.value(forKey: "title") != nil) ? outerDict.value(forKey: "title") as? String : nil
            
            let location = (outerDict.value(forKey: "location") != nil) ? outerDict.value(forKey: "location") as? String : nil
            
            let diaryDetail = (outerDict.value(forKey: "detail") != nil) ? outerDict.value(forKey: "detail") as? String : nil
            
            let  diaryPicture = (outerDict.value(forKey: "pictures") != nil) ? outerDict.value(forKey: "pictures") as? String : nil
            
            var diaryPicArray :[PhotoModel]!
            
            if diaryPicture != nil && diaryPicture != "" {
                diaryPicArray = [PhotoModel]()
                let arr = diaryPicture?.split(separator: ",")
                for picUrl in arr! {
                    let photosModel = PhotoModel()
                    photosModel.diaryPhotoUrl = String(picUrl)
                    diaryPicArray.append(photosModel)
                }
            }
            
            
            
            let  d_id = (outerDict.value(forKey: "diaryId") != nil) ? outerDict.value(forKey: "diaryId") as? NSNumber : nil
            let diary_id = "\(d_id!)"
            
            
            
            let eventMembers = (outerDict.value(forKey: "members") != nil) ? outerDict.value(forKey: "members") as? NSArray : nil
            
            
            
            let diaryObject : DiaryData = DiaryData()
            
            diaryObject.title = title
            diaryObject.locationName = location
            diaryObject.diaryId = diary_id
            diaryObject.diaryDetail = diaryDetail
            if diaryPicArray != nil {
            diaryObject.diaryPhotoModel = diaryPicArray
            }
            
            let createdById = outerDict.value(forKey: "createdById") as? NSNumber
            if createdById != nil {
                let cId = "\(createdById!)"
                
                diaryObject.createdById = cId
            }
            
            let friendDict = eventMembers as! [NSDictionary]
            
            for userDict in friendDict {
                let cenesUser = CenesUser()
                cenesUser.name = userDict.value(forKey: "name") as? String
                cenesUser.photoUrl = userDict.value(forKey: "picture") as? String
                
                let uid =  userDict.value(forKey: "userId") as? NSNumber
                if uid != nil{
                    cenesUser.userId = "\((uid)!)"
                }
                
                cenesUser.userName = userDict.value(forKey: "username") as? String
                diaryObject.eventUsers.append(cenesUser)
            }
            
            let keyNum = outerDict.value(forKey: "diaryTime") as? NSNumber
            
            var key = ""
            if keyNum == nil {
                 key = "Diary"
            }else{
                 key = "\(keyNum!)"
                let time = Util.getTimeFromTimestamp(timeStamp: key)
                diaryObject.diaryTimeString = time
                diaryObject.diaryTime = keyNum!
                key = Util.getDiaryDateFromTimestamp(timeStamp: key)
            }
            
           
            if dict.value(forKey: key) != nil {
                
                var array = dict.value(forKey: key) as! [DiaryData]!
                array?.append(diaryObject)
                
                dict.setValue(array, forKey: key)
                
                if let cenesDiary = self.dataObjectArray.first(where: { $0.sectionName == key}){
                    print(cenesDiary.sectionName)
                    cenesDiary.sectionObjects = array
                }
            }else{
                var array = [DiaryData]()
                
                array.append(diaryObject)
                dict.setValue(array, forKey: key)
                
                let cenesDiary = DiaryModel()
                cenesDiary.sectionName = key
                cenesDiary.sectionObjects = array
                
                self.dataObjectArray.append(cenesDiary)
                
            }
            
        }
        
        let Default = self.dataObjectArray.first
        if Default?.sectionObjects.count == 0{
            self.dataObjectArray.remove(at: 0)
        }
        
        
        self.reloadDiaries()

    }
    
    
    func reloadDiaries(){
            if self.dataObjectArray.count > 0 {
                self.diaryCollectionView.isHidden = false
            }else{
                self.diaryCollectionView.isHidden = true
            }
            self.diaryCollectionView.reloadData()
    }
    
    
    func setUpNavBar(){
        let profileButton = SSBadgeButton()//UIButton.init(type: .custom) //
        
        self.profileImage = appDelegate?.getProfileImage()
        
        profileButton.imageView?.contentMode = .scaleAspectFill
        
        profileButton.setImage(self.profileImage, for: UIControlState.normal)
        profileButton.frame = CGRect.init(x: 0, y: 0, width: 40 , height: 40)
        profileButton.layer.cornerRadius = profileButton.frame.height/2
        
        profileButton.clipsToBounds = true
        profileButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        profileButton.addTarget(self, action:#selector(profileButtonPressed), for: UIControlEvents.touchUpInside)
        profileButton.backgroundColor = UIColor.white
        profileButton.badge = badgeCount;
        profileButton.badgeEdgeInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 10)
        profileButton.badgeFont = profileButton.badgeFont.withSize(10)
        
        
        let barButton = UIBarButtonItem.init(customView: profileButton)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    func getNotificationCounts () {
        let webservice = WebService();
        webservice.getNotificationsCounter(){ (returnedDict) in
            print(returnedDict)
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
                self.badgeCount =  String(returnedDict["data"] as! Int) as? String
                self.setUpNavBar()
                
                //  self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
                
                //Setting badge counts in prefrences
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(returnedDict["data"] , forKey: "badgeCounts");
                userDefaults.synchronize()
            }
        }
    }
    
    @objc func profileButtonPressed(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
       // self.performSegue(withIdentifier: "openSideMenu", sender: self)
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
        guard self.dataObjectArray.count != 0 else { return }
        
        let visibleIndexPaths = self.diaryCollectionView.indexPathsForVisibleItems
        for indexPath in visibleIndexPaths {
            if dataObjectArray[indexPath.section].sectionObjects[indexPath.row].diaryPhotoModel.count > 0 {
            let diaryPhoto = dataObjectArray[indexPath.section].sectionObjects[indexPath.row].diaryPhotoModel.first
            if diaryPhoto?.diaryPhoto == nil {
                if diaryPhoto?.diaryPhotoUrl != nil && diaryPhoto?.diaryPhotoUrl != ""{
                    self.startIconDownload(diaryPhoto: diaryPhoto!, forIndexPath: indexPath)
                }
            }else{
                
            }
            }
            
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.loadImagesForOnscreenRows()
    }
    
    
    
    
    
}




extension DiaryViewController: IconDownloaderDelegate {
    func iconDownloaderDidFinishDownloadingImage(_ iconDownloader: IconDownloader, error: NSError?) {
        guard let cell = self.diaryCollectionView.cellForItem(at:iconDownloader.indexPath as IndexPath) as? DiaryCell else {
            print("Not got cell")
            //self.friendsView.reloadItems(at: [iconDownloader.indexPath])
            return }
        if let error = error {
            print("error downloading Image")
            //fatalError("Error loading thumbnails: \(error.localizedDescription)")
        } else {
            UIView.transition(with: cell.DiaryImage!,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: { cell.DiaryImage?.image = iconDownloader.photoDiary.diaryPhoto
                                
            },
                              completion: nil)
            
            //  print(iconDownloader.cenesUser.name+" user profile updated")
        }
        self.imageDownloadsInProgress.removeValue(forKey: iconDownloader.indexPath as IndexPath)
    }
}


extension DiaryViewController : UICollectionViewDataSource , UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataObjectArray[section].sectionObjects.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var obj : DiaryData!
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as! DiaryCell
        
        obj = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
    
            
            cell.diaryTitle.text = obj.title
            cell.diaryDetail.text = obj.diaryDetail
        
        print(obj.title)
        
        
        if obj.diaryPhotoModel.count > 0 {
            
            let diaryPhoto = obj.diaryPhotoModel.first
            
            if let icon = diaryPhoto?.diaryPhoto {
                cell.DiaryImage.image = icon
            } else {
                if diaryPhoto?.diaryPhotoUrl != nil && diaryPhoto?.diaryPhotoUrl != ""{
                    self.startIconDownload(diaryPhoto: diaryPhoto!, forIndexPath: indexPath)
                    cell.DiaryImage.image = #imageLiteral(resourceName: "DiaryDefault")
                }else{
                    cell.DiaryImage.image = #imageLiteral(resourceName: "DiaryDefault")
                }
                
            }
            
            
        }else{
            cell.DiaryImage.image = #imageLiteral(resourceName: "DiaryDefault")
            cell.DiaryImage.contentMode = .scaleAspectFill
        }
        
        
        
        
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionTitle = dataObjectArray[indexPath.section].sectionName
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DiaryHeaderView", for: indexPath) as! DiaryHeaderView
        cell.HeaderTitleLabel.text = sectionTitle
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataObjectArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.size.width - 45)/2
        
        return CGSize(width: width, height: 200);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDiary = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
        self.selectedDiary = selectedDiary
        self.performSegue(withIdentifier: "showDiaryInfo", sender: self)
        isFrom = "diaryInfo"
    }
}

