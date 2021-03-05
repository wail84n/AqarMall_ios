//
//  ChooseCountryViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/11/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

protocol ChooseCountryDelegate : class {
    func ChooseCountry(country : Countries)
}


class ChooseCountryViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prepareCountryLoadView: UIView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    
    var countries = [Countries]()
    
    var isFromSettings = false
    weak var delegate: ChooseCountryDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    
    func configureView(){
        title = "قائمة الدول"
        prepareCountryLoadView.isHidden = true
        self.setBack()
     //   AppUtils.ShowLoading()
        getCountries()
        
        tableView.register(UINib(nibName: "ChooseCountryCell", bundle: nil), forCellReuseIdentifier: "ChooseCountryCell")
    }
    
    
    func getCountries() {
        APIs.shared.getCountries() { (result, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            if let _countries = result {
                self.countries = _countries
                self.tableView.reloadData()
            }
            
        }
    }
}

extension ChooseCountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ChooseCountryCell {
            cell.update(with: countries[indexPath.row].country)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ChooseCountryCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _delegate = delegate {
            _delegate.ChooseCountry(country: countries[indexPath.row])
        }
        
        if isFromSettings{
            AppUtils.changeSelectedCountry(country: countries[indexPath.row])
            self.reloadData()
        }else{
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func reloadData(){
        DB_Categories.deleteAll()
        DB_Provinces.deleteAll()
        DB_Areas.deleteAll()
        DB_GeneralPages.deleteAll()
        DB_Banners.deleteAll()

        AppUtils.staticProvinces.removeAll()
        AppUtils.staticAreas.removeAll()
//        static var staticProvinces = [Provinces]()
//        static var staticAreas =
            
        AppUtils.SaveData(key: .provinces_last_change, value: "0")
        AppUtils.SaveData(key: .categories_last_change, value: "0")
        AppUtils.SaveData(key: .areas_last_change, value: "0")
        AppUtils.SaveData(key: .general_pages_last_change, value: "0")
        AppUtils.SaveData(key: .banner_last_change, value: "0")
        AppUtils.SaveData(key: .sponsorLastChange, value: "0")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       // AppUtils.ShowLoading()
        prepareCountryLoadView.isHidden = false
        loaderView.startAnimating()
        appDelegate.callAPIs(reSet: true){ result in
            //AppUtils.HideLoading()
            self.prepareCountryLoadView.isHidden = true
            self.loaderView.startAnimating()
            _ = self.navigationController?.popViewController(animated: true)
            self.navigateToLoadPage()
        }

    }
    
}
