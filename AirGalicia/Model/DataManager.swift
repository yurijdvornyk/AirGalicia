//
//  ApiManager.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class DataManager {
    
    static let instance = DataManager()
    
    let baseDataUrl = "https://raw.githubusercontent.com/yurijdvornyk/AirGalicia/master/External/MockApi/"
    let userDefaults: UserDefaults
    
    var trips: [Trip]
    
    private init() {
        userDefaults = UserDefaults.init(suiteName: "defaultUser")!
        trips = [Trip]()
        
        // TODO: Temporary code; remove
        let origin = Airport(code: "LWO", city: "Lviv", country: "Ukraine", name: "Lviv Danylo Halytskyi International Airport", location: "49.8134554,23.9623552", planes: ["AG01"])
        
        let destination = Airport(code: "ZRH", city: "Zurich", country: "Switzerland", name: "Zurich", location: "47.4582201,8.5532815", planes: [])
        
        var flight = Schedule()
        flight.from = "LWO"
        flight.to = "FAO"
        flight.plane = "AG01"
        flight.schedule = nil
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let outDate = dateFormatter.date(from: "2018-11-20 20:00")
        let outTime = FlightTime(ScheduleTime(timeString: "20:00"), ScheduleTime(timeString: "22:00"))
        let returnDate = dateFormatter.date(from: "2018-11-22 16:00")
        let returnTime =  FlightTime(ScheduleTime(timeString: "16:00"), ScheduleTime(timeString: "19:00"))
        
        let price = 80.0
        
        var passengers = [Passenger]()
        let passenger0 = Passenger()
        passenger0.firstName = "Homer"
        passenger0.lastName = "Simpson"
        passenger0.passport = "HS0824"
        passenger0.email = "hsimpson@yahoo.com"
        passenger0.gender = .Mr
        passenger0.hasCheckedBaggage = true
        passenger0.hasPriority = false
        passengers.append(passenger0)
        
        let passenger1 = Passenger()
        passenger1.firstName = "Marge"
        passenger1.lastName = "Simpson"
        passenger1.passport = "MO2478"
        passenger1.email = "marge1975@gmail.com"
        passenger1.gender = .Ms
        passenger1.hasCheckedBaggage = true
        passenger1.hasPriority = true
        passengers.append(passenger1)
        
        let trip: Trip = Trip()
        trip.origin = origin
        trip.destination = destination
        trip.flight = flight
        trip.outDate = outDate
        trip.outTime = outTime
        trip.returnDate = returnDate
        trip.returnTime = returnTime
        trip.outPrice = price
        trip.returnPrice = price
        trip.passengers = passengers
        trip.outBoardingPasses = nil
        trip.returnBoardingPasses = nil
        
        trips.append(trip)
    }
    
    func loadAirports(success: @escaping ([Airport]) -> Void, error: (Error) -> Void) {
        URLSession.shared.dataTask(with: URL(string: baseDataUrl + "airports.json")!) { (data, response, error) in
            do {
                let airports = try JSONDecoder().decode([Airport].self, from: data!)
                success(airports)
            } catch {
                success([])
                // TODO: Handle error
            }
            }.resume()
    }
    
    func loadSchedule(success: @escaping ([Schedule]) -> Void, error: (Error) -> Void) {
        URLSession.shared.dataTask(with: URL(string: baseDataUrl + "schedule.json")!) { (data, response, error) in
            do {
                let schedule = try JSONDecoder().decode([Schedule].self, from: data!)
                success(schedule)
            } catch {
                success([])
                // TODO: Handle error
            }
            }.resume()
    }
    
    func findDestinations(origin: Airport?, success: @escaping ([Airport]) -> Void, error: (Error) -> Void) {
        loadAirports(success: {(allAirports: [Airport]) in
            self.loadSchedule(success: {(schedule: [Schedule]) in
                let destinations = schedule.filter({
                    return $0.from == origin?.code
                }).map({ (schedule: Schedule) -> String in
                    return schedule.to!
                })
                success(allAirports.filter({ (airport: Airport) -> Bool in
                    return destinations.contains(airport.code)
                }))
            }, error: { (Error) in
                success([])
                // TODO: Handle error
            })
            
        }, error: {(Error) in
            success([])
            // TODO: Handle error
        })
    }
    
    func loadFlight(from: String, to: String, success: @escaping (Schedule?) -> Void, fail: (Error) -> Void) {
        loadSchedule(success: { (schedule: [Schedule]) in
            let result = schedule.filter({ (flight: Schedule) -> Bool in
                return flight.from == from && flight.to == to
            })
            success(result.count < 1 ? nil : result[0])
        }) { (error: Error) in
            fail(error)
        }
    }
    
    func loadTrips(success: @escaping ([Trip]?) -> Void, fail: (Error) -> Void) {
        // TODO: Use real data source
        success(trips)
//        let trips = userDefaults.array(forKey: "trips") as! [Booking]?
//        if trips != nil {
//            success(trips)
//        } else {
//            success([])
//            // TODO: Handle error
//        }
    }
    
    func updateTrips(value: [Trip], success: @escaping () -> Void, fail: (Error) -> Void) {
        // TODO: Use real data source
        trips = value
//        userDefaults.set(value, forKey: "trips")
//        success()
    }
    
    func addTrip(trip: Trip, success: @escaping () -> Void, fail: (Error) -> Void) {
        // TODO: Use real data source
        trips.append(trip)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            success()
        })
    }
    
    func loadPlaneInfo(planeId: String,  success: @escaping (Plane?) -> Void, error: (Error) -> Void) {
        URLSession.shared.dataTask(with: URL(string: baseDataUrl + "fleet.json")!) { (data, response, error) in
            do {
                let planes = try JSONDecoder()
                    .decode([Plane].self, from: data!)
                    .filter({
                        return $0.id == planeId
                    })
                if planes.count > 0 {
                    success(planes.first)
                } else {
                    success(nil)
                }
            } catch {
                success(nil)
                // TODO: Handle error
            }
            }.resume()
    }
    
    func generateQrCode(boardingPass: BoardingPass,  success: @escaping (String?) -> Void, error: (Error) -> Void) {
        // http://goqr.me/api/
        // https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=Example
        let url = URL(string: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=\(boardingPass.buildQrCodeContent())")
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) // TODO: Add catch block
            DispatchQueue.main.async {
                success(data?.base64EncodedString())
            }
        }
    }
    
    func addOrUpdateTrip(_ trip: Trip) {
        for i in 0...trips.count - 1 {
            if trips[i].id == trip.id {
                trips[i] = trip
                return
            }
        }
        trips.append(trip)
    }
}
