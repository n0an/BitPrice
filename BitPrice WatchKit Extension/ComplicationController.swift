//
//  ComplicationController.swift
//  BitPrice WatchKit Extension
//
//  Created by nag on 07/05/2019.
//  Copyright © 2019 Anton Novoselov. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        
        let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,RUB")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            guard let btc = try? decoder.decode(BTC.self, from: data) else { return }
            
            
            if complication.family == .modularSmall {
                let template = CLKComplicationTemplateModularSmallStackText()
                template.line1TextProvider = CLKSimpleTextProvider(text: "BIT")
                template.line2TextProvider = CLKSimpleTextProvider(text: "\(Int(btc.usdPrice))")
                
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(entry)
            }
            
            if complication.family == .modularLarge {
                let template = CLKComplicationTemplateModularLargeStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "BitPrice")
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = Locale(identifier: "en_US")
                
                template.body1TextProvider = CLKSimpleTextProvider(text: formatter.string(from: btc.usdPrice as NSNumber)!)
                
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(entry)
            }
            
            
        }.resume()
        
        
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        if complication.family == .modularSmall {
            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: "BIT")
            template.line2TextProvider = CLKSimpleTextProvider(text: "$$$")
            handler(template)
        }
        if complication.family == .modularLarge {
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "BitPrice")
            template.body1TextProvider = CLKSimpleTextProvider(text: "$1,456.78")
            
            handler(template)
        }
        
    }
    
}
