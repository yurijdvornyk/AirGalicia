//
//  ProfileDetailsViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 11/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class ProfileDetailsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onEditTapped))
    }
    
    @objc func onEditTapped() {
        print("OnEditTapped")
    }
}
