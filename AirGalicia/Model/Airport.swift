//
//  Airport.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class Airport: Codable {
    
    let code: String
    let city: String
    let country: String
    let name: String
    let location: String
    let planes: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case code, city, country, name, location, planes
    }
    
    init(code: String, city: String, country: String, name: String, location: String, planes: [String]?) {
        self.code = code
        self.city = city
        self.country = country
        self.name = name
        self.location = location
        self.planes = planes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        city = try container.decode(String.self, forKey: .city)
        country = try container.decode(String.self, forKey: .country)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(String.self, forKey: .location)
        planes = try container.decode([String].self, forKey: .planes)
    }
}
