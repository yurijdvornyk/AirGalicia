//
//  Schedule.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/28/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

struct Schedule: Decodable {
    let from: String
    let to: String
    let plane: String
    let timetable: [Timetable]?
    
    private enum CodingKeys: String, CodingKey {
        case from, to, plane, schedule
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        from = try container.decode(String.self, forKey: .from)
        to = try container.decode(String.self, forKey: .to)
        plane = try container.decode(String.self, forKey: .plane)
        timetable = try container.decode([Timetable]?.self, forKey: .schedule)
    }
}