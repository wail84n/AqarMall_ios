//
//  AdvFilterViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 4/3/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

protocol AdvFilterDelegate : class {
    func advFilter(with orderBy : Int16, orderType : String)
}

enum AdvFilterOptions {
    case HigherPrice
    case lowerPrices
    case biggerSize
    case smallestSize
    case newAdv
    case oldAdv
    case mostViews
    case lowerViews
}

class AdvFilterViewController: ViewController {
    var delegate: AdvFilterDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func HigherPrice(_ sender: Any) {
        implementFilterAction(order: .HigherPrice)
    }
    
    @IBAction func lowerPrices(_ sender: Any) {
        implementFilterAction(order: .lowerPrices)
    }
    
    @IBAction func biggerSize(_ sender: Any) {
        implementFilterAction(order: .biggerSize)
    }
    
    @IBAction func smallestSize(_ sender: Any) {
        implementFilterAction(order: .smallestSize)
    }
    
    @IBAction func newAdv(_ sender: Any) {
        implementFilterAction(order: .newAdv)
    }
    
    @IBAction func oldAdv(_ sender: Any) {
        implementFilterAction(order: .oldAdv)
    }
    
    @IBAction func mostViews(_ sender: Any) {
        implementFilterAction(order: .mostViews)
    }
    
    @IBAction func lowerViews(_ sender: Any) {
        implementFilterAction(order: .lowerViews)
    }
    
    func implementFilterAction(order : AdvFilterOptions){
        
        if let _delegate = delegate{
            switch order {
            case .lowerPrices:
                _delegate.advFilter(with: 1, orderType: "Asc")
            case .HigherPrice:
                _delegate.advFilter(with: 1, orderType: "Dec")
            case .smallestSize:
                _delegate.advFilter(with: 2, orderType: "Asc")
            case .biggerSize:
                _delegate.advFilter(with: 2, orderType: "Dec")
            case .newAdv:
                _delegate.advFilter(with: 3, orderType: "Dec")
            case .oldAdv:
                _delegate.advFilter(with: 3, orderType: "Asc")
            case .mostViews:
                _delegate.advFilter(with: 4, orderType: "Dec")
            case .lowerViews:
                _delegate.advFilter(with: 3, orderType: "Asc")
            }
        }
        
// 1 = Price 2 = Size 3 = Entry date 4 = Most viewed
        //order_type: (Asc,Dec).
    }
    
    @IBAction func goBackAction() {
        self.leftAction()
    }
}
