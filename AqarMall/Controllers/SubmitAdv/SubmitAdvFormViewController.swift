//
//  SubmitAdvFormViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/4/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class SubmitAdvFormViewController: ViewController, ChooseAddressDelegate {
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var selectedArea = AreasData()
    var category : CategoriesData? = nil
    var isRent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        // Do any additional setup after loading the view.
    }
        
    func configureView(){
        title = "اضف اعلان - \(category?.name ?? "")"
        self.setBack()
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
