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
    var isOutTrip: Bool?
    var tripDelegate: TripUpdateDelegate?
    var plane: Plane?
    
    var passenger: Passenger?
    private var seatRow: String?
    private var seatInRow: String?
    var seatSelectedDelegate: PassengerSeatDelegate?
    var boardingPassGenerationDelegate: BoardingPassGenerationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        DataManager.instance.loadPlaneInfo(planeId: (trip?.flight.plane)!, success: { (plane: Plane?) in
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
        if seatPickerView.numberOfRows(inComponent: 0) > 0 && seatPickerView.numberOfRows(inComponent: 1) > 0 {
            seatPickerView.selectRow(0, inComponent: 0, animated: true)
            seatPickerView.selectRow(0, inComponent: 1, animated: true)
        }
    }
    
    func onSeatSelected(_ seat: String) {
        // ???
    }
    
    func closeSeatPicker() {
        seatPickerBackground.isHidden = true
        seatPickerView.isHidden = true
        seatPickerToolbar.isHidden = true
        
        seatRow = nil
        seatInRow = nil
        passenger = nil
    }
    
    func generateRandomSeat() -> String {
        if let rows = plane?.rows, let seats = plane?.seatsInRow {
            let row = Int.random(in: 1...rows)
            let seat = Int.random(in: 0...seats.count - 1)
            return "\(row)\(seats[seat])"
        }
        return ""
    }
    
    fileprivate func proceedOrFinishGeneratingBoardingPasses(boardingPass: BoardingPass, boardingPasses: [BoardingPass], passengerPosition: Int, completed: @escaping () -> Void) {
        var updatedBoardingPasses = boardingPasses
        updatedBoardingPasses.append(boardingPass)
        if passengerPosition < (self.trip?.passengers.count)! - 1 {
            self.createBoardingPasses(completed: completed, forPassanger: passengerPosition + 1, withBoardingPasses: updatedBoardingPasses)
        } else {
            if self.isOutTrip! {
                self.trip?.outBoardingPasses = updatedBoardingPasses
            } else {
                self.trip?.returnBoardingPasses = updatedBoardingPasses
            }
            DataManager.instance.addOrUpdateTrip(self.trip!)
            completed()
        }
    }
    
    func createBoardingPasses(completed: @escaping () -> Void, forPassanger passengerPosition: Int = 0, withBoardingPasses boardingPasses: [BoardingPass] = []) {
        // https://stackoverflow.com/questions/2329364/how-to-embed-images-in-a-single-html-php-file
        if passengerPosition < (trip?.passengers.count)! {
            let boardingPass = BoardingPass()
            
            boardingPass.fullName = trip!.passengers[passengerPosition].shortInfo
            boardingPass.passport = trip!.passengers[passengerPosition].passport
            boardingPass.flightDateTime = isOutTrip! ? formatFlightDate(date: trip?.outDate, time: (trip?.outTime)!) : formatFlightDate(date: trip?.returnDate, time: (trip?.returnTime)!)
            boardingPass.seat = (checkInTableView.cellForRow(at: IndexPath(row: passengerPosition, section: 0)) as! CheckInTableViewCell).seat
            if boardingPass.seat == nil {
                boardingPass.seat = generateRandomSeat()
            }
            boardingPass.origin = trip?.origin.code
            boardingPass.destination = trip?.destination.code
            DataManager.instance.generateQrCode(boardingPass: boardingPass, success: { (image: String?) in
                boardingPass.qrCodeBase64Image = image
                self.proceedOrFinishGeneratingBoardingPasses(boardingPass: boardingPass, boardingPasses: boardingPasses, passengerPosition: passengerPosition, completed: completed)
            }) { (error: Error) in
                boardingPass.qrCodeBase64Image = ":"
                self.proceedOrFinishGeneratingBoardingPasses(boardingPass: boardingPass, boardingPasses: boardingPasses, passengerPosition: passengerPosition, completed: completed)
            }
        }
    }
    
    @IBAction func onCheckInTapped(_ sender: UIButton) {
        showLoading()
        createBoardingPasses(completed: {
            self.hideLoading()
            self.dismiss(animated: true, completion: {
                self.boardingPassGenerationDelegate?.onBoardingPassesGenerated((self.isOutTrip! ? self.trip?.outBoardingPasses : self.trip?.returnBoardingPasses)!)
            })
        })
    }
    
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        tripDelegate!.onBookingUpdated(booking: trip)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSeatPickerCancelTapped(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async() {
            self.closeSeatPicker()
        }
    }
    
    @IBAction func onSeatPickerDoneTapped(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async() {
            if self.seatSelectedDelegate != nil && self.seatRow != nil && self.seatInRow != nil {
                self.seatSelectedDelegate?.onSeatSelected("\(self.seatRow!)\(self.seatInRow!)")
            }
            self.closeSeatPicker()
            self.seatSelectedDelegate = nil
        }
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
