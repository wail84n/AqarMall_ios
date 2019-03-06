//
//  ChooseAdvCatedoryViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/3/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class ChooseAdvCatedoryViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!
    var categories = [CategoriesData]()
    var isRent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func configureView(){
        title = "اختر الفئة"
        self.setBack()
        tableView.register(UINib(nibName: "ChooseAdvCatedoryCell", bundle: nil), forCellReuseIdentifier: "ChooseAdvCatedoryCell")
        
        self.getCategoriesData()
    }
    
    func getCategoriesData()
    {
        if isRent == true {
            if let _categories = DB_Categories.callCategories(byType: .isRent) {
                categories = _categories
            }
        }else{
            if let _categories = DB_Categories.callCategories(byType: .isSale) {
                categories = _categories
            }
        }

    }
    
}

extension ChooseAdvCatedoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ChooseAdvCatedoryCell {
            cell.update(with: categories[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ChooseAdvCatedoryCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "SubmitAdv", bundle: nil).instantiateViewController(withIdentifier: "SubmitAdvFormViewController") as! SubmitAdvFormViewController
        
        
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        
        vc.category = categories[indexPath.row]
        vc.isRent = isRent
        self.navigationController?.pushViewController(vc, animated: true)
        
     //   let notification = self.arrUserNotifications[indexPath.item]
    }
}
