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
    var email: String?
    var phoneNumber: String?
    
    init() {
        id = generateId()
    }
}
