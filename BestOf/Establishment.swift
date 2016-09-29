//
//  EstablishmentCollectionController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-08-24.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit



class Establishment: NSObject {
    
    var name: String?
    var likes = 0
    var dislikes = 0
    var priceRange: String?
    
    
    
    init(name: String, priceRange: String) {
        self.name = name
        self.priceRange = priceRange
    }
}



