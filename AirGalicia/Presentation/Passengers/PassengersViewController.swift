//
//  PassengersViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/19/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class PassengersViewController: BookingPageViewController {
    
    @IBOutlet private weak var passengersTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passengersTableView.reloadData()
    }
    
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        updatePassangers()
        bookingDelegate?.goBack()
    }
    
    @IBAction func onProceedTapped(_ sender: UIBarButtonItem) {
        updatePassangers()
        bookingDelegate?.goNext()
    }
    
    func updatePassangers() {
        for i in 0...booking!.passengers.count - 1 {
            let cell = passengersTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! PassengerTableViewCell
            booking!.passengers[i] = cell.saveData()
        }
    }
}

extension PassengersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booking == nil ? 0 : booking!.passengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PassengerTableViewCell
        if indexPath.row < booking!.passengers.count {
            cell.configureWith(passenger: booking!.passengers[indexPath.row], passengerPosition: indexPath.row + 1, baggagePrice: CHECKED_BAGGAGE_PRICE, priorityPrice: PRIORITY_BOARDING_PRICE)
        }
        return cell
    }
}
