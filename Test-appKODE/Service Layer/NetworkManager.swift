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
    
    func fetchEmployeeAvatar(from url: String) async -> UIImage? {
        guard let url = URL(string: url) else { return nil }
        
        do {
            let data = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data.0) else { return nil }
            return image
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
