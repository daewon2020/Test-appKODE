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
    func getEmployeeCount() -> Int
    func getEmployee(for indexPath: IndexPath) -> Employee?
}

class EmploeeListPresenter: EmploeeListPresenterProtocol {
    unowned let view: EmployeeListTableViewProtocol
    
    required init(view: EmployeeListTableViewProtocol) {
        self.view = view
    }
    
    func getEmployeeCount() -> Int {
        DataManager.shared.employees.count
    }
    
    func getEmployee(for indexPath: IndexPath) -> Employee? {
        getEmployeeCount() == 0 ? nil : DataManager.shared.employees[indexPath.row]
    }
    
   @MainActor func fetachEmployeeData(){
       DataManager.shared.clearData()
       Task {
           sleep(2)
           await DataManager.shared.fetchEmploees()
           view.refreshEmployeeList()
       }
    }
}

