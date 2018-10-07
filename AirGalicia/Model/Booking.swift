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
    var returnDate: Date!
    var singlePrice: Double!
    var totalPrice: Double!
    var passengers: [Passenger]!
    var boardingPasses: [BoardingPass]!
    
    init() {
        id = generateId()
        passengers = [Passenger]()
    }
}
