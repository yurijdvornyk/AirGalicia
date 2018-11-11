//
//  Plane.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 11/10/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation

class Plane: Codable {
    var id: String!
    var model: String!
    var rows: Int!
    var seatsInRow: [String]
    
    private enum CodingKeys: String, CodingKey {
        case id, model, rows, seatsInRow
    }
    
    var rowList: [String] {
        var result: [String] = []
        for i in 1...rows {
            result.append(String(i))
        }
        return result
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        model = try container.decode(String.self, forKey: .model)
        rows = try container.decode(Int.self, forKey: .rows)
        seatsInRow = try container.decode([String].self, forKey: .seatsInRow)
    }
}
