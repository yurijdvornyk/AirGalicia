//
//  ApiManager.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class DataManager {
    
    static let shared = DataManager()
    
    let baseDataUrl = "https://raw.githubusercontent.com/yurijdvornyk/AirGalicia/master/External/MockApi/"
    let userDefaults: UserDefaults
    
    private init() {
        userDefaults = UserDefaults.init(suiteName: "defaultUser")!
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
                    return schedule.to
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
    
    func loadTrips(success: @escaping ([Booking]?) -> Void, fail: (Error) -> Void) {
        let trips = userDefaults.array(forKey: "trips") as! [Booking]?
        if trips != nil {
            success(trips)
        } else {
            success([])
            // TODO: Handle error
        }
    }
    
    func updateTrips(value: [Booking?], success: @escaping () -> Void, fail: (Error) -> Void) {
        userDefaults.set(value, forKey: "trips")
        success()
    }
    
    func addTrip(trip: Booking, success: @escaping () -> Void, fail: (Error) -> Void) {
        if (userDefaults.array(forKey: "trips") == nil) {
            userDefaults.set([], forKey: "trips")
        }
        var trips = userDefaults.array(forKey: "trips") as! [Booking]?
        trips?.append(trip)
        updateTrips(value: trips!, success: {
            success()
        }, fail: { (Error) in
            // TODO: Handle
        })
    }
}
