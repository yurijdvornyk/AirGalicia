//
//  AirportSearchCell.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/27/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class AirportSearchCell: UITableViewCell {
    
    @IBOutlet private weak var airportLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    
    func configureWith(airport: Airport?) {
        if airport != nil {
            airportLabel.text = airport!.name
            locationLabel.text = "\(airport!.city), \(airport!.country)"
            codeLabel.text = airport?.code
        }
    }
}
