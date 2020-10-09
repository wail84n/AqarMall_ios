//
//  SponsorViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/14/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class SponsorViewController: UIViewController {
    @IBOutlet weak var sponsorImageView: UIImageView!
    var sponsor : Sponsor? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    private func configureView(){
     //   self.backAction()
        
      //  AppUtils.SendGAIScreenName(screenName: "الراعي الرسمي")
        if let _sponsor = Sponsor(object: AppUtils.LoadDictionaryData(key: .sponsor)) {
            sponsor = _sponsor
            
            self.updateViews()
        }

        let pictureURL = APIs.shared.getFileURL(imageName: "/Sponsor/\(sponsor?.fileName ?? "")")!

        self.sponsorImageView?.af_setImage(
            withURL: pictureURL ,
            placeholderImage: nil,
            filter: nil,
            imageTransition: UIImageView.ImageTransition.crossDissolve(0.7),
            runImageTransitionIfCached: false) {
                // Completion closure
                response in
                // Check if the image isn't already cached
                if response.response != nil {
                    // Force the cell update
                }
        }
    }
    
    
    func updateViews(){
        APIs.shared.updateSponsorViewCount(id: Int64(sponsor?.sponsorID ?? 0)){ (advViews, error) in
            guard error == nil else {
                print(error ?? "")
                return
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
//
    @IBAction func back(_ sender: Any) {
        //removeAnimate()
        self.leftAction()
    }
    
    @objc func leftAction() {
        dismiss(animated: true)
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
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
