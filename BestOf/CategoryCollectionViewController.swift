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
struct Category
{
    var name: String?
    var imageURL: String?
    var establishments: [String: AnyObject]?
}




// MARK: CONTROLLER
class CategoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var categoryArray = [Category]()
    
    var establishmentsInCategory = [String]()
    
    
    let backItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Back"
        return barButton
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 85, 85))
        indicator.backgroundColor = UIColor.darkGrayColor()
        indicator.layer.cornerRadius = 8
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        activityIndicator.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        activityIndicator.startAnimating()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "BestOf Vancouver"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.registerClass(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        
        collectionView?.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        
        createNavigationBarSettingsButton()
        
        loadCategories()
        
        setupActivityIndicator()
    }
    
    // MARK: SETUP, LOAD CATEROGRIES
    
    
    func loadCategories(){
        
        let categoryDatabaseRef = FIRDatabase.database().reference().child("categories")
        

        
        categoryDatabaseRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let categoryDictionary = snapshot.value as? [String: AnyObject] {
                
                let name = categoryDictionary["name"] as! String
                let imageURL = categoryDictionary["imageURL"] as! String
                let establishments = categoryDictionary["establishments"] as! [String: AnyObject]
                
                let category = Category(name: name, imageURL: imageURL, establishments: establishments)
                
                self.categoryArray.append(category)

                self.collectionView?.reloadData()

            }
            
        })
        
    }
    
    // MARK: CollectionView Data source, Delegate Protocols
    
    let customCellIdentifier = "customCellIdentifier"
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCellWithReuseIdentifier(customCellIdentifier, forIndexPath: indexPath) as! CategoryCollectionViewCell
        customCell.activityIndicator.startAnimating()
        
        customCell.nameLabel.text = categoryArray[indexPath.item].name
        
        if let categoryImageURL = categoryArray[indexPath.item].imageURL {
            let url = NSURL(string: categoryImageURL)
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                // got the image if we are here
                dispatch_async(dispatch_get_main_queue(), {
                    customCell.categoryImageView.image = UIImage(data: data!)
                    self.activityIndicator.stopAnimating()
                    customCell.activityIndicator.stopAnimating()
                })
                
                
                
            }).resume()
        }
        
        return customCell
    }
    

    
    // MARK: CollectionView Spacing & Sizing & Delegate
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // empty out establishmentsInCategory Array
        self.establishmentsInCategory.removeAll()
        
        // load establishment IDs into array
        for (_, establishmentID) in categoryArray[indexPath.item].establishments! {
            self.establishmentsInCategory.append(establishmentID as! String)
        }
        
        let categoryName = categoryArray[indexPath.item].name
        navigationItem.backBarButtonItem = self.backItem
        
        let tableViewController = EstablishmentsInCategoryTableViewController()
        tableViewController.establishmentIDs = self.establishmentsInCategory
        tableViewController.categoryName = categoryName
        
        navigationController?.pushViewController(tableViewController, animated: true)
        
        
    }
    
    // Sizing & Spacing
    
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





