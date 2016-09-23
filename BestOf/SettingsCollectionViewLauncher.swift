//
//  SettingsCollectionViewController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-08.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit
import Firebase

// need dataSource since we are not a collectionViewController
class SettingsCollectionViewLaucher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout     {
    
    let cellId = "cellID"
    
    let cellHeight: CGFloat = 60
    
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //zero frame
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.whiteColor()
        return cv
    }()
    
    let loginLogOutSetting = Setting(name: .Login, imageName: "account")
    let categoryRequestSetting = Setting(name: .CategoryRequest, imageName: "request")
    let establishmentRequestSetting = Setting(name: .EstablishmentRequest, imageName: "question")
    let cancelSetting = Setting(name: .Cancel, imageName: "cancel")
    
    var settings: [Setting]?
    
    
    
    var categoryCollectionViewController: CategoryCollectionViewController?
    
    func showSettings() {
        
        if let window = UIApplication.sharedApplication().keyWindow {
            
            // black out the view that is not the collectionView
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.frame = window.frame
            
            blackView.alpha = 0
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissSettingsView)))
            
            window.addSubview(blackView)
            
            
            // Collection View setup
            let collectionViewHeight:CGFloat = cellHeight * CGFloat(settings!.count)
            let y_Position = window.frame.height - collectionViewHeight
            self.collectionView.frame = CGRectMake(0, window.frame.height, window.frame.width, collectionViewHeight)
            
            
            window.addSubview(collectionView)
            
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRectMake(0, y_Position, window.frame.width, collectionViewHeight)
                }, completion: nil  )
            
        }
        
    }
    
    func handleDismissAnimation(){
        self.blackView.alpha = 0
        
        if let window = UIApplication.sharedApplication().keyWindow {
            self.collectionView.frame = CGRectMake(0, window.frame.height, self.collectionView.frame.width, self.collectionView.frame.height)
        }
    }
    
    func handleDismissSettingsView() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
            self.handleDismissAnimation()
            }, completion: nil)
    }
    
    func handleDismissSettingsViewWithName(setting: Setting) {
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
            self.handleDismissAnimation()
        }) { (completed: Bool) in
            
            let name = setting.name
            switch name {
                
            case .Login:
                self.categoryCollectionViewController?.showLoginViewController()
            case .Logout:
                self.categoryCollectionViewController?.handleLogout()
                self.categoryCollectionViewController?.showLoginViewController()
            case .CategoryRequest, .EstablishmentRequest:
                self.categoryCollectionViewController?.showRequestController(setting)
            default:
                break
                
            }
            
        }
        
    }
    
    // Delegate and Data Source For Collection View
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let settingsArray = settings {
            return settingsArray.count
        } else{
            return 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! SettingsCell
        if let settingsArray = settings {
            cell.setting = settingsArray[indexPath.item]
        }

        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width, cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let settingsArray = settings {
            let setting = settingsArray[indexPath.item]
            handleDismissSettingsViewWithName(setting)
        }
        
        
        
    }
    
    
    override init() {
        super.init()
        
        
        
        self.settings = [loginLogOutSetting, categoryRequestSetting, establishmentRequestSetting, cancelSetting ]
        
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerClass(SettingsCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
}

