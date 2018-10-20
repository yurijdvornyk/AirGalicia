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
    var gender: Gender = .Mr
    var passport: String?
    var email: String?
    var hasAdditionalBaggage: Bool = false
    var hasPriority: Bool = false
    
    init() {
        id = generateId()
    }
}

enum Gender {
    case Mr, Ms
}
