//
//  DataManager.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 11.08.2022.
//

import Foundation
import UIKit

class DataManager {
    static var shared = DataManager()
    
    let url = "https://stoplight.io/mocks/kode-education/trainee-test/25143926/users"
    let avatarUrl = "https://avatar-endpoint.herokuapp.com/api/"
    
    private(set) var employees = [Employee]()
    private(set) var avatars: NSCache<NSString, UIImage> = NSCache()
    
    init() {}
    
    func fetchEmploees() async {
        employees = await NetworkManager.shared.fetchEmployeeData(from: url)
    }
    
    func getEmploeeAvatar(from employeeID: String) async -> UIImage? {
        if let avatar =  avatars.object(forKey: employeeID as NSString) {
            return avatar
        } else {
            if let avatar = await NetworkManager.shared.fetchEmployeeAvatar(from: avatarUrl) {
                avatars.setObject(avatar, forKey: employeeID as NSString)
                print("New avatar loaded: \(employeeID)")
                return avatar
                
            }
        }
        return nil
    }
}
