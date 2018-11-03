//
//  TripTableViewCell.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/28/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var destinationsLabel: UILabel!
    @IBOutlet private weak var tripDetailsLabel: UILabel!
    @IBOutlet private weak var checkInOutButton: UIButton!
    @IBOutlet private weak var checkInReturnButton: UIButton!
    
    var trip: Trip?

    func configureWith(trip: Trip) {
        self.trip = trip
        destinationsLabel.text = formatTripDestinations(trip)
        tripDetailsLabel.text = formatTripDetails(trip)
    }
}
