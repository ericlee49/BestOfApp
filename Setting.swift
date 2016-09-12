//
//  Setting.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-11.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
