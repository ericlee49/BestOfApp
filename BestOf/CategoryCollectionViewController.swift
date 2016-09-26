//
//  ViewController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-08-23.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit
import Firebase



// MARK: MODEL
struct Categories {
    var name: String?
    var imageURL: String?
    var establishmentURLs: [String]?
}




// MARK: CONTROLLER
class CategoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var categoriesArray = [Categories]()
    
    
    let backItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Back"
        return barButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "BestOf Vancouver"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.registerClass(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        
        collectionView?.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        
        createCategories()
        
        createNavigationBarSettingsButton()
        
        // FIREBASE SETUP
//        let ref = FIRDatabase.database().reference()
//        ref.updateChildValues(["someValue": 1231231])
        
    }
    
    
    func createCategories() {
        
        let coffee = Categories(name: "Coffee", imageURL: "coffee", establishmentURLs: [])
        
        let ramen = Categories(name: "Ramen", imageURL: "ramen", establishmentURLs: [])
        
        let iceCream = Categories(name: "Ice Cream", imageURL: "icecream", establishmentURLs: [])
        
        categoriesArray += [coffee, ramen, iceCream]
    }
    
    // MARK: CollectionView Data source, Delegate Protocols
    
    let customCellIdentifier = "customCellIdentifier"
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCellWithReuseIdentifier(customCellIdentifier, forIndexPath: indexPath) as! CategoryCollectionViewCell
        customCell.nameLabel.text = categoriesArray[indexPath.item].name
        customCell.categoryImageView.image = UIImage(named: categoriesArray[indexPath.item].imageURL!)
        return customCell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let tableViewController = EstablishmentsInCategoryTableViewController()
        navigationController?.pushViewController(tableViewController, animated: true)
        
        
        
    }
    
    func setUpEstablishments() -> [Establishment]{
        
        let jinya = Establishment(name: "Jinya", inCategory: "ramen")
        let applause = Establishment(name: "Applause Sushi", inCategory: "ramen")
        
        return [jinya, applause]
        
    }
    
    
    // MARK: CollectionView Spacing & Sizing
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 5 , height: collectionView.frame.width/2 - 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    
    
    
    // MARK: Settings Pushed on Navigation Controller
    

    
    func createNavigationBarSettingsButton() {
        
        let settingsButton = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(showSettingsView))
        navigationItem.rightBarButtonItem = settingsButton
        settingsButton.tintColor = UIColor.lightGrayColor()
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
    
    func showRequestController(setting: Setting) {

//        let tempController = UIViewController()
//        tempController.view.backgroundColor = UIColor.whiteColor()
//        tempController.navigationItem.title = setting.name.rawValue
//        navigationController?.pushViewController(tempController, animated: true)
        navigationItem.backBarButtonItem = self.backItem
        let categoryRequestViewController  = CategoryRequestViewController()
        navigationController?.pushViewController(categoryRequestViewController, animated: true)
        
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





