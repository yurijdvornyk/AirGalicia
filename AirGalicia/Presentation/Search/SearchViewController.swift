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
    @IBOutlet weak var tripTypeSwitch: UISwitch!
    @IBOutlet private weak var outDateTextField: UITextField!
    @IBOutlet private weak var outDateStackView: UIStackView!
    @IBOutlet private weak var backDateTextField: UITextField!
    @IBOutlet weak var backDateStackView: UIStackView!

    private var apiManager: ApiManager!
    
    private var originAirport: Airport!
    private var destinationAirport: Airport!
    private var flightOutDate: Date!
    private var flightBackDate: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager = ApiManager()
        originStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didOriginStackViewTapped(recognizer:))))
        destinationStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didDestinationStackViewTapped(recognizer:))))
        outDateStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didOutDateViewTapped(recognizer:))))
        backDateStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didBackDateViewTapped(recognizer:))))
        clearAirports()
        updateTripDateFields()
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
        airportsViewController.originAirport = originAirport
        present(airportsViewController, animated: true, completion: nil)
    }
    
    @objc func didOutDateViewTapped(recognizer: UIGestureRecognizer) {
        presentflightDateViewController(defaultPage: 0)
    }
    
    @objc func didBackDateViewTapped(recognizer: UIGestureRecognizer) {
        presentflightDateViewController(defaultPage: 1)
    }
    
    func updateTripDateFields() {
        outDateTextField.isEnabled = originAirport != nil && destinationAirport != nil
        outDateStackView.isUserInteractionEnabled = outDateTextField.isEnabled
        backDateTextField.isEnabled = outDateTextField.isEnabled && tripTypeSwitch.isOn
        backDateStackView.isUserInteractionEnabled = backDateTextField.isEnabled
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if flightOutDate != nil {
            outDateTextField.text = formatter.string(from: flightOutDate)
            if flightBackDate != nil && flightBackDate > flightOutDate {
                backDateTextField.text = ""
            }
        }
        if flightBackDate != nil {
            backDateTextField.text = formatter.string(from: flightBackDate)
            if flightOutDate != nil && flightBackDate < flightOutDate {
                outDateTextField.text = ""
            }
        }
    }
    
    func presentflightDateViewController(defaultPage: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let flightDateViewController = storyBoard.instantiateViewController(withIdentifier: "FlightDateViewController") as! FlightDateViewController
        flightDateViewController.selectionDelegate = self
        flightDateViewController.origin = originAirport.code
        flightDateViewController.destination = destinationAirport.code
        flightDateViewController.defaultPage = defaultPage
        flightDateViewController.outDate = flightOutDate
        flightDateViewController.backDate = flightBackDate
        present(flightDateViewController, animated: true, completion: nil)
    }
    
    func onAirportSelected(isUserSelectingOrigin: Bool, airport: Airport?) {
        if airport == nil {
            return
        }
        
        if isUserSelectingOrigin {
            originAirport = airport
            destinationAirport = nil
            destinationStackView.isUserInteractionEnabled = true
            destinationTextField.isEnabled = true
            swapDestinationsButton.isEnabled = false
            setDatePickEnabled(false)
        } else {
            destinationAirport = airport
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
        originAirport = nil
        destinationAirport = nil
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
        let tempAirport = originAirport
        originAirport = destinationAirport
        destinationAirport = tempAirport
        updateAirportTextFields()
    }
    
    @IBAction func onTripTypeSwitchValueChanged(_ sender: UISwitch) {
        updateTripDateFields()
    }
    
    func updateAirportTextFields() {
        originTextField.text = formatAirportForSearchField(airport: originAirport)
        destinationTextField.text = formatAirportForSearchField(airport: destinationAirport)
    }
    
    func flightDateSelected(outDate: Date?, backDate: Date?) {
        flightOutDate = outDate
        flightBackDate = backDate
        updateTripDateFields()
    }
}
