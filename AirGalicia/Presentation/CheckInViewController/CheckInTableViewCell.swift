//
//  CheckInTableViewCell.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 11/10/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class CheckInTableViewCell: UITableViewCell, PassengerSeatDelegate {

    @IBOutlet private weak var passengerLabel: UILabel!
    @IBOutlet private weak var selectSeatButton: UIButton!
    
    private var trip: Trip?
    private var passenger: Passenger?
    private var plane: Plane?
    private var seat: String?
    private var delegate: PassengerSeatDelegate?
    
    func configureWith(trip: Trip, passenger: Passenger, delegate: PassengerSeatDelegate?) {
        self.trip = trip
        self.passenger = passenger
        passengerLabel.text = passenger.shortInfo
        selectSeatButton.isEnabled = passenger.hasPriority
        self.delegate = delegate
    }

    @IBAction func onSelectSeatTapped(_ sender: UIButton) {
        // https://stackoverflow.com/questions/44701199/multiple-columns-in-uipickerview
        if passenger != nil {
            onSelectPassengerSeat(passenger: passenger!, delegate: self)
        }
    }
    
    func onSelectPassengerSeat(passenger: Passenger,  delegate: PassengerSeatDelegate) {
        if self.delegate != nil {
            self.delegate?.onSelectPassengerSeat(passenger: passenger, delegate: self)
        }
    }
    
    func onSeatSelected(_ seat: String) {
        self.seat = seat
        selectSeatButton.setTitle(seat, for: .normal)
    }
}

protocol BoardingPassDelegate {
    func onBoardingPassCreated(_ boardingPass: BoardingPass)
}
