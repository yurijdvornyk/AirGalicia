//
//  Reservation.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/30/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class Trip: Codable {
    var id: String
    var origin: Airport!
    var destination: Airport!
    var flight: Schedule!
    var outDate: Date!
    var outTime: FlightTime?
    var returnDate: Date!
    var returnTime: FlightTime?
    var outPrice: Double!
    var returnPrice: Double!
    var passengers: [Passenger]!
    var outBoardingPasses: [BoardingPass]?
    var returnBoardingPasses: [BoardingPass]?
    
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
    
    var hasPassengerWithPriority: Bool {
        for passenger in passengers {
            if passenger.hasPriority {
                return true
            }
        }
        return false
    }
    
    init() {
        id = generateId()
        passengers = [Passenger]()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, origin, destination, flight, outDate, outTime, returnDate, returnTime, outPrice, returnPrice, passengers, outBoardingPasses, returnBoardingPasses
    }
    
    required init(from decoder: Decoder) throws {
        passengers = [Passenger]()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        origin = try container.decode(Airport?.self, forKey: .origin)
        destination = try container.decode(Airport?.self, forKey: .destination)
        flight = try container.decode(Schedule?.self, forKey: .flight)
        outDate = try container.decode(Date?.self, forKey: .outDate)
        outTime = try container.decode(FlightTime?.self, forKey: .outTime)
        returnDate = try container.decode(Date?.self, forKey: .returnDate)
        returnTime = try container.decode(FlightTime?.self, forKey: .returnTime)
        outPrice = try container.decode(Double?.self, forKey: .outPrice)
        returnPrice = try container.decode(Double?.self, forKey: .returnPrice)
        let passengersArray = try container.decode([Passenger]?.self, forKey: .passengers)
        if passengersArray != nil {
            passengers = passengersArray
        }
        outBoardingPasses = try container.decode([BoardingPass]?.self, forKey: .outBoardingPasses)
        returnBoardingPasses = try container.decode([BoardingPass]?.self, forKey: .returnBoardingPasses)
    }
    
    func isOutCheckInAvailable(_ date: Date) -> Bool {
        return isCheckInAvailable(date: date, flightDate: outDate)
    }
    
    func isReturnCheckInAvailable(_ date: Date) -> Bool {
        return isCheckInAvailable(date: date, flightDate: returnDate)
    }
    
    private func isCheckInAvailable(date: Date, flightDate: Date) -> Bool {
        return Calendar.current.dateComponents([.day], from: date, to: flightDate).day! <= 2
    }
}
