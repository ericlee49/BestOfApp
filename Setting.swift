//
//  Setting.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-11.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: SettingType
    let imageName: String
    
    init(name: SettingType, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
    
    enum SettingType: String {
        case Login = "Login"
        case CategoryRequest = "Request a Category"
        case EstablishmentRequest = "Request an Establishment"
        case Cancel = "Cancel"
    }
}
