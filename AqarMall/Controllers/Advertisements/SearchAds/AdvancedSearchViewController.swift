//
//  AdvancedSearchViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/30/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl

protocol AdvancedSearchDelegate : class {
    func textSearch(with parameters:[String:Any])
    func advancedSearch(with parameters:[String:Any])
}

class AdvancedSearchViewController: ViewController, SelectAddressDelegate {
    @IBOutlet weak var textSearchView: UIView!
    @IBOutlet weak var advancedSearchView: UIView!
    @IBOutlet weak var sectionSegment: UISegmentedControl!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var provinceView: UIView!
    @IBOutlet weak var areaView: UIView!
    
    @IBOutlet weak var fromPriceTextField: UITextField!
    @IBOutlet weak var toPriceTextField: UITextField!
    @IBOutlet weak var fromSizeTextField: UITextField!
    @IBOutlet weak var toSizeTextField: UITextField!
    
    var delegate: AdvancedSearchDelegate? = nil
    var segmentedControl: ScrollableSegmentedControl!
    var categories = [CategoriesData]()
    
    var selectedProvince = Provinces(_entryID: 0, _name: "جميع المحافظات")
    var selectedArea = Areas(_entryID: 0, _name: "جميع المناطق")
    var sectionId : Int16 = 0
    var advancedSearch = AdvancedSearch()
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        getCategoriesData(isRent: true)
        advancedSearch.sectionID = sectionId
        textSearchView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        advancedSearchView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    
    @IBAction func selectProvince(_ sender: Any) {
        
        //  performSegue(withIdentifier: "selectAddressSB", sender: true)
    }
    
    @IBAction func selectArea(_ sender: Any) {
        if selectedProvince?.entryID == 0 {
            self.showAlert(withTitle: .Missing, text: "الرجاء اختر المحافظة اولاً")
        }else{
            performSegue(withIdentifier: "selectAreaAdvancedSearchSB", sender: true)
        }
    }
    
    func setProvince(with province: Provinces) {
        print(province.name)
        if province.entryID == 0 || selectedProvince?.entryID != province.entryID{
            selectedArea = Areas(_entryID: 0, _name: "جميع المناطق")
            areaLabel.text = selectedArea!.name
        }
        provinceLabel.text = province.name
        selectedProvince = province
        
    }
    
    func setArea(with area: Areas) {
        areaLabel.text = area.name
        selectedArea = area

    }
    
    @IBAction func changeSection(_ sender: Any) {
       // intCat = 0
        switch sectionSegment.selectedSegmentIndex
        {
        case 0:
            getCategoriesData(isRent: true)
        case 1:
            getCategoriesData(isRent: false)
        default:
            break
        }
    }
    
    @IBAction func StartAdvancesSearch(_ sender: Any) {
        
    }
    
    func validateEntry()-> Bool{
        fromPriceTextField.borderColor = UIColor.clear
        toPriceTextField.borderColor = UIColor.clear
        if fromPriceTextField.text?.isEmpty == false && toPriceTextField.text?.isEmpty == false {
            
            guard let fromPrice = Int(fromPriceTextField.text ?? "0"),
                let toPrice = Int(toPriceTextField.text ?? "0")
                else{
                    return false
            }
            
            if toPrice > fromPrice {
                fromPriceTextField.borderColor = UIColor.red.withAlphaComponent(0.7)
                toPriceTextField.borderColor = UIColor.red.withAlphaComponent(0.7)
                showAlert(withTitle: .Missing, text: "يجب ان يكون سعر البداية اقل من سعر النهاية")
            }

        }
        
        return true
    }
    
    func getCategoriesData(isRent : Bool)
    {
        let screenBound_width = advancedSearchView.frame.size.width
        if let _ = segmentedControl {
            segmentedControl.removeFromSuperview()
        }
        
        segmentedControl = ScrollableSegmentedControl(frame: CGRect(x: 0, y: sectionSegment.frame.origin.y + sectionSegment.frame.size.height + 10, width: screenBound_width , height: 45))
        
        if isRent == true {
            if let _categories = DB_Categories.callCategories(byType: .isRent) {
                categories = _categories
            }
        }else{
            if let _categories = DB_Categories.callCategories(byType: .isSale) {
                categories = _categories
            }
        }
        
        if categories.count > 1 {
            segmentedControl.segmentStyle = .textOnly
            segmentedControl.underlineSelected = true
            segmentedControl.tintColor = UIColor.segmentColor()
            segmentedControl.fixedSegmentWidth = true
            
            segmentedControl.addTarget(self, action: #selector(AdsListVC.segmentSelected(sender:)), for: .valueChanged)
            
            self.segmentedControl.insertSegment(withTitle: "الكل", at: 0)
            for i in 0 ..< self.categories.count  {
                let item = self.categories[i]
                print(item.name ?? "")
                self.segmentedControl.insertSegment(withTitle: item.name ?? "", at: i + 1)
            }
            
            self.segmentedControl.selectedSegmentIndex = 0
            
            advancedSearchView.addSubview(segmentedControl)
        }
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        if (sender.selectedSegmentIndex  == 0) { // self.categories.count)
            //intCat = 0
        }else{
            let cat = self.categories[sender.selectedSegmentIndex - 1]
           // intCat = Int(cat.id)
        }
    }
    
    
    @IBAction func goBackAction() {
        self.leftAction()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectProvinceAdvancedSearchSB"{
            if let navPlace = segue.destination as? SelectAddressViewController {
                navPlace.provincesId = 0
                navPlace.delegate = self
            }
        }else if segue.identifier == "selectAreaAdvancedSearchSB"{
            if let navPlace = segue.destination as? SelectAddressViewController {
                print("provincesId \(selectedProvince?.entryID ?? 0)")
                navPlace.provincesId = selectedProvince?.entryID ?? 0
                navPlace.delegate = self
            }
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
