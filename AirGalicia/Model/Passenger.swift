//
//  Passenger.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/30/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class Passenger {
    let id: String
    var firstName: String?
    var lastName: String?
    var gender: Gender?
    var passport: String?
    var email: String?
    
    init() {
        id = generateId()
    }
}

enum Gender {
    case Mr, Ms
}
