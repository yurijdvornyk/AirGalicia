//
//  TripData.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation
import CoreData

class TripData: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var origin: AirportData?
    @NSManaged var destination: AirportData?
    @NSManaged var flight: ScheduleData?
    @NSManaged var outDate: Date?
    @NSManaged var outTime: FlightTimeData?
    @NSManaged var returnDate: Date?
    @NSManaged var returnTime: FlightTimeData?
    @NSManaged var outPrice: Double
    @NSManaged var returnPrice: Double
    @NSManaged var passengers: [PassengerData]?
    @NSManaged var outBoardingPasses: [BoardingPassData]?
    @NSManaged var returnBoardingPasses: [BoardingPassData]?
}
