//
//  ViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 12/31/18.
//  Copyright © 2018 Macbookpro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ReceivedPushNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.ReceivedNotification), name: NSNotification.Name(rawValue: ReceivedPushNotification), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ReceivedPushNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ReceivedPushNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.ReceivedNotification), name: NSNotification.Name(rawValue: ReceivedPushNotification), object: nil)

    }
    
    @objc func ReceivedNotification(result : Notification?) {
        guard
            let _result = result,
            let _object = _result.object
            else{
                return
        }
        
        if _object as! String == "showSponsor" {            
            guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
                print("Error Could not get the rootViewController of keyWindow.")
                return
            }
            let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SponsorViewControllerNav") //as! SponsorViewController
            vc.present(gameVC, animated: true, completion: nil)
        }
    }

    func setBack(isDismiss : Bool = false){
        let buttonImage = #imageLiteral(resourceName: "back")
        let button = UIButton(type: .system)
        button.setImage(buttonImage, for: .normal)
        // button.backgroundColor = UIColor.red
        button.tintColor = UIColor.gray
        button.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        if isDismiss == false {
            button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        }else{
            button.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        }
        
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func backAction() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func backActionToRoot() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc func leftAction() {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
