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
           await DataManager.shared.fetchEmploees()
           view.refreshEmployeeList()
       }
    }
}

