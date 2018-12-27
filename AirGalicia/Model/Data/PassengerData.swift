//
//  PassengerData.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation
import CoreData

class PassengerData: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var gender: String
    @NSManaged var passport: String?
    @NSManaged var email: String?
    @NSManaged var hasCheckedBaggage: Bool
    @NSManaged var hasPriority: Bool
}
