//
//  EmployeeModel.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 10.08.2022.
//

import Foundation

struct Items: Decodable {
    let items: [Employee]
}

struct Employee: Decodable {
    let id: String
    let avatarUrl: String
    let firstName: String
    let lastName: String
    let userTag: String
    let department: String
    let position: String
    let birthday: String
    let phone: String
    
    var fullName: String {
        firstName + " " + lastName
    }
}
