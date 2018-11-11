//
//  DateUtils.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/21/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation

func formatFlightDate(date: Date?) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: date!)
}

func formatFlightDate(date: Date?, time: FlightTime) -> String {
    return "\(formatFlightDate(date: date)) \(time)"
}
