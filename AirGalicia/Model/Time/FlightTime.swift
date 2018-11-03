//
//  FlightTime.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 11/3/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation

class FlightTime: NSObject, Codable {
    var departure: ScheduleTime
    var arrival: ScheduleTime
    
    public override var description: String {
        return "\(departure)-\(arrival)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case departure, arrival
    }
    
    override convenience init() {
        self.init(ScheduleTime(0, 0), ScheduleTime(0, 0))
    }
    
    init(_ departure: ScheduleTime, _ arrival: ScheduleTime) {
        self.departure = departure
        self.arrival = arrival
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        departure = try container.decode(ScheduleTime.self, forKey: .departure)
        arrival = try container.decode(ScheduleTime.self, forKey: .arrival)
    }
}
