//
//  SelectAddressViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/28/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit


protocol SelectAddressDelegate : class {
    func setArea(with area:AreasData)
    func setProvince(with province:ProvincesData)
}

class SelectAddressViewController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SelectAddressDelegate? = nil
    var provincesId : Int32 = 0
    var provinces = [ProvincesData]()
    var areas = [AreasData]()
    
    var objProvince = ProvincesData()
    var objArea = AreasData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureView()
    }
    
    func configureView(){
        self.setBack(isDismiss: true)
        tableView.register(UINib(nibName: "ChooseAddressCell", bundle: nil), forCellReuseIdentifier: "ChooseAddressCell")
        
        if provincesId == 0 {
            getProvincesData()
            title = "اختر المحافظة"
        }else{
            title = "اختر المنطقة"
            getAreasData(provId: provincesId)
        }
    }
    
    func getProvincesData(){
        if let _provinces = DB_Provinces.callProvinces(){
            provinces = _provinces
            
            self.tableView.reloadData()
        }
    }
    
    func getAreasData(provId : Int32){
        if let _areas = DB_Areas.callAreas(provinceID: provId){
            areas = _areas
            self.tableView.reloadData()
        }
    }
    
    
    func animatTableViewLeft() {
        UIView.animate(withDuration: 0.5, animations: {
            var frame = self.tableView.frame
            frame.origin.x = -UIScreen.main.bounds.size.width
            self.tableView.frame = frame
        },completion: { (finished: Bool) in
            
            self.tableView.reloadData()
            var frame = self.tableView.frame
            frame.origin.x = 0
            self.tableView.frame = frame
        })
    }
    
    func animatTableViewRight() {
        UIView.animate(withDuration: 0.5, animations: {
            var frame = self.tableView.frame
            frame.origin.x = UIScreen.main.bounds.size.width
            self.tableView.frame = frame
        },completion: { (finished: Bool) in
            
            self.tableView.reloadData()
            var frame = self.tableView.frame
            frame.origin.x = 0
            self.tableView.frame = frame
        })
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
                cell.update(with: provinces[indexPath.row].name ?? "")
            }else{
                cell.update(with: areas[indexPath.row].name ?? "")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ChooseAddressCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if provincesId == 0{
            objProvince = provinces[indexPath.row]
            
            if let _delegate = delegate{
                _delegate.setProvince(with: objProvince)
            }
            _ = self.navigationController?.popViewController(animated: true)
        }else{
            objArea = areas[indexPath.row]
            
            if let _delegate = delegate {
                _delegate.setArea(with: objArea)
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
}
