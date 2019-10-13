//
//  AccountsViewController.swift
//  MoneyboxTask
//
//  Created by Radu Mitrea on 10/10/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import UIKit

class AccountsTableViewController: UIViewController {
      
    @IBOutlet weak var totalPlanLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tableData = [TableViewCellData]()
    
    var totalPlanValue = String()
    var name = String()
    var accountsIdList = [String]()
    
    var accountName = String()
    var accountPlanValue = String()
    var accountMoneybox = String()
    var accountId = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.totalPlanLabel.text = "Total Plan Value: ￡\(self.totalPlanValue)"
        self.nameLabel.text = "Hello \(name)!"
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAccount"
        {
            if let destinationVC = segue.destination as? AccountViewController {
                
                destinationVC.accountName = self.accountName
                destinationVC.accountPlanValue = self.accountPlanValue
                destinationVC.accountMoneybox = self.accountMoneybox
                destinationVC.accountId = self.accountId
            }
        }
    }
    
}

extension AccountsTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountsTableCell", for: indexPath) as! AccountsTableViewCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
        cell.accountNameLabel.text = tableData[indexPath.row].accountName
        cell.planValueLabel.text = tableData[indexPath.row].planValue
        cell.moneyboxValueLabel.text = tableData[indexPath.row].moneyboxValue

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            accountName = tableData[indexPath.row].accountName
            accountPlanValue = tableData[indexPath.row].planValue
            accountMoneybox = tableData[indexPath.row].moneyboxValue
            accountId = accountsIdList[0]
        }
        if indexPath.row == 1 {
            accountName = tableData[indexPath.row].accountName
            accountPlanValue = tableData[indexPath.row].planValue
            accountMoneybox = tableData[indexPath.row].moneyboxValue
            accountId = accountsIdList[1]

        }
        if indexPath.row == 2 {
            accountName = tableData[indexPath.row].accountName
            accountPlanValue = tableData[indexPath.row].planValue
            accountMoneybox = tableData[indexPath.row].moneyboxValue
            accountId = accountsIdList[2]

        }
        performSegue(withIdentifier: "goToAccount", sender: self)

        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    
}

