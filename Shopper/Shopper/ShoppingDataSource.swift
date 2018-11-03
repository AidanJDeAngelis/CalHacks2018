//
//  ShoppingDataSource.swift
//  Shopper
//
//  Created by Milo Darling on 11/2/18.
//  Copyright © 2018 Milo Darling. All rights reserved.
//

import Foundation
import Koloda

let craigslistURL = URL(string: "https://lamo.duckdns.org/craigslist/list")

class ShoppingDataSource : NSObject, KolodaViewDataSource {
    
    var cards: [CardView] = []
    
    func pullCraigslist(_ koloda: KolodaView) {
        /*
        let task = URLSession.shared.dataTask(with: craigslistURL!) {(data, response, error) in
            guard (error == nil), let data = data, let listings = try? JSONSerialization.jsonObject(with: data) as! [Dictionary<String, Any>] else {
                print("Failed to get craigslist listings")
                return
            }
            for listing in listings {
                if let photoLink = listing["photo"] as? String,
                    let photoURL = URL(string: photoLink),
                    let title = listing["title"] as? String,
                    let price = listing["price"] as? CGFloat,
                    let link = listing["url"] as? String,
                    let url = URL(string: link) {
                    self.addCard(with: title, image: photoURL, link: url, price: price)
                }
            }
            koloda.reloadData()
        }
        task.resume()
        */
        for _ in 1...4 {
            let photoURL = URL(string: "https://www.profiletalent.com.au/wp-content/uploads/2017/05/profile-talent-ant-simpson-feature.jpg")!
            let title = "Stud"
            let price = CGFloat(4.2)
            let url = URL(string: "https://example.com")!
            self.addCard(with: title, image: photoURL, link: url, price: price, koloda: koloda)
        }
        koloda.reloadData()
    }
    
    func addCard(with name: String, image: URL, link: URL, price: CGFloat, koloda: KolodaView) {
        let card = CardView(frame: koloda.bounds)
        card.setImageURL(url: image)
        card.setName(name: name)
        card.setPrice(price: price)
        cards.append(card)
        
    }
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return cards.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return cards[index]
    }
}
