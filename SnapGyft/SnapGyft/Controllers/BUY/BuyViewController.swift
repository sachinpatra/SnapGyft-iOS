//
//  BuyViewController.swift
//  SnapGyft
//
//  Created by Sachin Kumar Patra on 1/6/18.
//  Copyright © 2018 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class BuyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var buyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //MARK: - UITableView Deatasource    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as UITableViewCell!
        
        switch indexPath.row {
        case 0:
            cell?.imageView?.image = #imageLiteral(resourceName: "Resto1")
            cell?.textLabel?.text = "Chill Restaurant"
            cell?.detailTextLabel?.text = "$25 - $250"
        case 1:
            cell?.imageView?.image = #imageLiteral(resourceName: "Resto2")
            cell?.textLabel?.text = "Grill Menu Restaurant"
            cell?.detailTextLabel?.text = "$10 - $200"
        case 2:
            cell?.imageView?.image = #imageLiteral(resourceName: "Resto3")
            cell?.textLabel?.text = "Piccolo Restaurant"
            cell?.detailTextLabel?.text = "$5 - $400"
        case 3:
            cell?.imageView?.image = #imageLiteral(resourceName: "Resto4")
            cell?.textLabel?.text = "Risotto Italian Restaurant"
            cell?.detailTextLabel?.text = "$5 - $100"
        case 4:
            cell?.imageView?.image = #imageLiteral(resourceName: "Resto5")
            cell?.textLabel?.text = "Papito Italio"
            cell?.detailTextLabel?.text = "$20 - $500"
        default:
            break
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    //MARK: - Searchbar Delegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! SelectAmountTableController
        switch self.buyTableView.indexPathForSelectedRow?.row {
        case 0?:
            VC.cardLabel = "Chill Restaurant"
            VC.logoImage = #imageLiteral(resourceName: "Resto1")
        case 1?:
            VC.cardLabel = "Grill Menu Restaurant"
            VC.logoImage = #imageLiteral(resourceName: "Resto2")
        case 2?:
            VC.cardLabel = "Piccolo Restaurant"
            VC.logoImage = #imageLiteral(resourceName: "Resto3")
        case 3?:
            VC.cardLabel = "Risotto Italian Restaurant"
            VC.logoImage = #imageLiteral(resourceName: "Resto4")
        case 4?:
            VC.cardLabel = "Papito Italio"
            VC.logoImage = #imageLiteral(resourceName: "Resto5")
        default:
            break
        }
         
        self.buyTableView.deselectRow(at: self.buyTableView.indexPathForSelectedRow!, animated: true)

    }

}
