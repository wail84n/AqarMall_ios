//
//  SubmitAdvFormViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/4/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import OpalImagePicker
import ALCameraViewController
import Photos

class SubmitAdvFormViewController: ViewController, ChooseAddressDelegate, CropViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var imagesCollection: UICollectionView!
    
    @IBOutlet weak var titleCounterLabel: UILabel!
    @IBOutlet weak var advTitleTextField: UITextField!
    @IBOutlet weak var adDetailsTextView: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var roomsNoTextField: UITextField!
    @IBOutlet weak var bathRoomNoTextField: UITextField!
    @IBOutlet weak var floorsNoTextField: UITextField!
    @IBOutlet weak var finishingTextField: UITextField!
    @IBOutlet weak var interfaceField: UITextField!
    @IBOutlet weak var buildingAgeTextfield: UITextField!
    @IBOutlet weak var buildingSizeTextField: UITextField!
    @IBOutlet weak var landSizeTextField: UITextField!
    @IBOutlet weak var licenseTypeTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var optionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var directAdvButton: UIButton!
    @IBOutlet weak var notDirectAdvButton: UIButton!
    
    var selectedArea : AreasData? = nil
    
    var category : CategoriesData? = nil
    var isRent = false
    
    var postAd = postAdv()
     
    let imagePicker = UIImagePickerController()
    var selectedImagePickerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        if isRent == true {
            title = "اضف اعلان - \(category?.name ?? "") للإيجار"
        }else{
            title = "اضف اعلان - \(category?.name ?? "") للبيع"
        }
        
        self.setBack()
        
        adDetailsTextView.text = "وصف الإعلان"
        adDetailsTextView.textColor = UIColor.lightGray
        advTitleTextField.delegate = self

        setCatProperties()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(getCatPropertiesCount() )
        print(CGFloat(570 + (getCatPropertiesCount() * 50)))
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(1100 + (getCatPropertiesCount() * 50)))
    }
    
    @IBAction func directAdvChanged(_ sender: UIButton) {
        notDirectAdvButton.setImage(#imageLiteral(resourceName: "icon_radio_off_small"), for: .normal)
        directAdvButton.setImage(#imageLiteral(resourceName: "icon_radio_on_small"), for: .normal)
        postAd.CallMe = true
    }
    
    @IBAction func notDirectAdvChanged(_ sender: UIButton) {
        directAdvButton.setImage(#imageLiteral(resourceName: "icon_radio_off_small"), for: .normal)
        notDirectAdvButton.setImage(#imageLiteral(resourceName: "icon_radio_on_small"), for: .normal)
        postAd.CallMe = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 24
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        titleCounterLabel.text = "25/\(newString.length)"
        print("newString.length \(newString.length)")
        return newString.length <= maxLength
    }
    
    //MARK:- TextView Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == adDetailsTextView && textView.text == "وصف الإعلان" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == adDetailsTextView && textView.text == "" {
            textView.text = "وصف الإعلان"
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
    
    func  getCatPropertiesCount()-> Int {
        var counter = 1 // +++ strat from 1 because the price is fixed textFeild
        if let _category = category{
            if _category.ageOfBuilding == true{
                counter += 1
            }
            if _category.buildingSize == true{
                counter += 1
            }
            if _category.finishing == true{
                counter += 1
            }
            if _category.interfaceType == true{
                counter += 1
            }
            if _category.landSize == true{
                counter += 1
            }
            if _category.licenseType == true{
                counter += 1
            }
            if _category.numberOfBathrooms == true{
                counter += 1
            }
            if _category.numberOfFloors == true{
                counter += 1
            }
            if _category.numberOfRooms == true{
                counter += 1
            }
            if _category.size == true{
                counter += 1
            }
        }
        return counter
    }
    
    func setCatProperties(){
        if let _category = category{

            let counter = getCatPropertiesCount()
            print(counter * 50)
            optionsHeightConstraint.constant = CGFloat(counter * 50)
            viewHeightConstraint.constant = CGFloat(570 + (counter * 50))
            
            buildingAgeTextfield.isHidden = !_category.ageOfBuilding
            buildingSizeTextField.isHidden = !_category.buildingSize
            finishingTextField.isHidden = !_category.finishing
            interfaceField.isHidden = !_category.interfaceType
            landSizeTextField.isHidden = !_category.landSize
            licenseTypeTextField.isHidden = !_category.licenseType
            bathRoomNoTextField.isHidden = !_category.numberOfBathrooms
            floorsNoTextField.isHidden = !_category.numberOfFloors
            roomsNoTextField.isHidden = !_category.numberOfRooms
            sizeTextField.isHidden = !_category.size
        }
   }
    
    func clearFields() {
        adDetailsTextView.text = "وصف الإعلان"
    }
    
    @IBAction func getAddressAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state{
        case .began:
            //   forSaleView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            UIView.animate(withDuration: 0.1, animations: {
                self.addressView.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
                self.addressView.alpha = 0.6
            })
        case .ended,.cancelled:
            addressView.backgroundColor = UIColor.white
            UIView.animate(withDuration: 0.1, animations: {
                self.addressView.alpha = 1
                self.addressView.transform = CGAffineTransform.identity
            }, completion: { (completed) in
                let vc = UIStoryboard(name: "SubmitAdv", bundle: nil).instantiateViewController(withIdentifier: "ChooseAddressViewController") as! ChooseAddressViewController
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            })
        default:
            break
        }
    }
    
    func setAddress(with area: AreasData, fullAddress: String) {
        selectedArea = area
        addressLabel.text = fullAddress
    }
    
    @IBAction func uploadImageBtn(_ sender: Any) {
        if self.postAd.images.count >= 9{
            let alertController = UIAlertController(title: "", message: "لقد قمت برفع الحد الأقصى من الصور", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "موافق", style: .cancel) { action in
            }
            alertController.addAction(cancelAction)
            
            //            let destroyAction = UIAlertAction(title: "سجل الان", style: .default) { action in
            //
            //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserVC")
            //                self.navigationController?.pushViewController(vc!, animated: true)
            //            }
            //
            //            alertController.addAction(destroyAction)
            
            self.present(alertController, animated: true) {
                // ...
                print("wail al mohammad")
            }
            
        }else
        {
            self.showImagePicker()
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func showImagePicker() {
        
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetController: UIAlertController = UIAlertController(title: "اختر المصدر", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "الغاء", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelActionButton)
        
        let libraryActionButton: UIAlertAction = UIAlertAction(title: "البوم الصور", style: .default)
        { action -> Void in
            
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                //Show error to user?
                return
            }
            
            //Example Instantiating OpalImagePickerController with Closures
            let imagePicker = OpalImagePickerController()
            
            print(self.postAd.images.count)
            print(9 - self.postAd.images.count)
            imagePicker.maximumSelectionsAllowed = 9 - self.postAd.images.count
            imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
            //Present Image Picker
            self.presentOpalImagePickerController(imagePicker, animated: true, select: { (images) in
                //Save Images, update UI
                
                print(images.count)
                
                for image in images {
                    self.showSelectedImageNew(editedImage: self.getAssetThumbnail(asset: image))
                }
                
                //Dismiss Controller
                imagePicker.dismiss(animated: true, completion: nil)
            }, cancel: {
                //Cancel action?
                
            })
            
            
            //            //            self.imagePicker.allowsEditing = true
            //            //            self.imagePicker.sourceType = .photoLibrary
            //            //            self.present(self.imagePicker, animated: true, completion: nil)
            //            let libraryViewController = CameraViewController.imagePickerViewController(croppingEnabled: false) { image, asset in
            //                if image != nil {
            //                    self.showSelectedImageNew(editedImage: image!)
            //                }
            //                self.dismiss(animated: true, completion: nil)
            //            }
            //            self.present(libraryViewController, animated: true, completion: nil)
        }
        actionSheetController.addAction(libraryActionButton)
        
        let cameraActionButton: UIAlertAction = UIAlertAction(title: "الكاميرا", style: .default)
        { action -> Void in
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                //                self.imagePicker.allowsEditing = true
                //                self.imagePicker.sourceType = .camera
                //                self.present(self.imagePicker, animated: true, completion: nil)
                let cameraViewController = CameraViewController(croppingParameters: CroppingParameters(), allowsLibraryAccess: true) { [weak self] image, asset in
                    if let _image = image {
                        self?.showSelectedImageNew(editedImage: _image)
                    }
                    self?.dismiss(animated: true, completion: nil)
                }
                self.present(cameraViewController, animated: true, completion: nil)
            }else {
                print("Camera not available")
            }
        }
        actionSheetController.addAction(cameraActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func showSelectedImageNew(editedImage: UIImage) {
        print("New Image added")
        let imageData = (editedImage).jpeg(.lowest)
        
        if let _imageData = imageData{
            self.postAd.images.append(postImages(image: _imageData)!)
            imagesCollection.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postAd.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: MyImageCell?
        cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "MyImageCell", for: indexPath) as! MyImageCell)
        if indexPath.row != 0
        {
            cell?.mainImageLbl.isHidden = true
        }
        cell?.myImageView.layer.cornerRadius = 5
        cell?.myImageView.layer.masksToBounds = true
        
        cell?.myImageView.image = UIImage(data: postAd.images[indexPath.row].image!)
        return cell!
    }
    
    var imageIndex = 0
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "الغاء", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelActionButton)
        
        let libraryActionButton: UIAlertAction = UIAlertAction(title: "اجعلها الصورة الرئيسية", style: .default)
        { action -> Void in
            self.imagesCollection.reloadData()
        }
        actionSheetController.addAction(libraryActionButton)
        
        let cameraActionButton: UIAlertAction = UIAlertAction(title: "حذف الصورة", style: .default)
        { action -> Void in
            
            self.postAd.images.remove(at: indexPath.row)
            self.imagesCollection.reloadData()
        }
        actionSheetController.addAction(cameraActionButton)
        
        let EditActionButton: UIAlertAction = UIAlertAction(title: "معالجة الصوره", style: .default)
        { action -> Void in
            self.imageIndex = indexPath.row
            let controller = CropViewController()
            controller.delegate = self
            controller.image = UIImage(data: self.postAd.images[indexPath.row].image!)
            let navController = UINavigationController(rootViewController: controller)
            self.present(navController, animated: true, completion: nil)
        }
        actionSheetController.addAction(EditActionButton)

        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    //    func flipImageLeftRight(_ image: UIImage) -> UIImage? {
    //
    //        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    //        let context = UIGraphicsGetCurrentContext()!
    //        context.translateBy(x: image.size.width, y: image.size.height)
    //        context.scaleBy(x: -image.scale, y: -image.scale)
    //
    //        context.draw(image.cgImage!, in: CGRect(origin:CGPoint.zero, size: image.size))
    //
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //
    //        UIGraphicsEndImageContext()
    //
    //        return newImage
    //    }
    
    
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage) {
        //        controller.dismissViewControllerAnimated(true, completion: nil)
        //        imageView.image = image
        //        updateEditButtonEnabled()
    }
    
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        controller.dismiss(animated: true, completion: nil)
        
        self.postAd.images[self.imageIndex].image = image.jpeg(.lowest)
        imagesCollection.reloadData()
    }
    
    func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func updateImageAtIndex(editedImage: UIImage , index :IndexPath) {
        print("New Image added")
        self.postAd.images.remove(at: index.row)
        if let imageData = editedImage.jpeg(.lowest){
            print(self.postAd.images.count)
            self.postAd.images.insert(postImages(image: imageData)!, at: index.row)
            print(self.postAd.images.count)
        }
        
        imagesCollection.reloadData()
    }
    
    
    @IBAction func submitAdv(_ sender: Any) {
        SubmitAdv()
    }
    
    func SubmitAdv() {
        
        if let _selectedArea = selectedArea {
            postAd.areaID = Int16(_selectedArea.entryID)
            postAd.provinceID = Int16(_selectedArea.provinceID)
        }else{
            self.showAlert(withTitle: .Missing, text: "الرجاء تحديد العنوان")
            return
        }
       
        if isRent == true{
            postAd.sectionID = 1
        }else{
            postAd.sectionID = 2
        }
        
        if let _catId = category?.id {
            postAd.catID = _catId
        }else{
            self.showAlert(withTitle: .Missing, text: "الرجاء اختر الفئة المطلوبة")
            return
        }
       
        if let _userId = DB_UserInfo.getUserId() {
            postAd.userid = _userId
        }else{
            self.showAlert(withTitle: .Missing, text: "لا يوجد حساب معتمد الرجاء التسجيل")
            return
        }
        
        postAd.countryType = 1
        if let _title = advTitleTextField.text {
            postAd.title = _title
        }
        
        if let _description = adDetailsTextView.text {
            postAd.Description =  _description
        }
        
        if let _numberOfRooms = roomsNoTextField.text {
            postAd.NumberOfRooms =  _numberOfRooms
        }
        
        if let _numberOfBathrooms = bathRoomNoTextField.text {
            postAd.NumberOfBathrooms = _numberOfBathrooms
        }
        
        if let _numberOfFloors = floorsNoTextField.text {
            postAd.NumberOfFloors = _numberOfFloors
        }
        
        if let _finishing = finishingTextField.text {
            postAd.Finishing = _finishing
        }

        if let _ageOfBuilding = buildingAgeTextfield.text {
            postAd.AgeOfBuilding = _ageOfBuilding
        }
        
        if let _buildingSize = buildingSizeTextField.text {
            postAd.BuildingSize = _buildingSize
        }
        
        if let _landSize = landSizeTextField.text {
            postAd.LandSize = _landSize
        }
        
        if let _licenseType = licenseTypeTextField.text {
            postAd.LicenseType = _licenseType
        }
        
        if let _size = sizeTextField.text {
            postAd.Size = _size
        }

        if let _price = priceTextField.text {
            postAd.Price =  Double(_price) ?? 0
        }
        
        AppUtils.ShowLoading()
        SubmitAdsVM.postAd(_postAd: postAd, isEditMode: false) { (result, advId, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            self.backActionToRoot()
            self.showAlert(withTitle: .Success, text: "تمت علمية اضافة الإعلان رقم اعلانك هو : \(advId)")
        }
    }
    
}



extension UIImage {
    
    func imageUpMirror() -> UIImage {
        guard let cgImage = cgImage else { return self }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .upMirrored)
    }
    
    func imageDownMirror() -> UIImage {
        guard let cgImage = cgImage else { return self }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .downMirrored)
    }
    
    func imageLeftMirror() -> UIImage {
        guard let cgImage = cgImage else { return self }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .leftMirrored)
    }
    
    func imageRightMirror() -> UIImage {
        guard let cgImage = cgImage else { return self }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .rightMirrored)
    }
}

