//
//  UserService.swift
//  MoneyboxTask
//
//  Created by Radu Mitrea on 10/10/2019.
//  Copyright © 2019 Radu Mitrea. All rights reserved.
//

import Foundation

import Foundation
import Moya

public enum Account {
    static private let appID = "3a97b932a9d449c981b595"
    static private let contentType = "application/json"
    static private let appVersion = "5.10.0"
    static private let apiVersion = "3.0.0"
    
    
    case login(email: String, password: String, name: String)
    case account
    case payment(amount: String, id: String)
}

extension Account: TargetType, AccessTokenAuthorizable {
    
    public var baseURL: URL {
        return URL(string: "https://api-test01.moneyboxapp.com/")!
    }
    
    public var path: String {
        switch self {
        case .login: return "/users/login"
        case .account: return "/investorproducts"
        case .payment: return "/oneoffpayments"
            
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login: return .post
        case .payment: return .post
        case .account: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        
        switch self {
        case .account:
            return .requestPlain
            
        case let .login(email, password, name):
            return .requestParameters(parameters: ["Email": email, "Password": password, "Idfa": name], encoding: JSONEncoding.default)
            
        case let .payment(amount, id):
            return .requestParameters(parameters: ["Amount": amount, "InvestorProductId": id ], encoding: JSONEncoding.default)
        }
        
    }
    
    public var headers: [String: String]? {
        return [
            
            "AppId": "3a97b932a9d449c981b595",
            "Content-Type": "application/json",
            "appVersion": "5.10.0",
            "apiVersion": "3.0.0"
            
        ]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    public var authorizationType: AuthorizationType {
        switch self {
        case .login:
            return .none
            
        default:
            return .bearer
        }
    }
}
