//
//  Timetable.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/28/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class Timetable: Codable {
    let day: Int
    let time: [String]?
    var departureTime: ScheduleTime? {
        return time != nil && (time?.count)! > 0 ? ScheduleTime(timeString: time![0]) : nil
    }
    var arrivalTime: ScheduleTime? {
        return time != nil && (time?.count)! == 2 ? ScheduleTime(timeString: time![1]) : nil
    }
    
    private enum CodingKeys: Int, CodingKey, CaseIterable {
        case day, time
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        day = try container.decode(Int.self, forKey: .day)
        time = try container.decode([String].self, forKey: .time)
    }
}
