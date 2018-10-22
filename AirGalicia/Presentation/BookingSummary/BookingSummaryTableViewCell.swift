//
//  BookingSummaryTableViewCell.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/21/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class BookingSummaryTableViewCell: UITableViewCell {

    @IBOutlet private weak var label: UILabel!
    
    func configureWith(content: String?) {
        label.text = content
    }
}
