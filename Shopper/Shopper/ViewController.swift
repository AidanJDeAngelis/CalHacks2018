//
//  ViewController.swift
//  Shopper
//
//  Created by Milo Darling on 11/2/18.
//  Copyright © 2018 Milo Darling. All rights reserved.
//

import UIKit
import Koloda

class ViewController: UIViewController {
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var buttonView: UIView!
    
    var kolodaDataSource = ShoppingDataSource()
    var kolodaDelegate = ShoppingDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addSubview(buttonView)
        kolodaView.dataSource = self.kolodaDataSource
        kolodaView.delegate = self.kolodaDelegate
        
        self.kolodaDataSource.pullCraigslist(self.kolodaView)
    }
    @IBAction func dislikeButtonPressed(_ sender: Any) {
        kolodaView.swipe(.left)
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        kolodaView.swipe(.right)
    }
    @IBAction func showFiends(_ sender: Any) {
        
    }
}

