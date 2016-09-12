//
//  SettingsCollectionViewController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-08.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

// need dataSource since we are not a collectionViewController
class SettingsCollectionViewLaucher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout     {
    
    let cellId = "cellID"
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //zero frame
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.whiteColor()
        return cv
    }()
    
    
    
    
    func showSettings() {
        
        if let window = UIApplication.sharedApplication().keyWindow {
            
            // black out the view that is not the collectionView
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.frame = window.frame
            
            blackView.alpha = 0
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissSettingsView)))
            
            window.addSubview(blackView)
            
            
            // Collection View setup
            let collectionViewHeight:CGFloat = 200
            let y_Position = window.frame.height - collectionViewHeight
            self.collectionView.frame = CGRectMake(0, window.frame.height, window.frame.width, collectionViewHeight)
            
            
            window.addSubview(collectionView)
        
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRectMake(0, y_Position, window.frame.width, collectionViewHeight)
                }, completion: nil  )
            
        }
        
    }
    
    
    func handleDismissSettingsView() {
        //print("handling dismiss")
        UIView.animateWithDuration(0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.sharedApplication().keyWindow {
                self.collectionView.frame = CGRectMake(0, window.frame.height, self.collectionView.frame.width, self.collectionView.frame.height)

            }
        }
    }
    
    // Delegate and Data Source For Collection View
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width, 50)
    }
    
    
    override init() {
        super.init()
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerClass(SettingsCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
}
