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
        guard let dataSource = koloda.dataSource as? ShoppingDataSource else {
            return
        }
        dataSource.pullCraigslist(koloda)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        guard let dataSource = koloda.dataSource as? ShoppingDataSource,
            let shoppingURL = dataSource.cards[index].shoppingURL else {
                return
        }
        UIApplication.shared.open(shoppingURL, options: [:]) { (success) in
            if (!success) {
                print("oh no!")
            }
        }
        
    }
}
