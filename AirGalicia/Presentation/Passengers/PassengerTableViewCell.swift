//
//  PassengerTableViewCell.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/20/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class PassengerTableViewCell: UITableViewCell {

    @IBOutlet private weak var passengerLabel: UILabel!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var genderSwitch: UISegmentedControl!
    @IBOutlet private weak var passportTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var baggageLabel: UILabel!
    @IBOutlet private weak var baggageSwitch: UISwitch!
    @IBOutlet private weak var priorityLabel: UILabel!
    @IBOutlet private weak var prioritySwitch: UISwitch!
    
    private var passenger: Passenger!
    private var bookingUpdateDelegate: BookingUpdateDelegate?
    
    func configureWith(passenger: Passenger?, passengerPosition: Int, baggagePrice: Double, priorityPrice: Double, bookingUpdateDelegate: BookingUpdateDelegate?) {
        self.passenger = passenger
        passengerLabel.text = "Passenger #\(passengerPosition)"
        baggageLabel.text = "Additional baggage (+\(Int(baggagePrice)) €)"
        priorityLabel.text = "Priority boarding (+\(Int(priorityPrice)) €)"
        self.bookingUpdateDelegate = bookingUpdateDelegate
        showData()
    }
    
    func showData() {
        firstNameTextField.text = passenger?.firstName
        lastNameTextField.text = passenger?.lastName
        genderSwitch.selectedSegmentIndex = passenger?.gender == .Mr ? 0 : 1
        passportTextField.text = passenger?.passport
        emailTextField.text = passenger?.email
        baggageSwitch.isOn = (passenger?.hasCheckedBaggage)!
        prioritySwitch.isOn = (passenger?.hasPriority)!
    }
    
    func saveData() -> Passenger {
        passenger?.firstName = firstNameTextField.text
        passenger?.lastName = lastNameTextField.text
        passenger?.gender = genderSwitch.selectedSegmentIndex == 0 ? .Mr : .Ms
        passenger?.passport = passportTextField.text
        passenger?.email = emailTextField.text
        passenger?.hasCheckedBaggage = baggageSwitch.isOn
        passenger?.hasPriority = prioritySwitch.isOn
        return passenger
    }
}
