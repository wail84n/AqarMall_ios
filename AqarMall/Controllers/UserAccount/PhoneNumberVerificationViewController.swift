//
//  PhoneNumberVerificationViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/11/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class PhoneNumberVerificationViewController: ViewController {

    var timer = Timer()
    var counter = 0
    @IBOutlet weak var counterLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    

    func configureView(){
        title = "تفعيل رقم الهاتف"
        self.setBack()
        timer.invalidate() // just in case this button is tapped multiple times

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

    }
    
    @objc func timerAction() {
        counter += 1
        counterLabel.text = "\(30 - counter)"
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
