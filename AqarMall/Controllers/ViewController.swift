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

        // Do any additional setup after loading the view.
    }
    

    func setBack(){
        let buttonImage = #imageLiteral(resourceName: "back")
        let button = UIButton(type: .system)
        button.setImage(buttonImage, for: .normal)
        // button.backgroundColor = UIColor.red
        button.tintColor = UIColor.gray
        button.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func backAction() {
        _ = navigationController?.popViewController(animated: true)
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
