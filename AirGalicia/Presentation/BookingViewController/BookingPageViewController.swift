//
//  BookingPageViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 11/29/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class BookingPageViewController: BaseViewController {
    
    var bookingDelegate: BookingDelegate?
    
    var booking: Trip? {
        get {
            return bookingDelegate?.booking
        }
        set {
            bookingDelegate?.booking = newValue
        }
    }
}
