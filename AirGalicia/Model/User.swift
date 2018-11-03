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
    var passport: String?
    var dateOfBirth: Date?
    var phoneNumber: String?
    var paymentInfo: PaymentInfo?
    var bookiongs: [Trip]?
    
    init() {
        id = generateId()
    }
}
