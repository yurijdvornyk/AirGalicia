//
//  ScheduleData.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation
import CoreData

class ScheduleData: NSManagedObject {
    @NSManaged var from: String?
    @NSManaged var to: String?
    @NSManaged var plane: String?
    @NSManaged var basicPrice: Double
    @NSManaged var schedule: [TimetableData]?
}
