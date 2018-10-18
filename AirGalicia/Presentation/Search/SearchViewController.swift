//
//  FirstViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/20/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit
import FSCalendar

class SearchViewController: BaseViewController, AirportsSelectionDelegate, FlightDateSelectionDelegate {
    
    
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
    
    private var apiManager: ApiManager!
    private var booking: Booking!
    private var outPrice: Double!
    private var backPrice: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager = ApiManager()
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
        booking = Booking()
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if booking.outDate != nil {
            outDateTextField.text = formatter.string(from: booking.outDate!)
            if booking.returnDate != nil && booking.returnDate! > booking.outDate! {
                backDateTextField.text = ""
            }
        } else {
            outDateTextField.text = ""
        }
        if booking.returnDate != nil {
            backDateTextField.text = formatter.string(from: booking.returnDate!)
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
        flightDateViewController.selectionDelegate = self
        flightDateViewController.origin = booking.origin!.code
        flightDateViewController.destination = booking.destination!.code
        flightDateViewController.dateType = dateType
        flightDateViewController.outDate = booking.outDate
        flightDateViewController.backDate = booking.returnDate
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
    
    func formatAirportForSearchField(airport: Airport?) -> String {
        if airport == nil {
            return ""
        } else {
            return "\(airport!.city), \(airport!.country) (\(airport!.name), \(airport!.code))"
        }
    }
    
    @IBAction func onSwapButtonTapped(_ sender: UIButton) {
        let tempAirport = booking.origin
        booking.origin = booking.destination
        booking.destination = tempAirport
        updateAirportTextFields()
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
        originTextField.text = formatAirportForSearchField(airport: booking?.origin)
        destinationTextField.text = formatAirportForSearchField(airport: booking?.destination)
    }
    
    func onOutDateSelected(date: Date?, price: Double) {
        booking.outDate = date
        outPrice = price
        updateTripDateFields()
        updateTotalPrice()
    }
    
    func onBackDateSelected(date: Date?, price: Double) {
        booking.returnDate = date
        backPrice = price
        updateTripDateFields()
        updateTotalPrice()
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
        let singlePrice = (outPrice != nil ? outPrice : 0) + (backPrice != nil ? backPrice : 0)
        booking.singlePrice = singlePrice
        let ticketsCount = booking.passengers.count
        let totalPrice = singlePrice * Double(ticketsCount)
        priceLabel.text = "\(String(totalPrice)) €"
        buyTicketsButton.isEnabled = totalPrice > 0
    }
    
    @IBAction func onBuyTapped(_ sender: UIButton) {
    }
    
    @IBAction func onResetTapped(_ sender: UIButton) {
        setUpDefaultScreenData()
    }
}
