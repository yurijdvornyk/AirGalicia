//
//  FirstViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/20/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit
import FSCalendar

class SearchViewController: BaseViewController, AirportsSelectionDelegate, TripUpdateDelegate, BookingCompleteDelegate {
    
    // TODO: Implementing search bar https://www.youtube.com/watch?v=bWQhhKwPMo4
    // https://www.youtube.com/watch?v=wVeX68Iu43E

    @IBOutlet private weak var originStackView: UIStackView!
    @IBOutlet private weak var originTextField: UITextField!
    @IBOutlet private weak var destinationStackView: UIStackView!
    @IBOutlet private weak var destinationTextField: UITextField!
    @IBOutlet private weak var swapDestinationsButton: UIButton!
    @IBOutlet private weak var tripTypeSwitch: UISwitch!
    @IBOutlet private weak var outDateTextField: UITextField!
    @IBOutlet private weak var outDateStackView: UIStackView!
    @IBOutlet private weak var backDateTextField: UITextField!
    @IBOutlet private weak var backDateStackView: UIStackView!
    @IBOutlet private weak var ticketsCountLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var buyTicketsButton: UIButton!
    
    private var booking: Trip!
    private var outPrice: Double!
    private var backPrice: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        originStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didOriginStackViewTapped(recognizer:))))
        destinationStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didDestinationStackViewTapped(recognizer:))))
        outDateStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didOutDateViewTapped(recognizer:))))
        backDateStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didBackDateViewTapped(recognizer:))))
        setUpDefaultScreenData()
    }
    
    @objc func didOriginStackViewTapped(recognizer: UIGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let airportsViewController = storyBoard.instantiateViewController(withIdentifier: "AirportsViewController") as! AirportsViewController
        airportsViewController.selectionDelegate = self
        airportsViewController.originAirport = nil
        present(airportsViewController, animated: true, completion: nil)
    }
    
    @objc func didDestinationStackViewTapped(recognizer: UIGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let airportsViewController = storyBoard.instantiateViewController(withIdentifier: "AirportsViewController") as! AirportsViewController
        airportsViewController.selectionDelegate = self as AirportsSelectionDelegate
        airportsViewController.originAirport = booking.origin
        present(airportsViewController, animated: true, completion: nil)
    }
    
    @objc func didOutDateViewTapped(recognizer: UIGestureRecognizer) {
        presentFlightDateViewController(dateType: .Out)
    }
    
    @objc func didBackDateViewTapped(recognizer: UIGestureRecognizer) {
        presentFlightDateViewController(dateType: .Back)
    }
    
    func setUpDefaultScreenData() {
        clearAirports()
        booking = Trip()
        booking.passengers?.append(Passenger())
        outDateTextField.text = ""
        backDateTextField.text = ""
        outPrice = 0
        backPrice = 0
        onTicketsCountUpdated()
        updateTotalPrice()
    }
    
    func updateTripDateFields() {
        outDateTextField.isEnabled = booking.origin != nil && booking.destination != nil
        outDateStackView.isUserInteractionEnabled = outDateTextField.isEnabled
        backDateTextField.isEnabled = outDateTextField.isEnabled && tripTypeSwitch.isOn
        backDateStackView.isUserInteractionEnabled = backDateTextField.isEnabled
        
        
        if booking.outDate != nil {
            outDateTextField.text = formatFlightDate(date: booking.outDate!)
            if booking.returnDate != nil && booking.returnDate! > booking.outDate! {
                backDateTextField.text = ""
            }
        } else {
            outDateTextField.text = ""
        }
        if booking.returnDate != nil {
            backDateTextField.text = formatFlightDate(date: booking.returnDate!)
            if booking.outDate != nil && booking.returnDate! < booking.outDate! {
                outDateTextField.text = ""
            }
        } else {
            backDateTextField.text = ""
        }
    }
    
    func presentFlightDateViewController(dateType: FlightDateType) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let flightDateViewController = storyBoard.instantiateViewController(withIdentifier: "FlightDateViewController") as! FlightDateViewController
        flightDateViewController.delegate = self
        flightDateViewController.origin = booking.origin!.code
        flightDateViewController.destination = booking.destination!.code
        flightDateViewController.dateType = dateType
        flightDateViewController.booking = booking
        present(flightDateViewController, animated: true, completion: nil)
    }
    
    func onAirportSelected(isUserSelectingOrigin: Bool, airport: Airport?) {
        if airport == nil {
            return
        }
        
        if isUserSelectingOrigin {
            booking.origin = airport
            booking.destination = nil
            destinationStackView.isUserInteractionEnabled = true
            destinationTextField.isEnabled = true
            swapDestinationsButton.isEnabled = false
            setDatePickEnabled(false)
        } else {
            booking.destination = airport
            setDatePickEnabled(true)
        }
        updateAirportTextFields()
        updateTripDateFields()
    }
    
    func setDatePickEnabled(_ isEnabled: Bool) {
        swapDestinationsButton.isEnabled = isEnabled
        outDateStackView.isUserInteractionEnabled = isEnabled
        outDateTextField.isEnabled = isEnabled
        backDateStackView.isUserInteractionEnabled = isEnabled
        outDateTextField.isEnabled = isEnabled
    }
    
    func clearAirports() {
        booking?.origin = nil
        booking?.destination = nil
        updateAirportTextFields()
        destinationStackView.isUserInteractionEnabled = false
        destinationTextField.isEnabled = false
    }
    
    @IBAction func onSwapButtonTapped(_ sender: UIButton) {
        let tempAirport = booking.origin
        booking.origin = booking.destination
        booking.destination = tempAirport
        updateAirportTextFields()
        booking.outDate = nil
        booking.returnDate = nil
        onBookingUpdated(booking: booking)
    }
    
    @IBAction func onTripTypeSwitchValueChanged(_ sender: UISwitch) {
        if !sender.isOn {
            booking.returnDate = nil
            backPrice = nil
        }
        updateTripDateFields()
        updateTotalPrice()
    }
    
    func updateAirportTextFields() {
        originTextField.text = formatAirportFullString(airport: booking?.origin)
        destinationTextField.text = formatAirportFullString(airport: booking?.destination)
    }
    
    @IBAction func onMinusTicketTapped(_ sender: UIButton) {
        if (booking.passengers?.count)! > 1 {
            booking.passengers?.removeLast()
            onTicketsCountUpdated()
        }
    }
    
    @IBAction func onPlusTicketTapped(_ sender: UIButton) {
        if (booking.passengers?.count)! < 10 {
            booking.passengers?.append(Passenger())
            onTicketsCountUpdated()
        }
    }
    
    func onTicketsCountUpdated() {
        updateTotalPrice()
        ticketsCountLabel.text = String((booking.passengers?.count)!)
    }
    
    func updateTotalPrice() {
        priceLabel.text = formatTotalPrice(booking.totalPrice)
        buyTicketsButton.isEnabled = booking.totalPrice > 0
    }
    
    @IBAction func onBuyTapped(_ sender: UIButton) {
        let bookingViewController = Navigator.instance.bookingFlow(tripUpdateDelegate: self, bookingCompleteDelegate: self, booking: booking)
        present(bookingViewController, animated: true, completion: nil)
    }
    
    @IBAction func onResetTapped(_ sender: UIButton) {
        setUpDefaultScreenData()
    }
    
    func onBookingUpdated(booking: Trip?) {
        self.booking = booking
        updateTripDateFields()
        updateTotalPrice()
    }
    
    func onBookingCompleted(booking: Trip) {
        Navigator.instance.navigate(trip: booking, root: tabBarController!)
    }
}

protocol TripUpdateDelegate {
    func onBookingUpdated(booking: Trip?)
}

protocol BookingCompleteDelegate {
    func onBookingCompleted(booking: Trip)
}
