//
//  ChooseAddressViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/6/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

protocol ChooseAddressDelegate {
    func setAddress(with area:AreasData, fullAddress : String)
}

class ChooseAddressViewController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ChooseAddressDelegate? = nil
    var isProvinces = true
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
        title = "اختر المحافظة"
        self.setBack()
        tableView.register(UINib(nibName: "ChooseAddressCell", bundle: nil), forCellReuseIdentifier: "ChooseAddressCell")

        getProvincesData()
    }
    
    override func setBack(){
        let buttonImage = #imageLiteral(resourceName: "back")
        let button = UIButton(type: .system)
        button.setImage(buttonImage, for: .normal)
        // button.backgroundColor = UIColor.red
        button.tintColor = UIColor.gray
        button.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc override func backAction() {
        if isProvinces == true {
            _ = navigationController?.popViewController(animated: true)
        }else{
            isProvinces = true
            self.animatTableViewRight()
        }
        
    }
    
    func getProvincesData(){
        if let _provinces = DB_Provinces.callProvinces(){
            provinces = _provinces
        }
    }
    
    func getAreasData(provId : Int32){
        if let _areas = DB_Areas.callAreas(provinceID: provId){
            areas = _areas
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


extension ChooseAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isProvinces == true {
            return provinces.count
        }else{
            return areas.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ChooseAddressCell {
            if isProvinces == true {
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
        if isProvinces == true{
            objProvince = provinces[indexPath.row]
            isProvinces = false
            
            self.title = objProvince.name ?? ""
            getAreasData(provId: objProvince.entryID)
            
            self.animatTableViewLeft()
        }else{
            objArea = areas[indexPath.row]
            
            if let _delegate = delegate {
                _delegate.setAddress(with: objArea, fullAddress: "\(objProvince.name ?? "") - \(objArea.name ?? "")")
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
}
