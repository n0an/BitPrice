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

    @IBOutlet weak var usdPriceLabel: WKInterfaceLabel!
    @IBOutlet weak var rubPriceLabel: WKInterfaceLabel!

    @IBOutlet weak var updatingLabel: WKInterfaceLabel!
    
    var formatter: NumberFormatter!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        formatter = NumberFormatter()
        formatter.numberStyle = .currency
    }
    
    override func willActivate() {
        super.willActivate()
        
        if let data = UserDefaults.standard.object(forKey: "btcPrice") as? Data {
            let decoder = JSONDecoder()
            
            if let btc = try? decoder.decode(BTC.self, from: data) {
                self.presentPrices(btc: btc)
            }
        }
        
        updatingLabel.setText("Updating...")

        getPrice()
    }
    
    func getPrice() {
        let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,RUB")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            guard let btc = try? decoder.decode(BTC.self, from: data) else { return }
            
            
            self.presentPrices(btc: btc)
            
            UserDefaults.standard.set(data, forKey: "btcPrice")
            
        }.resume()
    }
    
    func presentPrices(btc: BTC) {
        formatter.locale = Locale(identifier: "en_US")
        self.usdPriceLabel.setText(formatter.string(from: btc.usdPrice as NSNumber))
        
        formatter.locale = Locale(identifier: "ru_RU")
        self.rubPriceLabel.setText(formatter.string(from: btc.rubPrice as NSNumber))
        
        self.updatingLabel.setText("")
    }
}

