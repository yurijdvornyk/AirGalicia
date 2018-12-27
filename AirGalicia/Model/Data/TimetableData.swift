//
//  TimetableData.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation
import CoreData

class TimetableData: NSManagedObject {
    @NSManaged var day: Int
    @NSManaged var time: [String]?
}
