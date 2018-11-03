//
//  Passenger.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/30/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class Passenger: Codable {
    let id: String
    var firstName: String?
    var lastName: String?
    var gender: Gender = .Mr
    var passport: String?
    var email: String?
    var hasCheckedBaggage: Bool = false
    var hasPriority: Bool = false
    
    init() {
        id = generateId()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, gender, passport, email, hasCheckedBaggage, hasPriority
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        gender = try container.decode(Gender.self, forKey: .gender)
        passport = try container.decode(String.self, forKey: .passport)
        email = try container.decode(String.self, forKey: .email)
        hasCheckedBaggage = try container.decode(Bool.self, forKey: .hasCheckedBaggage)
        hasPriority = try container.decode(Bool.self, forKey: .hasPriority)
    }
}

enum Gender: String, Codable {
    case Mr, Ms
}
