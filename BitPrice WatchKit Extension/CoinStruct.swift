//
//  BTC.swift
//  BitPrice WatchKit Extension
//
//  Created by nag on 29/05/2019.
//  Copyright © 2019 Anton Novoselov. All rights reserved.
//

import Foundation

struct BTC: Codable {
    var usdPrice: Double
    var rubPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case usdPrice = "USD"
        case rubPrice = "RUB"
    }
}
