//
//  NetworkManager.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 10.08.2022.
//

import Foundation
import UIKit

final class NetworkManager {
    static var shared = NetworkManager()
    
    private init() {}
    
    func fetchEmployeeData(from url: String) async -> [Employee] {
        guard let url = URL(string: url) else { return [] }
        var request = URLRequest(url: url)
        request.addValue("dynamic=true", forHTTPHeaderField: "Prefer")
        //request.addValue("example=success", forHTTPHeaderField: "Prefer")
        
        do {
            let data = try await URLSession.shared.data(for: request)
            let items = try JSONDecoder().decode(Items.self, from: data.0)
            let employees = items.items.map { $0 }
            
            return employees
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchEmployeeAvatar(from url: String) async -> Data? {
        guard let url = URL(string: url) else { return nil }
        
        do {
            return try await URLSession.shared.data(from: url).0
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
