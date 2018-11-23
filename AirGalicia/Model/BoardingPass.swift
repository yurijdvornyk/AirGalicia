//
//  BoardingPass.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/30/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class BoardingPass: Codable {
    let id: String
    let boardingPassId: String
    var fullName: String?
    var passport: String?
    var flightDateTime: String?
    var seat: String?
    var origin: String?
    var destination: String?
    var qrCodeBase64Image: String?
    
    init() {
        id = generateId()
        boardingPassId = generateBoardingPassId()
    }
    
    func buildQrCodeContent() -> String {
        return "TestValue" // TODO: Replace with real code
    }
    
    func makeHtmlString() -> String {
        var result = "<html><header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
        result += "<body><div align=\"center\">"
        result += "<img src=\"data:image/png;base64,\(qrCodeBase64Image!)\" width=\"80%\"/></div>"
        result += "<p>\(fullName!)<p>Passport: \(passport!)<p>\(flightDateTime!)<p>Seat: <b>\(seat!)</b>"
        result += "</body></html>"
        return result
    }
}
