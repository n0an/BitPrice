//
//  InterfaceController.swift
//  BitPrice WatchKit Extension
//
//  Created by nag on 07/05/2019.
//  Copyright © 2019 Anton Novoselov. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
//        CoinsData.shared.getPricesForAllCoins()
        
        getPrice()
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    func getPrice() {
        let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,RUB")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            
            
            print(json)
            
            
        }.resume()
    }

}

extension InterfaceController: CoinsDataDelegate {
    func newPrices() {
        
        
        
        
    }
}

