//
//  PlaneData.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/27/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation
import CoreData

class PlaneData: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var model: String?
    @NSManaged var rows: Int
    @NSManaged var seatsInRow: [String]?
}
