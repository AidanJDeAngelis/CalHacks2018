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
    
    func pullEbay(_ koloda: KolodaView, search_term : String, max_entries: Integer) {
        
        // Given a search term, this function will call the eBay findItemsByKeywords API and return a list of Dictionaries for item that showed up in the eBay search for the search term. The list will have a capacity of max_entries.
        
        guard let new_search_term = search_term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            print("Faulty search term")
            return }
        
        let url_string =
        "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=JackCoyl-calhacks-PRD-2c22b8256-e74d7737&RESPONSE-DATA-FORMAT=JSON&keywords=\(new_search_term)&paginationInput.entriesPerPage=\(max_entries)"
        
        let url = URL(string: url_string)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard (error == nil), let data = data, let listings = try? JSONSerialization.jsonObject(with: data) as! Dictionary<String, [Dictionary<String, [Any]>]> else {
                print("Failed to get eBay listings")
                return
            }
            
            guard let items_listing = listings["findItemsByKeywordsResponse"], let searchResult = (items_listing[0]["searchResult"] as? [Dictionary<String, Any>]), let products: [Dictionary<String, Any>] = searchResult[0]["item"] as? [Dictionary<String, Any>] else {
                print("error getting products")
                return
            }
            
            var items: [Dictionary<String, Any>] = []
            
            for product in products {
                
                var dict: [String: Any] = [:]
                if let title_arr = product["title"] as? Array<Any>, let title = title_arr.first {
                    dict["item_title"] = title
                } else {
                    dict["item_title"] = "Not available"
                }
                
                if let pic_url_arr = product["galleryURL"] as? Array<Any>, let pic_url = pic_url_arr.first {
                    dict["photo_url"] = pic_url
                } else {
                    dict["photo_url"] = "Not available"
                }
                
                if let listing_url_arr = product["viewItemURL"] as? Array<Any>, let listing_url = listing_url_arr.first {
                    dict["listing_url"] = listing_url
                } else {
                    dict["listing_url"] = "Not available"
                }
                
                if let zipcode_arr = product["postalCode"] as? Array<Any>, let zipcode = zipcode_arr.first {
                    dict["zipcode"] = zipcode
                } else {
                    dict["zipcode"] = "Not available"
                }
                
                if let sellingStatus = product["sellingStatus"] as? Array<Any>, let status = sellingStatus.first as? Dictionary<String, Any>, let currentPrice = status["currentPrice"] as? Array<Any>, let priceDict = currentPrice.first as? Dictionary<String, Any>, let price = priceDict["__value__"] as? String {
                    dict["price"] = price
                } else {
                    print("price error")
                }
                items.append(dict)
            }
            print(items)
        }
        task.resume()
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
