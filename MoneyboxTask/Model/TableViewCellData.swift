//
//  TableViewCellData.swift
//  MoneyboxTask
//
//  Created by Radu Mitrea on 10/10/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import Foundation
import UIKit

struct TableViewCellData: Decodable {
    var accountName: String
    var planValue: String
    var moneyboxValue: String
}
