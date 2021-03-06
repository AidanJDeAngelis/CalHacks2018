//
//  FiendTableViewController.swift
//  Shopper
//
//  Created by Milo Darling on 11/3/18.
//  Copyright © 2018 Milo Darling. All rights reserved.
//

import UIKit
import SafariServices

class FiendTableViewController: UITableViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let fiends = UserDefaults.standard.object(forKey:"fiends") as? Array<Any> else {
            print("no fiends!")
            return 0
        }
        return fiends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FIEND", for: indexPath)

        if let fiends = UserDefaults.standard.object(forKey:"fiends") as? Array<Dictionary<String, Any>>,
            let item = fiends[(fiends.count - 1) - indexPath.row]["item"] as? String {
            cell.textLabel?.text = item
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let fiends: Array<Dictionary<String, Any>> = UserDefaults.standard.object(forKey: "fiends") as? Array<Dictionary<String, Any>>, let link = URL(string: fiends[(fiends.count - 1) - indexPath.row]["url"] as! String) else {
            print("no fiend to launch")
            return
        }
        let vc = SFSafariViewController(url: link)
        vc.delegate = self
        self.present(vc, animated: true)
        
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard var fiends: Array<Dictionary<String, Any>> = UserDefaults.standard.object(forKey: "fiends") as? Array<Dictionary<String, Any>> else {
                return
            }
            fiends.remove(at: (fiends.count - 1) - indexPath.row)
            UserDefaults.standard.set(fiends, forKey:"fiends")
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
