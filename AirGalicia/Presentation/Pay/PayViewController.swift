//
//  PayViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/24/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class PayViewController: BookingPageViewController {
    
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var cardToggle: UISegmentedControl!
    @IBOutlet private weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    var user: User?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        totalPriceLabel.text = formatTotalPrice(booking?.totalPrice)
        cardToggle.selectedSegmentIndex = user != nil && user?.paymentInfo != nil ? 0 : 1
        cardToggle.setEnabled(user != nil && user?.paymentInfo != nil, forSegmentAt: 0)
    }
    
    @IBAction func onPayTapped(_ sender: UIButton) {
        showLoading()
        DataManager.instance.addTrip(trip: booking!, success: {
            DispatchQueue.main.async(execute: {
                self.hideLoading()
                self.showMessage(title: "Congratulations!", message: "You booked your Air Galicia trip!\nThank you for choosing us!", button: "Got it", action: {
                    self.bookingDelegate?.goNext()
                })
            })
        }, fail: {_ in
            DispatchQueue.main.async(execute: {
                self.hideLoading()
                self.showMessage(title: "Error", message: "Unfortunately, something went wrong.\nTry submitting your booking again please.", button: "OK", action: {
                    self.dismiss(animated: true, completion: nil)
                })
            })
        })
    }
    
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
