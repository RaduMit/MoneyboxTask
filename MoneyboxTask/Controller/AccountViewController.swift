//
//  AccountViewController.swift
//  MoneyboxTask
//
//  Created by Radu Mitrea on 10/10/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class AccountViewController: UIViewController {
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var planValueLabel: UILabel!
    @IBOutlet weak var moneyboxValueLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    fileprivate var provider = MoyaProvider<Account>(plugins:
        [AccessTokenPlugin(tokenClosure: { () -> String in
            return authToken ?? ""
        })]
    )
    
    var accountName = String()
    var accountPlanValue = String()
    var accountMoneybox = String()
    var accountId = String()
    
    var amountToAdd = "10"
        
    override func viewDidLoad() {
        super.viewDidLoad()

        accountNameLabel.text = accountName
        planValueLabel.text = accountPlanValue
        moneyboxValueLabel.text = accountMoneybox
        
        addButton.layer.borderColor = UIColor.lightGray.cgColor
        addButton.layer.borderWidth = 1
        
    }
    
    func postPayment(amount: String, id: String, completion: @escaping (_ successMsg: Bool?, _ errorMsg: String?) -> Void) {
        
        self.provider.request(.payment(amount: amount, id: id)) { result in
            switch result {
            case .success(let response):
                let data = response.data
                do {

                    let responseJson = try JSON(data: data)
                    print("//// Add amount Response")
                    print(responseJson)
                    let moneyboxAmountValue = responseJson["Moneybox"].stringValue

                    self.displayMoneyAlert(with: moneyboxAmountValue)
                    completion(true, nil)
                } catch {
                    completion(false, "Error occured while sending payments")
                }
            case . failure(let error):
                completion(false, "\(String(describing: error.errorDescription))")
                guard let error = error.errorDescription else { return }
                self.displayErrorAlert(with: error)
            }
        }
    }
    
    func displayErrorAlert(with error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayMoneyAlert(with amount: String) {
        let alert = UIAlertController(title: "Amount added succesfully!", message: "Your new amount is: ￡\(amount)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func addButtonTapped(_ sender: UIButton) {
        addButton.isEnabled = false
        postPayment(amount: amountToAdd, id: accountId) { (success, errorMessage) in
            if success == true {
                print("post amount success")
                self.addButton.isEnabled = true
            } else {
                print(errorMessage ?? "")
                self.addButton.isEnabled = true

            }
        }
        
    }
    
}
