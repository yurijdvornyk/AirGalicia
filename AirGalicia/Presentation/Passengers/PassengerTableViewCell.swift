//
//  PassengerTableViewCell.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/20/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class PassengerTableViewCell: UITableViewCell {

    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var genderSwitch: UISegmentedControl!
    @IBOutlet private weak var passportTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
    private var passenger: Passenger!
    private var bookingUpdateDelegate: BookingUpdateDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(passenger: Passenger?, bookingUpdateDelegate: BookingUpdateDelegate?) {
        self.passenger = passenger
        self.bookingUpdateDelegate = bookingUpdateDelegate
        showData()
    }
    
    func showData() {
        firstNameTextField.text = passenger?.firstName
        lastNameTextField.text = passenger?.lastName
        genderSwitch.selectedSegmentIndex = passenger?.gender == .Mr ? 0 : 1
        passportTextField.text = passenger?.passport
        emailTextField.text = passenger?.email
    }
    
    func saveData() -> Passenger {
        passenger?.firstName = firstNameTextField.text
        passenger?.lastName = lastNameTextField.text
        passenger?.gender = genderSwitch.selectedSegmentIndex == 0 ? .Mr : .Ms
        passenger?.passport = passportTextField.text
        passenger?.email = emailTextField.text
        return passenger
    }
}
