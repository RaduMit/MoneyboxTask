//
//  AccountsTableViewCell.swift
//  MoneyboxTask
//
//  Created by Radu Mitrea on 10/10/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import UIKit

class AccountsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var planValueLabel: UILabel!
    @IBOutlet weak var moneyboxValueLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBg.layer.borderColor = UIColor.lightGray.cgColor
        viewBg.layer.borderWidth = 1
        viewBg.layer.masksToBounds = true
        viewBg.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
    }

}
