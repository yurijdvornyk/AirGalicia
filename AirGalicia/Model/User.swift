//
//  User.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/25/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class User {
    var id: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var gender: Gender = .Mr
    var passport: String?
    var phoneNumber: String?
    var paymentInfo: PaymentInfo?
    var bookiongs: [Trip]?
    
    init() {
        id = generateId()
    }
}
