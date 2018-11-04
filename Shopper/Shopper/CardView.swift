//
//  CardView.swift
//  Shopper
//
//  Created by Milo Darling on 11/2/18./Users/milodarling/Documents/Shopper/Shopper/CardView.xib
//  Copyright © 2018 Milo Darling. All rights reserved.
//

import UIKit

class CardView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var shoppingURL: URL?
    var imageURL: URL?
    var price: CGFloat?
    var item: String?
    
    func setImageURL(url: URL) {
        imageView.setImageWithURL(url: url, placeholder: UIImage(named: "placeholder"))
        self.imageURL = url
    }
    
    func setName(name: String) {
        self.item = name
        itemLabel.text = name
    }
    
    func setPrice(price: CGFloat) {
        self.price = price
        priceLabel.text = String(format: "$%.2f", price)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension UIImageView {
    func setImageWithURL(url: URL, placeholder: UIImage?) {
        contentMode = .scaleAspectFill
        if let placeholder = placeholder {
            self.image = placeholder
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}

