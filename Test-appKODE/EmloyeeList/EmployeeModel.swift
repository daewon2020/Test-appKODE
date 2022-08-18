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
    
    var birthdayShort: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "Y-M-d"
        formatter.timeZone = TimeZone.current
        if let date = formatter.date(from: birthday) {
            formatter.dateFormat = "d MMM"
            return formatter.string(from: date)
        }
        return nil
    }
    
    var fullName: String {
        firstName + " " + lastName
    }
}
