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
    var category: String?
    var likes = 0
    var dislikes = 0
    
    
    
    init(name: String, inCategory category: String) {
        self.name = name
        self.category = category
    }
}


enum EstablishmentCategories: String {
    case Ramen = "ramen"
    case IceCream = "iceCream"
    case Coffee = "coffee"
}
