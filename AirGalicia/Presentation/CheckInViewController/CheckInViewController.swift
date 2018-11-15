//
//  CheckInViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 11/10/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class CheckInViewController: BaseViewController, PassengerSeatDelegate {

    @IBOutlet private weak var checkInTableView: UITableView!
    @IBOutlet private weak var seatPickerBackground: UIView!
    @IBOutlet private weak var seatPickerView: UIPickerView!
    @IBOutlet private weak var seatPickerToolbar: UIToolbar!
    
    var trip: Trip?
    var delegate: TripUpdateDelegate?
    var plane: Plane?
    
    var passenger: Passenger?
    private var seatRow: String?
    private var seatInRow: String?
    private var seatSelectedDelegate: PassengerSeatDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        DataManager.shared.loadPlaneInfo(planeId: (trip?.flight.plane)!, success: { (plane: Plane?) in
            self.plane = plane
            DispatchQueue.main.async() {
                self.hideLoading()
            }
        }, error: { (Error) in
            DispatchQueue.main.async() {
                self.hideLoading()
            }
            // TODO: Handle error
        })
    }
    
    func onSelectPassengerSeat(passenger: Passenger, delegate: PassengerSeatDelegate) {
        self.passenger = passenger
        self.seatSelectedDelegate = delegate
        if plane != nil {
            showSeatPicker(rows: (plane?.rowList)!, seatsInRow: (plane?.seatsInRow)!)
        }
    }
    
    func showSeatPicker(rows: [String], seatsInRow: [String]) {
        seatPickerBackground.isHidden = false
        seatPickerView.isHidden = false
        seatPickerToolbar.isHidden = false
        seatPickerView.reloadAllComponents()
    }
    
    func onSeatSelected(_ seat: String) {
        if passenger != nil {
        }
    }
    
    func closeSeatPicker() {
        seatPickerBackground.isHidden = true
        seatPickerView.isHidden = true
        seatPickerToolbar.isHidden = true
        
        seatRow = nil
        seatInRow = nil
        passenger = nil
    }
    
    @IBAction func onCheckInTapped(_ sender: UIButton) {
    }
    
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        delegate!.onBookingUpdated(booking: trip)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSeatPickerCancelTapped(_ sender: UIBarButtonItem) {
        closeSeatPicker()
    }
    
    @IBAction func onSeatPickerDoneTapped(_ sender: UIBarButtonItem) {
        if seatSelectedDelegate != nil && seatRow != nil && seatInRow != nil {
            seatSelectedDelegate?.onSeatSelected("\(seatRow!)\(seatInRow!)")
        }
        closeSeatPicker()
        seatSelectedDelegate = nil
    }
}

extension CheckInViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (trip?.passengers.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CheckInTableViewCell
        cell.configureWith(trip: trip!, passenger: (trip?.passengers[indexPath.row])!, delegate: self)
        return cell
    }
}

extension CheckInViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if plane == nil {
            return 0
        } else if component == 0 {
            return (plane!.rows)!
        } else {
            return (plane?.seatsInRow.count)!
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return plane?.rowList[row]
        } else {
            return plane?.seatsInRow[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            seatRow = plane?.rowList[row]
        } else {
            seatInRow = plane?.seatsInRow[row]
        }
    }
}

protocol PassengerSeatDelegate {
    func onSelectPassengerSeat(passenger: Passenger, delegate: PassengerSeatDelegate)
    func onSeatSelected(_ seat: String)
}
