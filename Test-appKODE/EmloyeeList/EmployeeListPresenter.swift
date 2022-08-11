//
//  EmployeeListPresenter.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 10.08.2022.
//

import Foundation

protocol EmploeeListPresenterProtocol: AnyObject {
    init(view: EmployeeListTableViewProtocol)
    func fetachEmployeeData()
}

class EmploeeListPresenter: EmploeeListPresenterProtocol {
    unowned let view: EmployeeListTableViewProtocol
    
    required init(view: EmployeeListTableViewProtocol) {
        self.view = view
    }
    
   @MainActor func fetachEmployeeData(){
       Task {
           sleep(2)
           let employees = await NetworkManager.shared.fetchEmployeeData(
                   from: "https://stoplight.io/mocks/kode-education/trainee-test/25143926/users"
               )
           view.refreshEmployeeList(with: employees)
       }
       print("Hello")
    }
}

