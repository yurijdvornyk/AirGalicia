//
//  FlightTimeData.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation
import CoreData

class FlightTimeData: NSManagedObject {
    @NSManaged var departureHours: Int
    @NSManaged var departureMinutes: Int
    @NSManaged var arrivalHours: Int
    @NSManaged var arrivalMinutes: Int
}
