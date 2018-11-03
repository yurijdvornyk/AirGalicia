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

func formatTripDestinations(_ trip: Booking) -> String {
    var result = "\(trip.origin.city), \(trip.origin.country) - \(trip.destination.city), \(trip.destination.country)"
    if trip.returnDate != nil {
        result += " - \(trip.origin.city), \(trip.origin.country)"
    }
    return result
}

func formatTripDetails(_ trip: Booking) -> String {
    var result = formatFlightDate(date: trip.outDate)
    if trip.returnDate != nil {
        result += " - \(formatFlightDate(date: trip.returnDate))"
    }
    result += ", \(trip.passengers.count) "
    result += trip.passengers.count == 1 ? "passenger" : "passengers"
    return result
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

func formatTotalPrice(_ totalPrice: Double?) -> String {
    if totalPrice == nil {
        return ""
    } else {
        return "\(String(totalPrice!)) €"
    }
}
