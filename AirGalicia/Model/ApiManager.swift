//
//  ApiManager.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

protocol ApiCallback {
    associatedtype T
    func onSuccess(result: T?)
    func onError(error: NSError)
}

class ApiManager: NSObject {
    let baseDataUrl = "https://raw.githubusercontent.com/yurijdvornyk/AirGalicia/master/External/MockApi/"
    
    func loadAirports(success: @escaping ([Airport]) -> Void, error: (NSError) -> Void) {
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
    
    func loadSchedule(success: @escaping ([Schedule]) -> Void, error: (NSError) -> Void) {
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
    
    func findDestinations(origin: Airport?, success: @escaping ([Airport]) -> Void, error: (NSError) -> Void) {
        if origin == nil {
            loadAirports(success: success, error: error)
        } else {
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
                }, error: { (NSError) in
                    success([])
                    // TODO: Handle error
                })
                
            }, error: {(NSError) in
                success([])
                // TODO: Handle error
            })
        }
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
}
