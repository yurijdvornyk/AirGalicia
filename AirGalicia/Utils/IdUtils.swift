//
//  Util.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/30/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import Foundation

func generateId() -> String {
    return UUID.init().uuidString
}

func generateBoardingPassId() -> String {
    let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var result = ""
    for i in 0...5 {
        result += alphabet[Int.random(in: 0...alphabet.count - 1)]
    }
    return result
}
