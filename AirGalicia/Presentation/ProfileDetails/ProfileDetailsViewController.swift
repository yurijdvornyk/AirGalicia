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
        navigationItem.rightBarButtonItem = editButtonItem //UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onEditTapped))
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
}
