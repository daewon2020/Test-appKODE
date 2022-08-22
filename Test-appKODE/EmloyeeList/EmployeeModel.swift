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
    
    var age: String? {
        let calendar = Calendar.current
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "Y-M-d"
        formatter.timeZone = TimeZone.current
        if let date = formatter.date(from: birthday) {
            let ageComponents = calendar.dateComponents([.year], from: date, to: currentDate )
            guard let year = ageComponents.year else { return nil}
            return getAgeString(from: year)
        }
        return nil
    }
    
    var birthdayFull: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "Y-M-d"
        formatter.timeZone = TimeZone.current
        if let date = formatter.date(from: birthday) {
            formatter.dateFormat = "d MMMM YYYY"
            return formatter.string(from: date)
        }
        return nil
    }
    
    var fullName: String {
        firstName + " " + lastName
    }
    
    private func getAgeString(from age: Int) -> String {
        let remainder = age % 10
        switch remainder {
        case 0,5,6,7,8,9:
            return String(age) + " лет"
        case 2,3,4:
            return String(age) + " года"
        case 1:
            return String(age) + " год"
        default:
            return String(age)
        }
    }
}
