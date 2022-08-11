//
//  NetworkManager.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 10.08.2022.
//

import Foundation

final class NetworkManager {
    static var shared = NetworkManager()
    
    private init() {}
    
    func fetchEmployeeData(from url: String) async -> [Employee] {
        guard let url = URL(string: url) else { return [] }
        
        do {
            let data = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Items.self, from: data.0)
            let employees = items.items.map { $0 }
            
            return employees
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
