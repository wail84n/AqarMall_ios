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


class printAdvViewController: UIViewController,OTResizableViewDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resizableDetailsView = OTResizableView(contentView: detailsView)
        resizableDetailsView.tag = 1
        resizableDetailsView.delegate = self;
        
        resizableTitleView = OTResizableView(contentView: titleView)
        resizableTitleView.tag = 2
        resizableTitleView.delegate = self;
        
        
        resizableImageBGView = OTResizableView(contentView: imageView)
        resizableImageBGView.tag = 3
        resizableImageBGView.delegate = self;
        
        mainView.addSubview(resizableImageBGView)
        mainView.addSubview(resizableDetailsView)
        mainView.addSubview(resizableTitleView)
        
        
        print(adDetails.details)
        detailsTextView.text = adDetails.details
        titleTextView.text = adDetails.title
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

        if resizableView.resizeEnabled == false {return}
        switch resizableView.tag {
        case 1:
            titleLabel.text = "تفاصيل الإعلان"
            titleTextView.backgroundColor = UIColor.clear
            titleView.backgroundColor = UIColor.clear
            titleTextView.isEditable = false
            titleTextView.isSelectable = false
            resizableImageBGView.resizeEnabled = !resizableView.resizeEnabled
            resizableTitleView.resizeEnabled = !resizableView.resizeEnabled
        case 2:
            titleLabel.text = "عنوان الإعلان"
            titleTextView.backgroundColor = UIColor.lightText
            titleView.backgroundColor = UIColor.lightGray
            titleTextView.isEditable = true
            titleTextView.isSelectable = true
            resizableImageBGView.resizeEnabled = !resizableView.resizeEnabled
            resizableDetailsView.resizeEnabled = !resizableView.resizeEnabled
        case 3:
            titleLabel.text = "الصورة الإفتراضية"
            
            titleTextView.backgroundColor = UIColor.clear
            titleTextView.isEditable = false
            titleTextView.isSelectable = false
            titleView.backgroundColor = UIColor.clear
            
            resizableDetailsView.resizeEnabled = !resizableView.resizeEnabled
            resizableTitleView.resizeEnabled = !resizableView.resizeEnabled
        default:
            return
        }
        print("tapBegin:\(resizableView.frame)")
    }
    
    
    func tapChanged(_ resizableView: OTResizableView) {
        print("tapChanged:\(resizableView.frame))")
        
        if resizableView.tag == 1{
            detailsTextView.frame = CGRect(x: 15, y: 15, width: resizableView.frame.size.width - 50, height: resizableView.frame.size.height - 50)
        }else if resizableView.tag == 2{
            titleTextView.frame = CGRect(x: 15, y: 15, width: resizableView.frame.size.width - 50, height: resizableView.frame.size.height - 50)
        }else if resizableView.tag == 3{
            imageBG.frame = CGRect(x: -20, y: -20, width: resizableView.frame.size.width + 20, height: resizableView.frame.size.height + 20)
        }
    }
    
    
    func tapMoved(_ resizableView: OTResizableView) {
        print("tapMoved:\(resizableView.frame))")
    }
    
    
    func tapEnd(_ resizableView: OTResizableView) {
        print("tapEnd:\(resizableView.frame)")
        
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
