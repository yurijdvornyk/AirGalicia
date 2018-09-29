//
//  Timetable.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/28/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class Timetable: NSObject, Decodable {
    let day: Int
    let departureTime: String
    let arrivalTime: String
    
    private enum CodingKeys: Int, CodingKey, CaseIterable {
        case day, time
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        day = try container.decode(Int.self, forKey: .day)
        let timeArr = try container.decode([String].self, forKey: .time)
        departureTime = timeArr[0]
        arrivalTime = timeArr[1]
    }
}
