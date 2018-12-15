//
//  ProfileDetailsViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 11/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class ProfileDetailsViewController: BaseViewController {
    
    var user: User?

    @IBOutlet private weak var genderToggle: UISegmentedControl!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var passportTextField: UITextField!
    @IBOutlet private weak var bankCardView: BankCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem //UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onEditTapped))
        if user != nil {
            genderToggle.selectedSegmentIndex = user?.gender == .Mr ? 0 : 1
            firstNameTextField.text = user?.firstName
            lastNameTextField.text = user?.lastName
            emailTextField.text = user?.email
            phoneNumberTextField.text = user?.phoneNumber
            passportTextField.text = user?.passport
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
}
