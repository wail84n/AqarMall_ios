//
//  AdsPackagesViewController.swift
//  AqarMall
//
//  Created by wael on 5/28/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import UIKit

class AdsPackagesViewController: ViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var packages = [AdPackages]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        // Do any additional setup after loading the view.
    }
    
    
    func configureView(){
        setBack()
        title = "الباقات المتاحة"
        
        collectionView.register(AdPackagesCell.nib, forCellWithReuseIdentifier: AdPackagesCell.identifier)
        
        AppUtils.ShowLoading()
        getAvailableAdsNumber()
    }
    
    
    func getAvailableAdsNumber(){
        APIs.shared.getAdPackages() {[weak self](result, error) in
            AppUtils.HideLoading()
            
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            if let _result = result {
                self?.packages = _result
                self?.collectionView.reloadData()
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


extension AdsPackagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // return viewModel.getCell(at: collectionView.tag).sectionType.collectionCellSize()
        let cellWidth = UIScreen.main.bounds.width - 16
        return CGSize(width: cellWidth, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "AdPackagesCell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? AdPackagesCell {
            let _package = self.packages[indexPath.row]
            cell.update(package: _package)
            //            if let category = viewModel.getCategoryChilds(index: collectionView.tag){
            //                cell.update(with: category[indexPath.row])
            //            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        //  viewModel.selectItem(section: collectionView.tag, selectedIndex: indexPath.row)
        
        //        let _viewModel = viewModel.productsListViewModel(section: collectionView.tag, selectedRow: indexPath.row)
        //        performSegue(withIdentifier: productsListSegue, sender: _viewModel)
        
        confirm(package: self.packages[indexPath.row])
        
    }
    
    func confirm(package: AdPackages)
    {
        var message = "انت بصدد شراء باقة \" \(package.name) \""
        message += "\n عند الموافقة ستقوم ادارة التطبيق بالتواصل معكم لتاكيد العملية"
        let optionMenu = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)

        let saveAction = UIAlertAction(title: "موافق", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Saved")
            
            self.doProcess(package: package)
        })

        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func doProcess(package: AdPackages){
        AppUtils.ShowLoading()
        
        guard let _userId = DB_UserInfo.getUserId() else {
            self.showAlert(withTitle: .Missing, text: "لا يوجد حساب معتمد الرجاء التسجيل")
            return
        }
        
        
        APIs.shared.postAdPackageTransactions(packageID: package.id, userID: Int(_userId)) {[weak self](result, error) in
            
            guard let self = self,
                  error == nil else {
                print(error ?? "")
                return
            }
            
            AppUtils.HideLoading()
            self.showAlert(withTitle: .Success, text: "تم ارسال طلبك وسيتكم التواصل معكم في اقرب وقت ممكن")
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//
//            }

        }


    }
}
