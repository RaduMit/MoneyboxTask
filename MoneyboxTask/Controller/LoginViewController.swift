//
//  ViewController.swift
//  MoneyboxTask
//
//  Created by Radu Mitrea on 10/10/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON


var authToken: String? {
    get {
        return UserDefaults.standard.string(forKey: "Authorization")
    }
    set {
        if newValue == nil {
            UserDefaults.standard.removeObject(forKey: "Authorization")
        } else {
            UserDefaults.standard.set(newValue, forKey: "Authorization")
            
        }
        UserDefaults.standard.synchronize()
    }
}

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    fileprivate var provider = MoyaProvider<Account>(plugins:
        [AccessTokenPlugin(tokenClosure: { () -> String in
            return authToken ?? ""
        })]
    )
    
    var accountsNameList = [String]()
    var accountsPlanValueList = [String]()
    var accountsMoneyboxValueList = [String]()
    var accountsIdList = [String]()
    
    var totalPlanValue = String()
    var specificEmail = String()
    var specificPassword = String()
    var specificName = String()
    
    var tableData = [TableViewCellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        loginButton.layer.borderWidth = 1
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self

        appendAccountInfo()
    }
    
    func appendAccountInfo() {
        specificEmail = "androidtest@moneyboxapp.com"
        specificPassword = "P455word12"
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let name = nameTextField.text else { return }
        if name == "" {
            specificName = "Nobody"
        } else {
            specificName = name
        }
        loginButton.isEnabled = false

        login(email: email, password: password, name: specificName) { (success, errorMessage) in
//        login(email: specificEmail, password: specificPassword, name: specificName) { (success, errorMessage) in
            if success == true {
                print("login success")
                self.loginButton.isEnabled = true

            } else {
                print(errorMessage ?? "")
                self.loginButton.isEnabled = true

            }
        }
    }
    
    func login(email: String, password: String, name: String, completion: @escaping (_ successMsg: Bool?, _ errorMsg: String?) -> Void) {
        
        self.provider.request(.login(email: email, password: password, name: name)) { result in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    
                    let responseJson = try JSON(data: data)
                    print("//// Login Response")
                    print(responseJson)

                    let token = responseJson["Session"]["BearerToken"].stringValue
                    authToken = token
                    self.getAccountsInfo(completion: { (success, errorMessage) in
                        if success == true {
                            print("get account info success")
                        } else {
                            print(errorMessage ?? "")
                        }
                    })
                    completion(true, nil)
                } catch {
                    completion(false, "Error occured while logging in")
                }
            case . failure(let error):
                completion(false, "\(String(describing: error.errorDescription))")
                guard let error = error.errorDescription else { return }
                self.displayErrorAlert(with: error)
            }
        }
    }
    
    func getAccountsInfo(completion: @escaping (_ successMsg: Bool?, _ errorMsg: String?) -> Void) {
        self.provider.request(.account) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                
                do {
                    
                    let responseJson = try JSON(data: data)
                    print("//// Account Info Response")

                    print(responseJson)
                    self.totalPlanValue = responseJson["TotalPlanValue"].stringValue
                    
                    var productResponseValues = responseJson["ProductResponses"]
                    
                    for item in 0..<productResponseValues.count {
                        let itemsMoneybox = productResponseValues[item]["Moneybox"].stringValue
                        self.accountsMoneyboxValueList.append("Moneybox: ￡\(itemsMoneybox)")
                    }
                    
                    for item in 0..<productResponseValues.count {
                        let itemsPlanValue = productResponseValues[item]["PlanValue"].stringValue
                        self.accountsPlanValueList.append("Plan Value: ￡\(itemsPlanValue)")
                    }
                    
                    
                    for item in 0..<productResponseValues.count {
                        let itemsPlanValue = productResponseValues[item]["Product"]["Id"].stringValue
                        self.accountsIdList.append(itemsPlanValue)
                    }
                    
                    for item in 0..<productResponseValues.count {
                        let itemsName = productResponseValues[item]["Product"]["FriendlyName"].stringValue
                        self.accountsNameList.append(itemsName)
                    }
                    
                    self.createTableViewData()
                    self.performSegue(withIdentifier: "goToAccountsList", sender: self)
                    
                    completion(true, nil)

                } catch {
                    completion(false, "Error occured while getting the accounts info")

                }
            case .failure(let error):
                completion(false, "\(String(describing: error.errorDescription))")
            }
        }
    }
    
    
    func createTableViewData() {

        for item in 0..<accountsNameList.count {
            tableData.append(TableViewCellData(accountName: accountsNameList[item], planValue: accountsPlanValueList[item], moneyboxValue: accountsMoneyboxValueList[item]))
        }

    }
    
    func displayErrorAlert(with error: String) {
        let alert = UIAlertController(title: "Login Error", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAccountsList"
        {
            if let destinationVC = segue.destination as? AccountsTableViewController {
                
                destinationVC.totalPlanValue = self.totalPlanValue
                destinationVC.name = self.specificName
                destinationVC.accountsIdList = self.accountsIdList
                destinationVC.tableData = tableData
            }
        }
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

