//
//  File.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation
import CoreData

class BoardingPassData: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var boardingPassId: String?
    @NSManaged var fullName: String?
    @NSManaged var passport: String?
    @NSManaged var flightDateTime: String?
    @NSManaged var seat: String?
    @NSManaged var origin: String?
    @NSManaged var destination: String?
    @NSManaged var qrCodeBase64Image: String?
}
