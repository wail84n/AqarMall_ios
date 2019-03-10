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

class SubmitAdvFormViewController: ViewController, ChooseAddressDelegate,CropViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var imagesCollection: UICollectionView!
    
    @IBOutlet weak var roomsNoTextField: UITextField!
    @IBOutlet weak var roomsNoView: UIView!
    @IBOutlet weak var pathRoomNoView: UIView!
    @IBOutlet weak var pathRoomNoTextField: UITextField!
    @IBOutlet weak var floorsNoView: UIView!
    @IBOutlet weak var floorsNoTextField: UITextField!
    @IBOutlet weak var finishingView: UIView!
    @IBOutlet weak var finishingTextField: UITextField!
    @IBOutlet weak var interfaceView: UIView!
    @IBOutlet weak var interfaceField: UITextField!
    @IBOutlet weak var buildingAgeView: UIView!
    @IBOutlet weak var buildingAgeTextfield: UITextField!
    @IBOutlet weak var buildingSizeView: UIView!
    @IBOutlet weak var buildingSizeTextField: UITextField!
    @IBOutlet weak var landSizeView: UIView!
    @IBOutlet weak var landSizeTextField: UITextField!
    @IBOutlet weak var licenseTypeView: UIView!
    @IBOutlet weak var licenseTypeTextField: UITextField!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var sizeTextField: UITextField!
    var selectedArea = AreasData()
    var category : CategoriesData? = nil
    var isRent = false
    
    var postAd = postAdv()
    
    var selectedImages : NSMutableArray!
    let imagePicker = UIImagePickerController()
    var selectedImagePickerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        title = "اضف اعلان - \(category?.name ?? "")"
        self.setBack()
        selectedImages = NSMutableArray()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1100 + 430)
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
        if selectedImages.count >= 9{
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
            
            print(self.selectedImages.count)
            print(9 - self.selectedImages.count)
            imagePicker.maximumSelectionsAllowed = 9 - self.selectedImages.count
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
        selectedImages.add(editedImage)
        imagesCollection.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  selectedImages.count == 0{
        }
        else if  selectedImages.count == 1{
            let imageData = (selectedImages[0] as! UIImage).jpeg(.lowest)
            self.postAd.image1 = imageData
            self.postAd.image2 = nil
            self.postAd.image3 = nil
            self.postAd.image4 = nil
            self.postAd.image5 = nil
            self.postAd.image6 = nil
            self.postAd.image7 = nil
            self.postAd.image8 = nil
            self.postAd.image9 = nil
        }
        else if  selectedImages.count == 2{
            let imageData = (selectedImages[0] as! UIImage).jpeg(.lowest)
            self.postAd.image1 = imageData
            let imageDat1 = (selectedImages[1] as! UIImage).jpeg(.lowest)
            self.postAd.image2 = imageDat1
            self.postAd.image3 = nil
            self.postAd.image4 = nil
            self.postAd.image5 = nil
            self.postAd.image6 = nil
            self.postAd.image7 = nil
            self.postAd.image8 = nil
            self.postAd.image9 = nil
            
        }
        else if  selectedImages.count == 3{
            let imageData = (selectedImages[0] as! UIImage).jpeg(.lowest)
            self.postAd.image1 = imageData
            let imageDat1 = (selectedImages[1] as! UIImage).jpeg(.lowest)
            self.postAd.image2 = imageDat1
            let imageDat2 = (selectedImages[2] as! UIImage).jpeg(.lowest)
            self.postAd.image3 = imageDat2
            self.postAd.image4 = nil
            self.postAd.image5 = nil
            self.postAd.image6 = nil
            self.postAd.image7 = nil
            self.postAd.image8 = nil
            self.postAd.image9 = nil
            
        }
        else if  selectedImages.count == 4{
            let imageData = (selectedImages[0] as! UIImage).jpeg(.lowest)
            self.postAd.image1 = imageData
            let imageDat1 = (selectedImages[1] as! UIImage).jpeg(.lowest)
            self.postAd.image2 = imageDat1
            let imageDat2 = (selectedImages[2] as! UIImage).jpeg(.lowest)
            self.postAd.image3 = imageDat2
            let imageDat3 = (selectedImages[3] as! UIImage).jpeg(.lowest)
            self.postAd.image4 = imageDat3
            self.postAd.image5 = nil
            self.postAd.image6 = nil
            self.postAd.image7 = nil
            self.postAd.image8 = nil
            self.postAd.image9 = nil
            
        }
        else if  selectedImages.count == 5{
            let imageData = (selectedImages[0] as! UIImage).jpeg(.lowest)
            self.postAd.image1 = imageData
            let imageDat1 = (selectedImages[1] as! UIImage).jpeg(.lowest)
            self.postAd.image2 = imageDat1
            let imageDat2 = (selectedImages[2] as! UIImage).jpeg(.lowest)
            self.postAd.image3 = imageDat2
            let imageDat3 = (selectedImages[3] as! UIImage).jpeg(.lowest)
            self.postAd.image4 = imageDat3
            let imageDat4 = (selectedImages[4] as! UIImage).jpeg(.lowest)
            self.postAd.image5 = imageDat4
            self.postAd.image6 = nil
            self.postAd.image7 = nil
            self.postAd.image8 = nil
            self.postAd.image9 = nil
        }
        else if  selectedImages.count == 6{
            let imageData = (selectedImages[0] as! UIImage).jpeg(.lowest)
            self.postAd.image1 = imageData
            let imageDat1 = (selectedImages[1] as! UIImage).jpeg(.lowest)
            self.postAd.image2 = imageDat1
            let imageDat2 = (selectedImages[2] as! UIImage).jpeg(.lowest)
            self.postAd.image3 = imageDat2
            let imageDat3 = (selectedImages[3] as! UIImage).jpeg(.lowest)
            self.postAd.image4 = imageDat3
            let imageDat4 = (selectedImages[4] as! UIImage).jpeg(.lowest)
            self.postAd.image5 = imageDat4
            let imageDat5 = (selectedImages[5] as! UIImage).jpeg(.lowest)
            self.postAd.image6 = imageDat5
            self.postAd.image7 = nil
            self.postAd.image8 = nil
            self.postAd.image9 = nil
            
        }
        else if  selectedImages.count == 7{
            let imageData = (selectedImages[0] as! UIImage).jpeg(.lowest)
            self.postAd.image1 = imageData
            let imageDat1 = (selectedImages[1] as! UIImage).jpeg(.lowest)
            self.postAd.image2 = imageDat1
            let imageDat2 = (selectedImages[2] as! UIImage).jpeg(.lowest)
            self.postAd.image3 = imageDat2
            let imageDat3 = (selectedImages[3] as! UIImage).jpeg(.lowest)
            self.postAd.image4 = imageDat3
            let imageDat4 = (selectedImages[4] as! UIImage).jpeg(.lowest)
            self.postAd.image5 = imageDat4
            let imageDat5 = (selectedImages[5] as! UIImage).jpeg(.lowest)
            self.postAd.image6 = imageDat5
            let imageDat6 = (selectedImages[6] as! UIImage).jpeg(.lowest)
            self.postAd.image7 = imageDat6
            self.postAd.image8 = nil
            self.postAd.image9 = nil
            
        }
        else if  selectedImages.count == 8{
            let imageData = (selectedImages[0] as! UIImage).jpeg(.lowest)
            self.postAd.image1 = imageData
            let imageDat1 = (selectedImages[1] as! UIImage).jpeg(.lowest)
            self.postAd.image2 = imageDat1
            let imageDat2 = (selectedImages[2] as! UIImage).jpeg(.lowest)
            self.postAd.image3 = imageDat2
            let imageDat3 = (selectedImages[3] as! UIImage).jpeg(.lowest)
            self.postAd.image4 = imageDat3
            let imageDat4 = (selectedImages[4] as! UIImage).jpeg(.lowest)
            self.postAd.image5 = imageDat4
            let imageDat5 = (selectedImages[5] as! UIImage).jpeg(.lowest)
            self.postAd.image6 = imageDat5
            let imageDat6 = (selectedImages[6] as! UIImage).jpeg(.lowest)
            self.postAd.image7 = imageDat6
            let imageDat7 = (selectedImages[7] as! UIImage).jpeg(.lowest)
            self.postAd.image8 = imageDat7
            self.postAd.image9 = nil
            
        }
        else if  selectedImages.count == 9{
            let imageData = (selectedImages[0] as! UIImage).jpeg(.lowest)
            self.postAd.image1 = imageData
            let imageDat1 = (selectedImages[1] as! UIImage).jpeg(.lowest)
            self.postAd.image2 = imageDat1
            let imageDat2 = (selectedImages[2] as! UIImage).jpeg(.lowest)
            self.postAd.image3 = imageDat2
            let imageDat3 = (selectedImages[3] as! UIImage).jpeg(.lowest)
            self.postAd.image4 = imageDat3
            let imageDat4 = (selectedImages[4] as! UIImage).jpeg(.lowest)
            self.postAd.image5 = imageDat4
            let imageDat5 = (selectedImages[5] as! UIImage).jpeg(.lowest)
            self.postAd.image6 = imageDat5
            let imageDat6 = (selectedImages[6] as! UIImage).jpeg(.lowest)
            self.postAd.image7 = imageDat6
            let imageDat7 = (selectedImages[7] as! UIImage).jpeg(.lowest)
            self.postAd.image8 = imageDat7
            let imageDat8 = (selectedImages[8] as! UIImage).jpeg(.lowest)
            self.postAd.image9 = imageDat8
            
        }
        
        return selectedImages.count
        
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
        
        cell?.myImageView.image =  (selectedImages[indexPath.row] as! UIImage)
        
        
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
            
            self.selectedImages.exchangeObject(at: 0, withObjectAt: indexPath.row)
            self.imagesCollection.reloadData()
            
            
            //            let libraryViewController = CameraViewController.imagePickerViewController(croppingEnabled: true) { image, asset in
            //                if image != nil {
            //                    self.updateImageAtIndex(editedImage: image!, index: indexPath)
            //
            //                }
            //                self.dismiss(animated: true, completion: nil)
            //            }
            //            self.present(libraryViewController, animated: true, completion: nil)
        }
        actionSheetController.addAction(libraryActionButton)
        
        let cameraActionButton: UIAlertAction = UIAlertAction(title: "حذف الصورة", style: .default)
        { action -> Void in
            
            self.selectedImages.removeObject(at: indexPath.row)
            self.imagesCollection.reloadData()
        }
        actionSheetController.addAction(cameraActionButton)
        
        
        let EditActionButton: UIAlertAction = UIAlertAction(title: "معالجة الصوره", style: .default)
        { action -> Void in
            self.imageIndex = indexPath.row
            let controller = CropViewController()
            controller.delegate = self
            controller.image = self.selectedImages[indexPath.row] as? UIImage
            
            
            
            let navController = UINavigationController(rootViewController: controller)
            self.present(navController, animated: true, completion: nil)
            
        }
        actionSheetController.addAction(EditActionButton)
        
        
        //        let leftActionButton: UIAlertAction = UIAlertAction(title: "لف الصورة لليسار", style: .default)
        //        { action -> Void in
        //            self.selectedImages[indexPath.row] = ((self.selectedImages[indexPath.row] as? UIImage)?.imageUpMirror())!
        //            self.imagesCollection.reloadData()
        //        }
        //        actionSheetController.addAction(leftActionButton)
        
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
        
        self.selectedImages[self.imageIndex] = image
        imagesCollection.reloadData()
        //        imageView.image = image
        //        updateEditButtonEnabled()
    }
    
    func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true, completion: nil)
        // updateEditButtonEnabled()
    }
    //    func collectionView(_ collectionView: UICollectionView,
    //                        layout collectionViewLayout: UICollectionViewLayout,
    //                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //    }
    
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
        //        selectedImages.removeAtIndex(index.row)
        //  selectedImages.remove(at: index.row)
        selectedImages.removeObject(at: index.row)
        
        selectedImages.insert(editedImage, at: index.row)
        imagesCollection.reloadData()
        
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

