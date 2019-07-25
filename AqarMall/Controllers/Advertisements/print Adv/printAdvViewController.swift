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
    var resizablePhoneNoView = OTResizableView(contentView: UIView())
    var resizableImageBGView = OTResizableView(contentView: UIView())
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var phoneNoView: UIView!
    @IBOutlet weak var phoneNoTextView: UITextView!
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var printTextColor: PrintTextColor = .noun
    
    var adDetails = AdvertisementInfo()
    var selectedItem = -1
    var titleFont: CGFloat = 16
    var phoneFont: CGFloat = 25
    var detailsFont: CGFloat = 14
    var _printAdvRecord = printAdvRecord()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
         configureView()
    }
    
    func configureView(){
        titleTextView.isEditable = false
        titleTextView.isSelectable = false
        detailsTextView.isEditable = false
        detailsTextView.isSelectable = false
        phoneNoTextView.isEditable = false
        phoneNoTextView.isSelectable = false
        
        resizableTitleView.resizeEnabled = false
        resizablePhoneNoView.resizeEnabled = false
        resizableImageBGView.resizeEnabled = false
        resizableDetailsView.resizeEnabled = false

        if let printAdvRecord = printAdvRecord(object: AppUtils.LoadDictionaryData(key: .print_adv_screen_shot)) {
            _printAdvRecord = printAdvRecord
            if _printAdvRecord.titleColor != .clear {
                self.titleTextView.textColor = _printAdvRecord.titleColor
            }
            
            if _printAdvRecord.textColor != .clear {
                self.detailsTextView.textColor = _printAdvRecord.textColor
            }
            
            if _printAdvRecord.text_fontSize != 0 {
                detailsFont = _printAdvRecord.text_fontSize!
                detailsTextView.font = UIFont.systemFont(ofSize: detailsFont)
            }
            
            if _printAdvRecord.title_fontSize != 0 {
                titleFont = _printAdvRecord.title_fontSize!
                titleTextView.font = UIFont.systemFont(ofSize: titleFont)
            }

            if _printAdvRecord.phone_fontSize != 0 {
                phoneFont = _printAdvRecord.phone_fontSize!
                phoneNoTextView.font = UIFont.systemFont(ofSize: phoneFont)
            }

            
            if _printAdvRecord.text_height != 0 && _printAdvRecord.text_width != 0 {
                self.detailsView.frame =  CGRect(x: _printAdvRecord.text_x! , y: _printAdvRecord.text_y!, width: _printAdvRecord.text_width!, height: _printAdvRecord.text_height!)
                
                detailsTextView.frame = CGRect(x: 15, y: 15, width: _printAdvRecord.text_width! - 30, height: _printAdvRecord.text_height! - 30)
            }
            
            if _printAdvRecord.title_width != 0 && _printAdvRecord.title_height != 0 {
                self.titleView.frame =  CGRect(x: _printAdvRecord.title_x!, y: _printAdvRecord.title_y!, width: _printAdvRecord.title_width!, height: _printAdvRecord.title_height!)
                
                titleTextView.frame = CGRect(x: 15, y: 15, width: _printAdvRecord.title_width! - 30, height: _printAdvRecord.title_height! - 30)
            }
            
            if _printAdvRecord.phone_width != 0 && _printAdvRecord.phone_height != 0 {
                self.phoneNoView.frame =  CGRect(x: _printAdvRecord.phone_x!, y: _printAdvRecord.phone_y!, width: _printAdvRecord.phone_width!, height: _printAdvRecord.phone_height!)
                
                phoneNoTextView.frame = CGRect(x: 15, y: 15, width: _printAdvRecord.phone_width! - 30, height: _printAdvRecord.phone_height! - 30)
            }
            
            if _printAdvRecord.imageBG_width != 0 && _printAdvRecord.imageBG_height != 0 {
                self.imageView.frame =  CGRect(x: _printAdvRecord.imageBG_x!, y: _printAdvRecord.imageBG_y!, width:
                    _printAdvRecord.imageBG_width!, height: _printAdvRecord.imageBG_height!)
            }
            
            print(_printAdvRecord.nsDictionary)
        }
        
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
        
        
        resizablePhoneNoView = OTResizableView(contentView: phoneNoView)
        resizablePhoneNoView.tag = 4
        resizablePhoneNoView.delegate = self;
        
        
        mainView.addSubview(resizableImageBGView)
        mainView.addSubview(resizableDetailsView)
        mainView.addSubview(resizableTitleView)
        mainView.addSubview(resizablePhoneNoView)
        
        detailsTextView.text = adDetails.details
        
        
        if let title = adDetails.title {
            titleTextView.text = title.isEmpty ? "العنوان" : title
        }else{
            titleTextView.text = "العنوان"
        }
        phoneNoTextView.text = adDetails.phone
        
        titleTextView.font = UIFont.systemFont(ofSize: titleFont)
        detailsTextView.font = UIFont.systemFont(ofSize: detailsFont)
        phoneNoTextView.font = UIFont.systemFont(ofSize: phoneFont)
        
        detailsView.backgroundColor = UIColor.clear
        titleView.backgroundColor = UIColor.clear
        phoneNoView.backgroundColor = UIColor.clear
        saveData()
        readData()
    }
    
    func saveData(){
      //  _printAdvRecord.imageBG_image = "wail"
       // _printAdvRecord.titleColor = .green
        UserDefaults.standard.set(_printAdvRecord.nsDictionary, forKey: "print_adv_screen_shot")
    }
    
    func readData(){
        if let _printAdvRecordee = printAdvRecord(object: AppUtils.LoadDictionaryData(key: .print_adv_screen_shot)) {
            self.titleTextView.textColor = _printAdvRecordee.titleColor
            self.phoneNoTextView.textColor = _printAdvRecordee.phoneColor
          //  let whiteColor = UIColor(hexaDecimalString: stringWhite)

            print(_printAdvRecordee.nsDictionary)
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
        phoneNoTextView.backgroundColor = UIColor.clear
        
        titleTextView.isEditable = false
        titleTextView.isSelectable = false
        
        detailsTextView.isEditable = false
        detailsTextView.isSelectable = false
        
        phoneNoTextView.isEditable = false
        phoneNoTextView.isSelectable = false
        
        resizableImageBGView.resizeEnabled = false
        resizableDetailsView.resizeEnabled = false
        resizableTitleView.resizeEnabled = false
        resizablePhoneNoView.resizeEnabled = false
    }
    
    @IBAction func increasFontAction(_ sender: Any) {
        switch selectedItem {
        case 1:
            detailsFont += 1
            _printAdvRecord.text_fontSize = detailsFont
            detailsTextView.font = UIFont.systemFont(ofSize: detailsFont)
        case 2:
            titleFont += 1
            _printAdvRecord.title_fontSize = titleFont
            titleTextView.font = UIFont.systemFont(ofSize: titleFont)
        case 4:
            phoneFont += 1
            _printAdvRecord.phone_fontSize = phoneFont
            phoneNoTextView.font = UIFont.systemFont(ofSize: phoneFont)
        default:
            return
        }
        UserDefaults.standard.set(_printAdvRecord.nsDictionary, forKey: "print_adv_screen_shot")
    }
    
    @IBAction func decreasFontAction(_ sender: Any) {
        switch selectedItem {
        case 1:
            detailsFont -= 1
            _printAdvRecord.text_fontSize = detailsFont
            detailsTextView.font = UIFont.systemFont(ofSize: detailsFont)
        case 2:
            titleFont -= 1
            _printAdvRecord.title_fontSize = titleFont
            titleTextView.font = UIFont.systemFont(ofSize: titleFont)
        case 4:
            phoneFont -= 1
            _printAdvRecord.phone_fontSize = phoneFont
            phoneNoTextView.font = UIFont.systemFont(ofSize: phoneFont)
        default:
            return
        }
        UserDefaults.standard.set(_printAdvRecord.nsDictionary, forKey: "print_adv_screen_shot")
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
            _printAdvRecord.textColor = color
            detailsTextView.textColor = color
        case 2:
            _printAdvRecord.titleColor = color
            titleTextView.textColor = color
        case 4:
            _printAdvRecord.phoneColor = color
            phoneNoTextView.textColor = color
        default:
            return
        }
        UserDefaults.standard.set(_printAdvRecord.nsDictionary, forKey: "print_adv_screen_shot")

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
            detailsTextView.backgroundColor = UIColor.lightWhite()
            titleTextView.backgroundColor = UIColor.clear
            phoneNoTextView.backgroundColor = UIColor.clear
            
            detailsTextView.isEditable = true
            detailsTextView.isSelectable = true
            
            titleTextView.isEditable = false
            titleTextView.isSelectable = false
            
            phoneNoTextView.isEditable = false
            phoneNoTextView.isSelectable = false
            
            resizableImageBGView.resizeEnabled = !resizableView.resizeEnabled
            resizableTitleView.resizeEnabled = !resizableView.resizeEnabled
            resizablePhoneNoView.resizeEnabled = !resizableView.resizeEnabled
        case 2:
            titleLabel.text = "عنوان الإعلان"
            
            titleTextView.backgroundColor = UIColor.lightWhite()
            detailsTextView.backgroundColor = UIColor.clear
            phoneNoTextView.backgroundColor = UIColor.clear
            
            titleTextView.isEditable = true
            titleTextView.isSelectable = true
            
            detailsTextView.isEditable = false
            detailsTextView.isSelectable = false
            
            phoneNoTextView.isEditable = false
            phoneNoTextView.isSelectable = false
            
            resizableImageBGView.resizeEnabled = !resizableView.resizeEnabled
            resizableDetailsView.resizeEnabled = !resizableView.resizeEnabled
            resizablePhoneNoView.resizeEnabled = !resizableView.resizeEnabled
        case 3:
            titleLabel.text = "الصورة الإفتراضية"
            
            titleTextView.backgroundColor = UIColor.clear
            detailsTextView.backgroundColor = UIColor.clear
            phoneNoTextView.backgroundColor = UIColor.clear
            
            titleTextView.isEditable = false
            titleTextView.isSelectable = false
            detailsTextView.isEditable = false
            detailsTextView.isSelectable = false
            phoneNoTextView.isEditable = false
            phoneNoTextView.isSelectable = false
            
            resizableDetailsView.resizeEnabled = !resizableView.resizeEnabled
            resizableTitleView.resizeEnabled = !resizableView.resizeEnabled
            resizablePhoneNoView.resizeEnabled = !resizableView.resizeEnabled
        case 4:
            titleLabel.text = "رقم الهاتف"
            phoneNoTextView.backgroundColor = UIColor.lightWhite()
            detailsTextView.backgroundColor = UIColor.clear
            titleTextView.backgroundColor = UIColor.clear
            
            phoneNoTextView.isEditable = true
            phoneNoTextView.isSelectable = true
            
            detailsTextView.isEditable = false
            detailsTextView.isSelectable = false
            
            titleTextView.isEditable = false
            titleTextView.isSelectable = false
            
            resizableImageBGView.resizeEnabled = !resizableView.resizeEnabled
            resizableDetailsView.resizeEnabled = !resizableView.resizeEnabled
            resizableTitleView.resizeEnabled = !resizableView.resizeEnabled
        default:
            return
        }
        print("tapBegin:\(resizableView.frame)")
    }
    
    //    func takeScreenshot(view: UIView) -> UIImageView {
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
        //   mainView.frame = CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height)
        
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
        }else if resizableView.tag == 4{
            phoneNoTextView.frame = CGRect(x: 15, y: 15, width: resizableView.frame.size.width - 50, height: resizableView.frame.size.height - 50)
        }
    }
    
    func tapMoved(_ resizableView: OTResizableView) {
        print("tapMoved:\(resizableView.frame))")
    }
    
    func tapEnd(_ resizableView: OTResizableView) {
        print("tapEnd:\(resizableView.frame)")
        if resizableView.tag == 1{
            _printAdvRecord.text_x = resizableView.frame.origin.x + 10
            _printAdvRecord.text_y = resizableView.frame.origin.y + 10
            _printAdvRecord.text_width = resizableView.frame.size.width - 15
            _printAdvRecord.text_height = resizableView.frame.size.height - 15
        }else if resizableView.tag == 2{
            _printAdvRecord.title_x = resizableView.frame.origin.x + 10
            _printAdvRecord.title_y = resizableView.frame.origin.y + 10
            _printAdvRecord.title_width = resizableView.frame.size.width - 15
            _printAdvRecord.title_height = resizableView.frame.size.height - 15
        }else if resizableView.tag == 3{
            _printAdvRecord.imageBG_x = resizableView.frame.origin.x
            _printAdvRecord.imageBG_y = resizableView.frame.origin.y
            _printAdvRecord.imageBG_width = resizableView.frame.size.width
            _printAdvRecord.imageBG_height = resizableView.frame.size.height
        }else if resizableView.tag == 4{
            _printAdvRecord.phone_x = resizableView.frame.origin.x + 10
            _printAdvRecord.phone_y = resizableView.frame.origin.y + 10
            _printAdvRecord.phone_width = resizableView.frame.size.width - 15
            _printAdvRecord.phone_height = resizableView.frame.size.height - 15
        }
        UserDefaults.standard.set(_printAdvRecord.nsDictionary, forKey: "print_adv_screen_shot")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navPlace = segue.destination as? SelectColorViewController {
            navPlace.delegate = self
            
        }
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
