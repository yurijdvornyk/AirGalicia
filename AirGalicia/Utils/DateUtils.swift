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

func formatFlightDate(date: Date?, time: ((Int, Int), (Int, Int))) -> String {
    return "\(formatFlightDate(date: date)) \(time.0.0):\(time.0.1)-\(time.1.0):\(time.1.1)"
}

func parseFligtTime(_ time: String?) -> (Int, Int) {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    let date = formatter.date(from: time!)
    let hour = Calendar.current.component(.hour, from: date!)
    let minutes = Calendar.current.component(.minute, from: date!)
    return (hour, minutes)
}
