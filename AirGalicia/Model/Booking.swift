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
    var origin: Airport?
    var destination: Airport?
    var flight: Schedule?
    var startDate: Date?
    var endDate: Date?
    var price: Double?
    var Passengers: [Passenger]?
    var boardingPass: BoardingPass?
    
    init() {
        id = generateId()
    }
}
