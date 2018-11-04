//
//  ViewController.swift
//  Shopper
//
//  Created by Milo Darling on 11/2/18.
//  Copyright © 2018 Milo Darling. All rights reserved.
//

import UIKit
import Koloda

let category_names: [String] = ["all",
"antiques",
"appliances",
"arts+crafts",
"atvs/utvs/snow",
"auto parts",
"baby+kids",
"barter",
"beauty+hlth",
"bike parts",
"bikes",
"boat parts",
"boats",
"books",
"business",
"cars+trucks",
"cds/dvd/vhs",
"cell phones",
"clothes+acc",
"collectibles",
"computer parts",
"computers",
"electronics",
"farm+garden",
"free stuff",
"furniture",
"garage sales",
"general",
"heavy equipment",
"household",
"jewelry",
"materials",
"motorcycle parts",
"motorcycles",
"music instr",
"photo+video",
"RVs",
"sporting",
"tickets",
"tools",
"toys+games",
"video gaming",
"wanted"]
let category_codes: [String] = ["sss",
"ata",
"ppa",
"ara",
"sna",
"pta",
"baa",
"bar",
"haa",
"bip",
"bia",
"bpa",
"boo",
"bka",
"bfa",
"cta",
"ema",
"moa",
"cla",
"cba",
"syp",
"sya",
"ela",
"gra",
"zip",
"fua",
"gms",
"foa",
"hva",
"hsa",
"jwa",
"maa",
"mpa",
"mca",
"msa",
"pha",
"rva",
"sga",
"tia",
"tla",
"taa",
"vga",
"waa"]

class ViewController: UIViewController {
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var LikeButton: UIButton!
    
    var kolodaDataSource = ShoppingDataSource()
    var kolodaDelegate = ShoppingDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self.kolodaDataSource
        kolodaView.delegate = self.kolodaDelegate
        
        self.kolodaDataSource.pullCraigslist(self.kolodaView)
        
        dislikeButton.setImage(UIImage(named : "Broken Heart Unclicked"), for: .normal)
    }
    @IBAction func dislikeButtonPressed(_ sender: Any) {
        kolodaView.swipe(.left)
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        kolodaView.swipe(.right)
    }
}

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category_names.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category_names[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("saving \(category_codes[row])")
        UserDefaults.standard.set(category_codes[row], forKey:"category")
    }
}

extension CATransition {
    
    //New viewController will appear from bottom of screen.
    func segueFromBottom() -> CATransition {
        self.duration = 0.375 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromTop
        return self
    }
    //New viewController will appear from top of screen.
    func segueFromTop() -> CATransition {
        self.duration = 0.375 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromBottom
        return self
    }
    //New viewController will appear from left side of screen.
    func segueFromLeft() -> CATransition {
        self.duration = 0.1 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromLeft
        return self
    }
    //New viewController will pop from right side of screen.
    func popFromRight() -> CATransition {
        self.duration = 0.1 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.reveal
        self.subtype = CATransitionSubtype.fromRight
        return self
    }
    //New viewController will appear from left side of screen.
    func popFromLeft() -> CATransition {
        self.duration = 0.1 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.reveal
        self.subtype = CATransitionSubtype.fromLeft
        return self
    }
}
