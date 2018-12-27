//
//  AirportData.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation
import CoreData

class AirportData: NSManagedObject {
    
    @NSManaged var code: String?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var name: String?
    @NSManaged var location: String?
    @NSManaged var planes: [String]?
}
