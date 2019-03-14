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
    var countries = [Countries]()
    
    weak var delegate: ChooseCountryDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    
    func configureView(){
        title = "قائمة الدول"
        self.setBack()
        AppUtils.ShowLoading()
        getRequiredAds()
        
        tableView.register(UINib(nibName: "ChooseCountryCell", bundle: nil), forCellReuseIdentifier: "ChooseCountryCell")
    }
    
    
    func getRequiredAds() {
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
        _ = self.navigationController?.popViewController(animated: true)
    }
}
