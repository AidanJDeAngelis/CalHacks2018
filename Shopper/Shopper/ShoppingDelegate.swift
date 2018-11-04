//
//  ShoppingDelegate.swift
//  Shopper
//
//  Created by Milo Darling on 11/2/18.
//  Copyright © 2018 Milo Darling. All rights reserved.
//

import Foundation
import Koloda

class ShoppingDelegate : NSObject, KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("we out here")
        guard let dataSource = koloda.dataSource as? ShoppingDataSource else {
            return
        }
        dataSource.pullCraigslist(koloda, forced: false)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        guard direction == .right, let dataSource = koloda.dataSource as? ShoppingDataSource,
            let shoppingURL = dataSource.cards[index].shoppingURL,
            let price = dataSource.cards[index].price,
            let item = dataSource.cards[index].item else {
                print("where the url at tho")
                return
        }
        let defaults = UserDefaults.standard
        var fiends = defaults.object(forKey: "fiends") as? Array<Any> ?? []
        
        fiends.append(["photos": dataSource.cards[index].images.map({ (url) -> String in
            return url.absoluteString;
        }), "url": shoppingURL.absoluteString, "price": price, "item": item])
        
        defaults.set(fiends, forKey: "fiends")
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
    }
}
