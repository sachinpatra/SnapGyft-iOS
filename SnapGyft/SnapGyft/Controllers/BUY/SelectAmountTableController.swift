//
//  SelectAmountTableController.swift
//  SnapGyft
//
//  Created by Sachin Kumar Patra on 1/6/18.
//  Copyright © 2018 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class SelectAmountTableController: UITableViewController {
    
    var logoImage: UIImage!
    var cardLabel: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String!
        switch indexPath.row {
        case 0:
            let firstcell =  tableView.dequeueReusableCell(withIdentifier: "cardCellIdentifier", for: indexPath) as! SelectAmountCardTableCell
            firstcell.textLabel?.text = cardLabel
            firstcell.logoImageView.image = logoImage
            return firstcell
        case 1:
            cellIdentifier = "BuyCellIdentifier"
        case 2:
            cellIdentifier = "descriptionCellIdentifier"
        default:
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 250
        case 1:
            return 60
        case 2:
            return 150
        default:
            break
        }
        return 44.0
    }

}
