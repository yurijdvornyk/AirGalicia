//
//  BoardingPass.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/30/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class BoardingPass {
    let id: String
    var passenger: Passenger?
    var seat: String?
    
    init() {
        id = generateId()
    }
}
