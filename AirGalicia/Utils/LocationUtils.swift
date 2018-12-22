//
//  LocationUtils.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/21/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation
import CoreLocation

func location(ofAirport airport: Airport) -> CLLocation {
    let coordinates = airport.location.split(separator: ",")
    let latitude = Double(coordinates[0])
    let longitude = Double(coordinates[1])
    return CLLocation(latitude: CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!))
}

func distance(from initialLocation: CLLocation, toAirport airport: Airport) -> Double {
    return location(ofAirport: airport).distance(from: initialLocation)
}
