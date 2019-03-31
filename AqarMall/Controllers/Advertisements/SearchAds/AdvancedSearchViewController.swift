//
//  AdvancedSearchViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/30/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class AdvancedSearchViewController: ViewController {
    @IBOutlet weak var textSearchView: UIView!
    @IBOutlet weak var advancedSearchView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        textSearchView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        advancedSearchView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    @IBAction func goBackAction() {
        self.leftAction()
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
