//
//  Reservation.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/30/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class Booking {
    let id: String
    var origin: Airport!
    var destination: Airport!
    var flight: Schedule!
    var outDate: Date!
    var outTime: ((Int, Int), (Int, Int))?
    var returnDate: Date!
    var returnTime: ((Int, Int), (Int, Int))?
    var outPrice: Double!
    var returnPrice: Double!
    var passengers: [Passenger]!
    var boardingPasses: [BoardingPass]!
    
    var singlePrice: Double {
        var result = 0.0
        if outPrice != nil {
            result += outPrice
        }
        if returnPrice != nil {
            result += returnPrice
        }
        return result
    }
    
    var totalPrice: Double {
        let passengersPrice = singlePrice * Double(passengers.count)
        
        let priorityPrice = Double(passengers.filter({
            return $0.hasPriority
        }).count) * PRIORITY_BOARDING_PRICE
        
        let baggagePrice = Double(passengers.filter({
            return $0.hasCheckedBaggage
        }).count) * CHECKED_BAGGAGE_PRICE
        
        return passengersPrice + priorityPrice + baggagePrice
    }
    
    init() {
        id = generateId()
        passengers = [Passenger]()
    }
}
