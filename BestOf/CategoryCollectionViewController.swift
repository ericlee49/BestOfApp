//
//  ViewController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-08-23.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit
import Firebase


// MARK: CONTROLLER
class CategoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var categoryArray = [Category]()
    
    var establishmentsInCategory = [String]()
    
    
    let backItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Back"
        return barButton
    }()
    
    let noTextBackItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = ""
        return barButton
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 85, height: 85))
        indicator.backgroundColor = UIColor.darkGray
        indicator.layer.cornerRadius = 8
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "BestOf Vancouver"
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        
        //collectionView?.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        
        createNavigationBarSettingsButton()
        
        loadCategories()
        
        setupActivityIndicator()
    }
    
    // MARK: SETUP, LOAD CATEROGRIES
    
    
    func loadCategories(){
        
        let categoryDatabaseRef = FIRDatabase.database().reference().child("categories")
        

        
        categoryDatabaseRef.observe(.childAdded, with: { (snapshot) in
            
            if let categoryDictionary = snapshot.value as? [String: AnyObject] {
                    
                    let name = categoryDictionary["name"] as! String
                    let imageURL = categoryDictionary["imageURL"] as! String
                    let establishments = categoryDictionary["establishments"] as! [String: AnyObject]
                    var iconImage: UIImage = UIImage(named: "coffee")!
                    if let url = URL(string: categoryDictionary["imageURL"] as! String) {
                        if let data = NSData(contentsOf: url){
                            iconImage = UIImage(data: data as Data)!
                        }
                    }
                    
                    let category = Category(name: name, imageURL: imageURL, imageIcon: iconImage, establishments: establishments)
                    self.categoryArray.append(category)

                    
                    
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView?.reloadData()
                    }
                
            }
                
            
        })
        
    }
    
    // MARK: CollectionView Data source, Delegate Protocols
    
    let customCellIdentifier = "customCellIdentifier"
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! CategoryCollectionViewCell
        customCell.activityIndicator.startAnimating()
        
        let category = categoryArray[indexPath.item]
        
        //customCell.nameLabel.text = categoryArray[(indexPath as NSIndexPath).item].name
        customCell.nameLabel.text = category.name
        
//        if let categoryImageURL = categoryArray[(indexPath as NSIndexPath).item].imageURL {
//            let url = URL(string: categoryImageURL)
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                if error != nil {
//                    print(error)
//                    return
//                }
//                // got the image if we are here
//                DispatchQueue.main.async(execute: {
//                    customCell.categoryImageView.image = UIImage(data: data!)
//                    self.activityIndicator.stopAnimating()
//                    customCell.activityIndicator.stopAnimating()
//                })
//                
//                
//                
//            }).resume()
//        }
        
        customCell.categoryImageView.image = category.imageIcon
        customCell.activityIndicator.stopAnimating()
        self.activityIndicator.stopAnimating()
        
        return customCell
    }
    

    
    // MARK: CollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // empty out establishmentsInCategory Array
        self.establishmentsInCategory.removeAll()
        
        // load establishment IDs into array
        for (_, establishmentID) in categoryArray[(indexPath as NSIndexPath).item].establishments! {
            self.establishmentsInCategory.append(establishmentID as! String)
        }
        
        let categoryName = categoryArray[(indexPath as NSIndexPath).item].name
        navigationItem.backBarButtonItem = self.backItem
        
        let tableViewController = EstablishmentsInCategoryTableViewController()
        tableViewController.establishmentIDs = self.establishmentsInCategory
        tableViewController.categoryName = categoryName
        
        navigationController?.pushViewController(tableViewController, animated: true)
        
        
    }
    
    // Sizing & Spacing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 5 , height: collectionView.frame.width/2 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    
    
    
    // MARK: Settings Pushed on Navigation Controller
    

    
    func createNavigationBarSettingsButton() {
        
//        let settingsButton = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showSettingsView))
           let settingsButton = UIBarButtonItem(image: UIImage.init(named: "settings"), style: .plain, target: self, action: #selector(showSettingsView))
        navigationItem.rightBarButtonItem = settingsButton
     
        //settingsButton.tintColor = UIColor.lightGray
    }
    
    lazy var settings: SettingsCollectionViewLaucher = {
        let launcher = SettingsCollectionViewLaucher()
        launcher.categoryCollectionViewController = self
        return launcher
    }()
    
    func showSettingsView() {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            print("made it here")
            //settings.loginLogOutSetting = Setting(name: .Logout, imageName: "account")
            settings.settings![0] = Setting(name: .Logout, imageName: "account")
            settings.collectionView.reloadData()
        } else {
            settings.settings![0] = Setting(name: .Login, imageName: "account")
            settings.collectionView.reloadData()
        }
        
        settings.showSettings()
        
    }
    
    func showRequestController(_ setting: Setting) {
        
        if setting.name == Setting.SettingType.CategoryRequest {
            navigationItem.backBarButtonItem = self.backItem
            let categoryRequestViewController  = CategoryRequestViewController()
            navigationController?.pushViewController(categoryRequestViewController, animated: true)
            
        } else if setting.name == Setting.SettingType.EstablishmentRequest {
            var categoryNames = [String]()
            
            for category in self.categoryArray {
                if let name = category.name {
                    categoryNames.append(name)
                }
            }
            
            navigationItem.backBarButtonItem = self.noTextBackItem
            let establishmentRequestViewController = EstablishmentRequestController()
            establishmentRequestViewController.categoryNames = categoryNames
            navigationController?.pushViewController(establishmentRequestViewController, animated: true)
        } else {
            return
        }
        
    }
    
    
    // MARK: Login In Controller Pushed on Navigation Controller
    
    func showLoginViewController() {
        
        navigationItem.backBarButtonItem = self.backItem
        
        let loginViewController = LoginViewController()
        //presentViewController(loginViewController, animated: true, completion: nil)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    // MARK: Handle Logout
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
            
        }catch let logoutError {
            print(logoutError)
        }
    }
    

}





