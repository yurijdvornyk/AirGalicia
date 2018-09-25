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
}
