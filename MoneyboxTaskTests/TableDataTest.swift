//
//  File.swift
//  MoneyboxTaskTests
//
//  Created by Radu Mitrea on 13/10/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import Foundation
import XCTest

@testable import MoneyboxTask

class TableDataTest: XCTestCase {
    
    func testTableData() {
    
        let tableData = TableViewCellData(accountName: "General Investment Account", planValue: "￡102", moneyboxValue: "￡233")
        XCTAssertTrue(tableData.accountName.count > 0)
    }
}
