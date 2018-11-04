//
//  ShoppingDataSource.swift
//  Shopper
//
//  Created by Milo Darling on 11/2/18.
//  Copyright © 2018 Milo Darling. All rights reserved.
//

import Foundation
import Koloda

let craigslistLink: String = "https://lamo.duckdns.org/craigslist/list"

class ShoppingDataSource : NSObject, KolodaViewDataSource {
    
    var cards: [CardView] = []
    
    func pullCraigslist(_ koloda: KolodaView) {
        var params = "?numItems=15"
        if let city = UserDefaults.standard.string(forKey: "city") {
            params += "&city=\(city)"
        }
        if let category = UserDefaults.standard.string(forKey: "category") {
            params += "&category=\(category)"
        }
        guard let craigslistURL = URL(string: craigslistLink+params) else {
            print("couldn't get craigslist url!")
            return
        }
        let task = URLSession.shared.dataTask(with: craigslistURL) {(data, response, error) in
            guard (error == nil), let data = data, let listings = try? JSONSerialization.jsonObject(with: data) as! [Dictionary<String, Any>] else {
                print("Failed to get craigslist listings")
                return
            }
            for listing in listings {
                if let photos = listing["images"] as? [String],
                    photos.count > 0,
                    let title = listing["title"] as? String,
                    let price = listing["price"] as? String,
                    let link = listing["url"] as? String,
                    let url = URL(string: link) {
                    self.addCard(with: title, images: photos, link: url, price: price, koloda:
                    koloda)
                }
            }
            koloda.reloadData()
        }
        task.resume()
        /*
        for _ in 1...4 {
            let photoURL = URL(string: "https://www.profiletalent.com.au/wp-content/uploads/2017/05/profile-talent-ant-simpson-feature.jpg")!
            let title = "Stud"
            let price = CGFloat(4.2)
            let url = URL(string: "https://example.com")!
            self.addCard(with: title, image: photoURL, link: url, price: price, koloda: koloda)
        }
        koloda.reloadData()
        */
    }
    
    func addCard(with name: String, images: [String], link: URL, price: String, koloda: KolodaView) {
        let card = CardView(frame: koloda.bounds)
        card.setImages(images: images)
        card.setName(name: name)
        card.setPrice(price: price)
        card.shoppingURL = link
        cards.append(card)
        
    }
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return cards.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return cards[index]
    }
}
