//
//  BoardingPass.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/30/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class BoardingPass: Codable {
    let id: String
    var passenger: Passenger?
    var seat: String?
    
    init() {
        id = generateId()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, passenger, seat
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        passenger = try container.decode(Passenger.self, forKey: .passenger)
        seat = try container.decode(String.self, forKey: .seat)
    }
}
