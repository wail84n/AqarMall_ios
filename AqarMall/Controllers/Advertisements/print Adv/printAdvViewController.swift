//
//  printAdvViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 6/24/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import OTResizableView
import SDWebImage
import OpalImagePicker
import Photos


class printAdvViewController: UIViewController,OTResizableViewDelegate, SelectColorDelegate {

    var resizableDetailsView = OTResizableView(contentView: UIView())
    var resizableTitleView = OTResizableView(contentView: UIView())
    var resizableImageBGView = OTResizableView(contentView: UIView())
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var adDetails = AdvertisementInfo()
    var selectedItem = -1
    var titleFont: CGFloat = 16
    var detailsFont: CGFloat = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  var style = (firstName: "John", lastName: "Smith")
        resizableDetailsView = OTResizableView(contentView: detailsView)
        resizableDetailsView.tag = 1
        resizableDetailsView.delegate = self;
        
        resizableTitleView = OTResizableView(contentView: titleView)
        resizableTitleView.tag = 2
        resizableTitleView.delegate = self;
        
        let screenSize = UIScreen.main.bounds
        let imageView_height = screenSize.size.width * 1.12
        imageView.frame =  CGRect(x: 0, y: 40.0, width: screenSize.size.width, height: imageView_height)
        imageBG.frame =  CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height)
        
        resizableImageBGView = OTResizableView(contentView: imageView)
        resizableImageBGView.tag = 3
        resizableImageBGView.delegate = self;
        
        mainView.addSubview(resizableImageBGView)
        mainView.addSubview(resizableDetailsView)
        mainView.addSubview(resizableTitleView)
        
        detailsTextView.text = adDetails.details
        
        if let title = adDetails.title {
            titleTextView.text = title.isEmpty ? "العنوان" : title
        }else{
            titleTextView.text = "العنوان"
        }
        
        titleTextView.font = UIFont.systemFont(ofSize: titleFont)
        detailsTextView.font = UIFont.systemFont(ofSize: detailsFont)
        
        detailsView.backgroundColor = UIColor.clear
        titleView.backgroundColor = UIColor.clear
        
        //saveData()
        readData()
    }
    
    func saveData(){
        var accessLavels: AccessTuple = (hasInventoryAccess: "imageBG.frame", hasPayrolAccess: "imageView.frame")
        
        // Writing to defaults
        let accessLevelDictionary = serializeTuple(tuple: accessLavels)
        
        print(accessLevelDictionary)
        UserDefaults.standard.set(accessLevelDictionary, forKey: "print_adv_screen_shot")
        

    }
 
    func readData(){
        let accessDic = UserDefaults.standard.dictionary(forKey: "print_adv_screen_shot") as! AccessDictionary
        var accessLev = deserializeDictionary(dictionary: accessDic)
        
        print(accessLev.hasInventoryAccess)
        
        accessLev.hasInventoryAccess = "wail"
        
        let accessLevelDictionary = serializeTuple(tuple: accessLev)
        UserDefaults.standard.set(accessLevelDictionary, forKey: "print_adv_screen_shot")
        
        if let _sponsor = printAdvRecord(object: AppUtils.LoadDictionaryData(key: .print_adv_screen_shot)) {

        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takeScreenShotAction(_ sender: Any) {
     //   takeScreenshot(view: mainView)
       // captureScreenshot()
        
        selectedItem = -1
        titleTextView.backgroundColor = UIColor.clear
        detailsTextView.backgroundColor = UIColor.clear
        
        titleTextView.isEditable = false
        titleTextView.isSelectable = false
        
        detailsTextView.isEditable = false
        detailsTextView.isSelectable = false
        
        
        resizableImageBGView.resizeEnabled = false
        resizableDetailsView.resizeEnabled = false
        resizableTitleView.resizeEnabled = false
    }
    
    @IBAction func increasFontAction(_ sender: Any) {
        switch selectedItem {
        case 1:
            detailsFont += 1
            detailsTextView.font = UIFont.systemFont(ofSize: detailsFont)
        case 2:
            titleFont += 1
            titleTextView.font = UIFont.systemFont(ofSize: titleFont)
        default:
            return
        }
    }
    
    @IBAction func decreasFontAction(_ sender: Any) {
        switch selectedItem {
        case 1:
            detailsFont -= 1
            detailsTextView.font = UIFont.systemFont(ofSize: detailsFont)
        case 2:
            titleFont -= 1
            titleTextView.font = UIFont.systemFont(ofSize: titleFont)
        default:
            return
        }
    }
    
    @IBAction func addImageAction(_ sender: Any) {
        //  self.openImagePicker(with: .photoLibrary)
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            //Show error to user?
            return
        }
        
        //Example Instantiating OpalImagePickerController with Closures
        let imagePicker = OpalImagePickerController()
        
        imagePicker.maximumSelectionsAllowed = 1
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        //Present Image Picker
        self.presentOpalImagePickerController(imagePicker, animated: true, select: { (images) in
            //Save Images, update UI
            
            print(images.count)
            
            for image in images {
                self.imageBG.image =  self.getUIImage(asset: image)
                //self.showSelectedImageNew(editedImage: self.getAssetThumbnail(asset: image))
            }
            
            //Dismiss Controller
            imagePicker.dismiss(animated: true, completion: nil)
        }, cancel: {
            //Cancel action?
            
        })

    }
    
    func selectedColor(color: UIColor) {
        switch selectedItem {
        case 1:
            detailsTextView.textColor = color
        case 2:
            titleTextView.textColor = color
        default:
            return
        }
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//    @IBAction func tappedChangeAspectButton(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected {
//            resizableDetailsView.keepAspectEnabled = true
//        } else {
//            resizableDetailsView.keepAspectEnabled = false
//            resizableDetailsView.minimumWidth = 100
//            resizableDetailsView.minimumHeight = 100
//        }
//    }
    
    func tapBegin(_ resizableView: OTResizableView) {
        print("resizableView.resizeEnabled \(resizableView.resizeEnabled)")
      resizableView.resizeEnabled = resizableView.resizeEnabled ? false : true

        if resizableView.resizeEnabled == false
        {
//            selectedItem = -1
//            titleTextView.backgroundColor = UIColor.clear
//            detailsTextView.backgroundColor = UIColor.clear
//            
//          //  titleTextView.isEditable = false
//            titleTextView.isSelectable = false
//            
//            // detailsTextView.isEditable = false
//            detailsTextView.isSelectable = false
            
            return
        }
        selectedItem = resizableView.tag
        switch resizableView.tag {
        case 1:
            titleLabel.text = "تفاصيل الإعلان"
            detailsTextView.backgroundColor = UIColor.white
            
            detailsTextView.isEditable = true
            detailsTextView.isSelectable = true
            
            titleTextView.backgroundColor = UIColor.clear

            titleTextView.isEditable = false
            titleTextView.isSelectable = false

            resizableImageBGView.resizeEnabled = !resizableView.resizeEnabled
            resizableTitleView.resizeEnabled = !resizableView.resizeEnabled
        case 2:
            titleLabel.text = "عنوان الإعلان"
            titleTextView.backgroundColor = UIColor.lightText
            
            detailsTextView.backgroundColor = UIColor.clear
            
            titleTextView.isEditable = true
            titleTextView.isSelectable = true
            
            detailsTextView.isEditable = false
            detailsTextView.isSelectable = false
            
            resizableImageBGView.resizeEnabled = !resizableView.resizeEnabled
            resizableDetailsView.resizeEnabled = !resizableView.resizeEnabled
        case 3:
            titleLabel.text = "الصورة الإفتراضية"
            
            titleTextView.backgroundColor = UIColor.clear
            detailsTextView.backgroundColor = UIColor.clear
            
            titleTextView.isEditable = false
            titleTextView.isSelectable = false
            detailsTextView.isEditable = false
            detailsTextView.isSelectable = false
            
            resizableDetailsView.resizeEnabled = !resizableView.resizeEnabled
            resizableTitleView.resizeEnabled = !resizableView.resizeEnabled
        default:
            return
        }
        print("tapBegin:\(resizableView.frame)")
    }
    
//    func takeScreenshot(view: UIView) -> UIImageView {
//
//        UIGraphicsBeginImageContext(view.frame.size)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
//
//        return UIImageView(image: image)
//    }
    
    func captureScreenshot(){
     //   imageView.frame = CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height)
        
       // mainView.frame = CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height)
        
        let layer = mainView.layer // UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // THIS IS TO SAVE SCREENSHOT TO PHOTOS
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
    }
    
    func tapChanged(_ resizableView: OTResizableView) {
        print("tapChanged:\(resizableView.frame))")
        
        if resizableView.tag == 1{
            detailsTextView.frame = CGRect(x: 15, y: 15, width: resizableView.frame.size.width - 50, height: resizableView.frame.size.height - 50)
        }else if resizableView.tag == 2{
            titleTextView.frame = CGRect(x: 15, y: 15, width: resizableView.frame.size.width - 50, height: resizableView.frame.size.height - 50)
        }else if resizableView.tag == 3{
            imageBG.frame = CGRect(x:-10, y: -10, width: resizableView.frame.size.width , height: resizableView.frame.size.height)
            
         //   mainView.frame = imageBG.frame // CGRect(x: 0, y: 0, width: imageBG.frame.size.width, height: imageBG.frame.size.height)
        }
    }

    func tapMoved(_ resizableView: OTResizableView) {
        print("tapMoved:\(resizableView.frame))")
    }
    
    func tapEnd(_ resizableView: OTResizableView) {
        print("tapEnd:\(resizableView.frame)")
        
    //    AccessTuple = (hasInventoryAccess: resizableView.frame, hasPayrolAccess: resizableView.frame)
    

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navPlace = segue.destination as? SelectColorViewController {
            navPlace.delegate = self
        }
    }
    
    
    typealias AccessTuple = (hasInventoryAccess: String, hasPayrolAccess: String)
    typealias AccessDictionary = [String: String]
    
    let InventoryKey = "hasInventoryAccess"
    let PayrollKey = "hasPayrollAccess"
    

    func serializeTuple(tuple: AccessTuple) -> AccessDictionary {
        return [
            InventoryKey : tuple.hasInventoryAccess,
            PayrollKey : tuple.hasPayrolAccess
        ]
    }
    
    func deserializeDictionary(dictionary: AccessDictionary) -> AccessTuple {
        return AccessTuple(
            dictionary[InventoryKey] as String!,
            dictionary[PayrollKey] as String!
        )
    }

    
}


extension printAdvViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    fileprivate func openImagePicker(with sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
    
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingIMAGEWithInfo info: [String : Any]) {
//        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else {
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//        
//        imageBG.image = selectedImage
//     //   showCropper(for: chosenImage)
//        dismiss(animated:true, completion: nil)
//    }
}


extension CGRect: Hashable {
    public var hashValue: Int {
        return NSCoder.string(for: self).hashValue
    }
}
