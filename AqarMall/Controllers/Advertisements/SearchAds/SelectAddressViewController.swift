//
//  SelectAddressViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/28/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

protocol SelectAddressDelegate : class {
    func setProvince(with province:Provinces)
    func setArea(with area:Areas)
}

class SelectAddressViewController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SelectAddressDelegate? = nil
    var provincesId : Int32 = 0
    var provinces = [Provinces]()
    var areas = [Areas]()
    
    var objProvince : Provinces? = nil
    var objArea : Areas? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView(){
        self.setBack(isDismiss: true)
        tableView.register(UINib(nibName: "ChooseAddressCell", bundle: nil), forCellReuseIdentifier: "ChooseAddressCell")
        print("provincesId \(provincesId)")
        if provincesId == 0 {
            getProvincesData()
            title = "اختر المحافظة"
        }else{
            title = "اختر المنطقة"
            getAreasData(provId: provincesId)
        }
    }
    
    func getProvincesData(){
        if let _provincesData = DB_Provinces.callProvinces(){
            if let _province = Provinces(_entryID: 0, _name: "جميع المحافظات"){
                provinces.append(_province)
            }
            for obj in _provincesData {
                if let _province = Provinces(_entryID: obj.entryID, _name: obj.name ?? ""){
                    provinces.append(_province)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func getAreasData(provId : Int32){
        if let _areas = DB_Areas.callAreas(provinceID: provId){
            if let _area = Areas(_entryID: 0, _name: "جميع المناطق"){
                areas.append(_area)
            }
            
            for obj in _areas {
                if let _area = Areas(_entryID: obj.entryID, _name: obj.name ?? ""){
                    areas.append(_area)
                }
            }
            self.tableView.reloadData()
        }
    }
}

extension SelectAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if provincesId == 0 {
            return provinces.count
        }else{
            return areas.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ChooseAddressCell {
            if provincesId == 0 {
                cell.update(with: provinces[indexPath.row].name)
            }else{
                cell.update(with: areas[indexPath.row].name)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ChooseAddressCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if provincesId == 0{
            objProvince = provinces[indexPath.row]
            
            if let _delegate = delegate, let _objProvince = objProvince{
                _delegate.setProvince(with: _objProvince)
            }
            self.leftAction()
        }else{
            objArea = areas[indexPath.row]
            
            if let _delegate = delegate, let _objArea = objArea {
                _delegate.setArea(with: _objArea)
            }
            self.leftAction()
        }
        
    }
}
