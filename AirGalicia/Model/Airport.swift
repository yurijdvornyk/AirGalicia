//
//  Airport.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation

struct Airport: Decodable {
    let code: String
    let city: String
    let country: String
    let name: String
    let planes: [String]?
}
