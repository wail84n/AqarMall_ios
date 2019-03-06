//
//  ChooseAdvSectionViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/2/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class ChooseAdvSectionViewController: ViewController {

    @IBOutlet weak var forSaleView: UIView!
    @IBOutlet weak var forRentView: UIView!
    @IBOutlet weak var forExchangeView: UIView!
    @IBOutlet weak var RequiredView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        title = "أضف اعلانك"
    }
    
    @IBAction func forSaleAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state{
        case .began:
         //   forSaleView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            UIView.animate(withDuration: 0.1, animations: {
                self.forSaleView.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
                self.forSaleView.alpha = 0.6
            })
        case .ended,.cancelled:
            forSaleView.backgroundColor = UIColor.white
            UIView.animate(withDuration: 0.1, animations: {
                self.forSaleView.alpha = 1
                self.forSaleView.transform = CGAffineTransform.identity
            }, completion: { (completed) in
                let vc = UIStoryboard(name: "SubmitAdv", bundle: nil).instantiateViewController(withIdentifier: "ChooseAdvCatedoryViewController") as! ChooseAdvCatedoryViewController
                vc.isRent = false
                self.navigationController?.pushViewController(vc, animated: true)
            })
        default:
            break
        }
    }

    @IBAction func forRentAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state{
        case .began:
            UIView.animate(withDuration: 0.1, animations: {
                self.forRentView.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
                self.forRentView.alpha = 0.6
            })
        case .ended,.cancelled:
            forRentView.backgroundColor = UIColor.white
            UIView.animate(withDuration: 0.1, animations: {
                self.forRentView.alpha = 1
                self.forRentView.transform = CGAffineTransform.identity
            }, completion: { (completed) in
                let vc = UIStoryboard(name: "SubmitAdv", bundle: nil).instantiateViewController(withIdentifier: "ChooseAdvCatedoryViewController") as! ChooseAdvCatedoryViewController
                vc.isRent = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
        default:
            break
        }
    }
    
    

    @IBAction func forExchangeAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state{
        case .began:
            UIView.animate(withDuration: 0.1, animations: {
                self.forExchangeView.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
                self.forExchangeView.alpha = 0.6
            })
        case .ended,.cancelled:
            forExchangeView.backgroundColor = UIColor.white
            UIView.animate(withDuration: 0.1, animations: {
                self.forExchangeView.alpha = 1
                self.forExchangeView.transform = CGAffineTransform.identity
            }, completion: { (completed) in


            })
        default:
            break
        }
    }
    
    

    @IBAction func RequiredAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state{
        case .began:
            UIView.animate(withDuration: 0.1, animations: {
                self.RequiredView.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
                self.RequiredView.alpha = 0.6
            })
        case .ended,.cancelled:
            RequiredView.backgroundColor = UIColor.white
            UIView.animate(withDuration: 0.1, animations: {
                self.RequiredView.alpha = 1
                self.RequiredView.transform = CGAffineTransform.identity
            }, completion: { (completed) in

                
            })
        default:
            break
        }
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
