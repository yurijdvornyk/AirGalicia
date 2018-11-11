//
//  ScheduleTime.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 11/3/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation

class ScheduleTime: NSObject, Codable {
    var hours: Int
    var minutes: Int
    
    public override var description: String {
        let hoursString = hours < 10 ? "0" + String(hours) : String(hours)
        let minutesString = minutes < 10 ? "0" + String(minutes) : String(minutes)
        return "\(hoursString):\(minutesString)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case hours, minutes
    }
    
    override convenience init() {
        self.init(0, 0)
    }
    
    init(timeString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let date = formatter.date(from: timeString)
        self.hours = Calendar.current.component(.hour, from: date!)
        self.minutes = Calendar.current.component(.minute, from: date!)
    }
    
    init(_ hours: Int, _ minutes: Int) {
        self.hours = hours
        self.minutes = minutes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hours = try container.decode(Int.self, forKey: .hours)
        minutes = try container.decode(Int.self, forKey: .minutes)
    }
}
