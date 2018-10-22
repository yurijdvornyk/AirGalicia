//
//  StringUtils.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/21/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation

func formatAirportFullString(airport: Airport?) -> String {
    if airport == nil {
        return ""
    } else {
        return "\(airport!.city), \(airport!.country) (\(airport!.name), \(airport!.code))"
    }
}

func formatPassengers(passengers: [Passenger]?) -> String {
    if passengers == nil {
        return ""
    }
    var result = ""
    for passenger in passengers! {
        if result != "" {
            result += "\n"
        }
        let gender = passenger.gender == .Mr ? "Mr." : "Ms."
        let firstName = passenger.firstName ?? ""
        let lastName = passenger.lastName ?? ""
        let passport = passenger.passport ?? ""
        let addition = (passenger.hasCheckedBaggage ? " + Baggage " : "") +
            (passenger.hasPriority ? " + Priority" : "")
        result += "\(gender) \(firstName) \(lastName) [\(passport)]"
        if addition != "" {
            result += " | \(addition)"
        }
    }
    return result
}
