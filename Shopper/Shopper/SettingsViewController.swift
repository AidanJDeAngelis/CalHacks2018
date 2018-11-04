//
//  SettingsViewController.swift
//  Shopper
//
//  Created by Milo Darling on 11/4/18.
//  Copyright © 2018 Milo Darling. All rights reserved.
//

import UIKit

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

class SettingsViewController: UIViewController {
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        if let code = UserDefaults.standard.string(forKey: "category"), let index = category_codes.firstIndex(of: code) {
            self.categoryPicker.selectRow(index, inComponent: 0, animated: false)
        }
        
        if let city = UserDefaults.standard.string(forKey: "city") {
            cityTextField.text = city
        }

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true) {
            print("dismissed")
        }
    }
    
    @IBAction func cityEntered(_ sender: UITextField) {
        if let text = sender.text {
            UserDefaults.standard.set(text, forKey:"city")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController : UIPickerViewDelegate, UIPickerViewDataSource {
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
