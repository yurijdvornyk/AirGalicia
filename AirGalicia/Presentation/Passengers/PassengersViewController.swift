//
//  PassengersViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/19/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class PassengersViewController: BaseViewController, BookingUpdateDelegate {
    
    let BAGGAGE_PRICE = 25.0
    let PRIORITY_PRICE = 10.0
    
    @IBOutlet private weak var passengersTableView: UITableView!
    
    var booking: Booking!
    var delegate: BookingUpdateDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        updatePassangers()
        delegate?.onBookingUpdated(booking: booking)
        dismiss(animated: true, completion: nil)
    }
    
    func onBookingUpdated(booking: Booking?) {
        self.booking = booking
    }
    
    func updatePassangers() {
        for i in 0...booking.passengers.count - 1 {
            let cell = passengersTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! PassengerTableViewCell
            booking.passengers[i] = cell.saveData()
        }
    }
}

extension PassengersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booking.passengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PassengerTableViewCell
        if indexPath.row < booking.passengers.count {
            cell.configureWith(passenger: booking.passengers[indexPath.row], passengerPosition: indexPath.row + 1, baggagePrice: BAGGAGE_PRICE, priorityPrice: PRIORITY_PRICE, bookingUpdateDelegate: self)
        }
        return cell
    }
}
