//
//  SettingsCollectionViewController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-08.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

class SettingsCollectionViewController {
    
    let blackView = UIView()
    
    func showSettings() {
        
        if let window = UIApplication.sharedApplication().keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.frame = window.frame
            
            window.addSubview(blackView)
            
            blackView.alpha = 0
            
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: { 
                    self.blackView.alpha = 1
                }, completion: nil  )
            
        }
        
    }
    
    
}
