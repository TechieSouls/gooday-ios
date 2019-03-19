//
//  CreateDiaryViewController.swift
//  
//
//  Created by Redblink on 13/11/17.
//

import UIKit
import MobileCoreServices
import NVActivityIndicatorView

enum CellHeightDiary : CGFloat {
    case First          = 470
    case Second         = 570 // only Photos added
    case Third          = 670 // photos and friends Added
    case Fourth         = 570.1 // only friends added
}



class CreateDiaryViewController: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate,NVActivityIndicatorViewable {

    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    let picController = UIImagePickerController()
    
    var diaryData = DiaryData()
    var isEditMode = false
    @IBOutlet weak var createDiaryTableView: UITableView!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    var selectedLocation: LocationModel!
    var selectedDate: Date!
    var selectedDateStr: String!
    var uploadUrlString = [String]()
    var cellHeightDiary : CellHeightDiary!
    
    var DiaryCell: DiaryCellOne!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellHeightDiary = CellHeightDiary.First
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)
        createDiaryTableView.register(UINib(nibName: "DiaryCellOne", bundle: Bundle.main), forCellReuseIdentifier: "DiaryCellOne")
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(CreateDiaryViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateDiaryViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        if self.isEditMode == true {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
            if self.diaryData.diaryTime != nil {
            selectedDate = Date(milliseconds: self.diaryData.diaryTime as! Int)
                selectedDateStr = dateFormatter.string(from: selectedDate)
            }
            
            
            self.createDiaryTableView.reloadData()

        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if DiaryCell.titleTF.text == "" {
            self.showAlert(title: "Diary Title", message: "Please fill the Diary title.")
            return
        }
        
        if DiaryCell.timeTF.text == "" {
            self.showAlert(title: "Diary Time", message: "Please enter Diary Time.")
            return
        }
        
        if DiaryCell.entryTF.text == "" {
            self.showAlert(title: "Diary Entry", message: "Please enter Diary Entry.")
            return
        }
        
        if DiaryCell.timeTF.text == "" {
            self.showAlert(title: "Diary Time", message: "Please enter Diary Time.")
            return
        }
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
        if self.diaryData.diaryPhotoModel.count > 0 {
            self.uploadPicture(count: 0)
        }else{
            self.saveDiary()
        }
        
        
    }
    
    func deleteDiary(){
        // Delete Diary
        startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
        
        WebService().deleteDiary(diaryId:self.diaryData.diaryId) { (returnedDict) in
            if returnedDict["Error"] as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
            }else{
                self.stopAnimating()
                let actionSheetController = UIAlertController(title: "Diary Deleted", message: nil, preferredStyle: .alert)
                
                
                
                let OKButton = UIAlertAction(title: "Ok", style: .default) { action -> Void in
                    print("choose")
                    self.dismiss(animated: true, completion: nil)
                    
                    if let cenesTabBarViewControllers = appDelegate?.cenesTabBar?.viewControllers {
                        let diary = (cenesTabBarViewControllers[3] as? UINavigationController)?.viewControllers.first as? DiaryViewController
                        diary?.isFrom = ""
                        diary?.navigationController?.popToRootViewController(animated: true)
                        
                        
                    }
                    
                    
                }
                actionSheetController.addAction(OKButton)
                
                self.present(actionSheetController, animated: true, completion: nil)
               
            }
        }
    }
    
    
    
    func uploadPicture(count:Int){
        var count = count
        
        let model = self.diaryData.diaryPhotoModel[count]
        
        if model.diaryPhotoUrl != nil {
            if count < self.diaryData.diaryPhotoModel.count - 1 {
                count += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.uploadPicture(count:count)
                }
            }else{
                print("upload next steps")
                // upload next Steps
                self.saveDiary()
            }
        }else{
        
        let webservice = WebService()
        
        
        let uploadImage = self.diaryData.diaryPhotoModel[count].diaryPhoto.compressImage(newSizeWidth: 512, newSizeHeight: 512, compressionQuality: 1.0)
        
        webservice.uploadDiaryImage(image: uploadImage, complete: { (returnedDict) in
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
                let eventPictureUrl = (returnedDict["data"] as! NSDictionary)["data"] as? String
                model.diaryPhotoUrl = eventPictureUrl!
                if count < self.diaryData.diaryPhotoModel.count - 1 {
                    count += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.uploadPicture(count:count)
                    }
                }else{
                    print("upload next steps")
                    // upload next Steps
                    self.saveDiary()
                }
            }
        })
        }
    }
    
    
    func saveDiary(){
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        var eventMembers = [NSMutableDictionary]()
        for result in self.self.diaryData.eventUsers {
            let dict = NSMutableDictionary()
            
            dict["name"] = result.name
            dict["userId"] = result.userId
            let id = "\((setting.value(forKey: "userId") as? NSNumber)!)"
            if result.userId == id {
                continue
            }
            if result.photoUrl != nil {
                dict["picture"] = result.photoUrl
            }
            eventMembers.append(dict)
        }
        
        var params : [String:Any]
        
        if self.diaryData.diaryPhotoModel.count > 0 {
            for photoModel in self.diaryData.diaryPhotoModel {
                    uploadUrlString.append(photoModel.diaryPhotoUrl)
            }
        }
        
        let pictureStr = uploadUrlString.joined(separator: ",")
        
        if eventMembers.count > 0 {
            params = ["title":DiaryCell.titleTF.text!,"detail":DiaryCell.entryTF.text!,"location":self.selectedLocation != nil ? self.selectedLocation.locationName:"","latitude":self.selectedLocation != nil ? self.selectedLocation.latitude:"","longitude":self.selectedLocation != nil ? self.selectedLocation.longitude:"","createdById":uid,"diaryTime":"\(self.selectedDate.millisecondsSince1970)","pictures":pictureStr,"members":eventMembers]
            
        }else{
            params = ["title":DiaryCell.titleTF.text!,"detail":DiaryCell.entryTF.text!,"location":self.selectedLocation != nil ? self.selectedLocation.locationName:"","latitude":self.selectedLocation != nil ? self.selectedLocation.latitude:"","longitude":self.selectedLocation != nil ? self.selectedLocation.longitude:"","createdById":uid,"diaryTime":"\(self.selectedDate.millisecondsSince1970)","pictures":pictureStr,"members":eventMembers]
        }
        
        
        if  self.isEditMode == true {
            params["diaryId"] = self.diaryData.diaryId
        }
        
        WebService().createDiary(uploadDict: params, complete: { (returnedDict) in
            self.stopAnimating()
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                self.uploadUrlString.removeAll()
            }else{
                self.navigationItem.rightBarButtonItem = nil
                self.dismiss(animated: true, completion: nil)
                print("Got result from webservice\(returnedDict)")
                print("Diary created")
                
            }
        })
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func reloadFriends() {
        if self.diaryData.eventUsers.count > 0 {
            DiaryCell.friendsCollectionView.isHidden = false
        }
        else {
            DiaryCell.friendsCollectionView.isHidden = true
        }
    }
    func reloadPhotos() {
        if self.diaryData.diaryPhotoModel.count > 0 {
            DiaryCell.photosCollectionView.isHidden = false
        }
        else {
            DiaryCell.photosCollectionView.isHidden = true
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableViewBottomConstraint.constant = keyboardSize.height
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.tableViewBottomConstraint.constant  = 0
    }
    
    @objc func updateDate(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        
        selectedDate = datePicker.date
        self.diaryData.diaryTime = selectedDate.millisecondsSince1970 as NSNumber
        self.diaryData.diaryTimeString = dateFormatter.string(from: datePicker.date)
        selectedDateStr = dateFormatter.string(from: datePicker.date)
        
        self.view.resignFirstResponder()
    }
    
    func getPickerForDate() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width,height: 216)
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(updateDate(datePicker:)), for: .valueChanged)
        return datePicker
    }
    
    private func configureTextField(withImage: UIImage, textfield: UITextField) {
        let imageView = UIImageView.init(image: withImage)
        imageView.frame = CGRect(x: 5, y: 0, width: 40, height: 40)
        imageView.contentMode = .center
        
        textfield.leftView = imageView
        textfield.leftViewMode = .always
        
        textfield.backgroundColor = UIColor.white
    }
    
    func createInputAccessoryView() -> UIToolbar{
        let toolbar = UIToolbar.init(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: 44))
        
        let cancelButton = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(hideKeyBoard))
        let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(confirmSelectedDate))
        
        toolbar.setItems([cancelButton, space, doneButton], animated: true)
        
        return toolbar
    }
    
    @objc func hideKeyBoard() {
        DiaryCell.hideKeyBoard()
       // dateTextField.resignFirstResponder()
        self.view.resignFirstResponder()
    }
    
    @objc func confirmSelectedDate() {
        self.view.resignFirstResponder()
        DiaryCell.hideKeyBoard()
        if self.selectedDateStr != nil {
        DiaryCell.timeTF.text = selectedDateStr
        self.diaryData.diaryTime = selectedDate.millisecondsSince1970 as NSNumber
        self.diaryData.diaryTimeString = selectedDateStr
        
        //dateTextField.text = selectedDateStr
        //dateTextField.resignFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showLocation" {
            let locationNavigationVC = segue.destination as? LocationTableViewController
            //locationNavigationVC?.delegate = self
        }
    }
    
    func setUPHeight(){
        
        self.createDiaryTableView.beginUpdates()
        if self.diaryData.eventUsers.count == 0 {
            if self.diaryData.diaryPhotoModel.count == 0 {
                self.cellHeightDiary = CellHeightDiary.First
            }
            else{
                self.cellHeightDiary = CellHeightDiary.Second
            }
        }else{
            if self.diaryData.diaryPhotoModel.count == 0 {
                self.cellHeightDiary = CellHeightDiary.Fourth
            }
            else{
                self.cellHeightDiary = CellHeightDiary.Third
            }
        }
        self.setUpUi(height: self.cellHeightDiary)
        self.createDiaryTableView.endUpdates()
        
    }
    
    
    func setUpUi(height:CellHeightDiary){
        switch height {
        case .First:
        print("")
        DiaryCell.photosCollectionView.isHidden = true
        DiaryCell.friendsCollectionView.isHidden = true
        DiaryCell.photosHeightConstraint.constant = 55
        DiaryCell.friendsHeightConstraint.constant = 55
        case .Second:
        DiaryCell.photosCollectionView.isHidden = false
        DiaryCell.friendsCollectionView.isHidden = true
        DiaryCell.photosHeightConstraint.constant = 155
        DiaryCell.friendsHeightConstraint.constant = 55
        print("")
        case .Third :
        print("")
        DiaryCell.photosCollectionView.isHidden = false
        DiaryCell.friendsCollectionView.isHidden = false
        DiaryCell.photosHeightConstraint.constant = 155
        DiaryCell.friendsHeightConstraint.constant = 155
        case .Fourth:
        print("")
        DiaryCell.photosCollectionView.isHidden = true
        DiaryCell.friendsCollectionView.isHidden = false
        DiaryCell.photosHeightConstraint.constant = 55
        DiaryCell.friendsHeightConstraint.constant = 155
        
        }
        
    }
    
    func imagePickerButtonPressed() {
        
        
            let actionSheetController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)
            
            let cancelActionButton = UIAlertAction(title: "Take Picture", style: .default) { action -> Void in
                print("take")
                self.takePicture()
            }
            actionSheetController.addAction(cancelActionButton)
            
            let saveActionButton = UIAlertAction(title: "Choose From Gallery", style: .default) { action -> Void in
                print("choose")
                self.selectPicture()
            }
            actionSheetController.addAction(saveActionButton)
            
            let deleteActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetController.addAction(deleteActionButton)
            self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picController.sourceType = UIImagePickerControllerSourceType.camera
            picController.allowsEditing = true
            picController.delegate = self
            picController.mediaTypes = [kUTTypeImage as String]
            present(picController, animated: true, completion: nil)
        }
    }
    
    func selectPicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            picController.delegate = self
            picController.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            picController.allowsEditing = true
            picController.mediaTypes = [kUTTypeImage as String]
            self.present(picController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let photoModel = PhotoModel()
            photoModel.diaryPhoto = image
            self.diaryData.diaryPhotoModel.append(photoModel)
            DiaryCell.showArrayPhotos.append(false)
            DiaryCell.photosCollectionView.reloadData()
            self.setUPHeight()
        }
        picker.dismiss(animated: true, completion: nil);
    }
    
    func addFriendsButton() {
        
       // self.navigationController?.pushViewController(inviteFriends!, animated: true)
    }
    
}


extension CreateDiaryViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == DiaryCell.locationTF {
            self.performSegue(withIdentifier: "showLocation", sender: nil)
            return false
        }
        else if textField == DiaryCell.addFriendsTF {
            /*let inviteFriends = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inviteFriends") as? InviteFriendViewController
            inviteFriends?.delegate = self*/
            //self.navigationController?.pushViewController(inviteFriends!, animated: true)
            return false
        }else if textField == DiaryCell.photosTF {
            if self.diaryData.diaryPhotoModel.count <= 4{
            self.imagePickerButtonPressed()
            }
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let textAfterUpdate = text.replacingCharacters(in: range, with: string)
            print(textAfterUpdate)
            if textField == DiaryCell.titleTF {
                self.diaryData.title = textAfterUpdate
            }
            if textField == DiaryCell.entryTF {
                self.diaryData.diaryDetail = textAfterUpdate
            }
        }
        return true
    }
}


/*extension CreateDiaryViewController: SelectedLocationDelegate {
    func selectedLocation(location: LocationModel,url:String!) {
        self.selectedLocation = location
        self.diaryData.locationName = location.locationName
        DiaryCell.locationTF.text = location.locationName
    }
}*/

extension CreateDiaryViewController {
    func selectUser(user: CenesUser) {
        self.diaryData.eventUsers.append(user)
        DiaryCell.showArrayFriends.append(false)
        self.cellHeightDiary = CellHeightDiary.Fourth
        DiaryCell.friendsCollectionView.reloadData()
        self.setUPHeight()
    }
}




extension CreateDiaryViewController :UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isEditMode == true {
            return cellHeightDiary!.rawValue + 95
        }else{
        return cellHeightDiary!.rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let identifier = "DiaryCellOne"
            DiaryCell = self.createDiaryTableView.dequeueReusableCell(withIdentifier: identifier) as? DiaryCellOne
        
        DiaryCell.createDiary = self
        if self.isEditMode == true {
            DiaryCell.setEdit()
            DiaryCell.deleteView.isHidden = false
            
        }else{
            DiaryCell.deleteView.isHidden = true
        }
        self.setUPHeight()
        configureTextField(withImage: #imageLiteral(resourceName: "pencil"), textfield: DiaryCell.titleTF)
        
        DiaryCell.timeTF.inputView = getPickerForDate()
        DiaryCell.timeTF.inputAccessoryView = createInputAccessoryView()
        configureTextField(withImage: #imageLiteral(resourceName: "clockIcon"), textfield: DiaryCell.timeTF)
        configureTextField(withImage: #imageLiteral(resourceName: "locationIcon"), textfield: DiaryCell.locationTF)
        configureTextField(withImage: #imageLiteral(resourceName: "profile"), textfield: DiaryCell.addFriendsTF)
        configureTextField(withImage: #imageLiteral(resourceName: "EventDetails"), textfield: DiaryCell.entryTF)
         configureTextField(withImage: #imageLiteral(resourceName: "addPhotos"), textfield: DiaryCell.photosTF)
        
        DiaryCell.timeTF.delegate = self
        DiaryCell.titleTF.delegate = self
        DiaryCell.entryTF.delegate = self
        DiaryCell.locationTF.delegate = self
        DiaryCell.photosTF.delegate = self
        DiaryCell.addFriendsTF.delegate = self
        DiaryCell.createDiary = self
        
        DiaryCell.titleTF.text = self.diaryData.title
        DiaryCell.entryTF?.text  = self.diaryData.diaryDetail
        DiaryCell.locationTF.text = self.diaryData.locationName
        DiaryCell.timeTF.text = self.selectedDateStr
        DiaryCell.photosCollectionView.reloadData()
        DiaryCell.friendsCollectionView.reloadData()
        
            return DiaryCell
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    
    func convertToDictionary(text: String) -> NSArray? {
        if let data = text.data(using: .utf8) {
            do {
                
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSArray
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getTimeFromTimestamp(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.string(from: dateFromServer as Date)
        
        return date
    }
    
    func getDateFromTimestamp(timeStamp:String) -> String{
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
    
    
    
}
