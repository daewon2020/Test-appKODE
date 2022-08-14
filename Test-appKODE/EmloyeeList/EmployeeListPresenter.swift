//
//  EmployeeListPresenter.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 10.08.2022.
//

import Foundation
import UIKit

protocol EmploeeListPresenterProtocol: AnyObject {
    init(view: EmployeeListTableViewProtocol)
    func fetchEmployeeData()
    func showEmployeeListFiltered(for text: String)
    func showEmployeeListWithoutFilter()
    func viewDidLoad()
}

class EmploeeListPresenter: EmploeeListPresenterProtocol {
    unowned let view: EmployeeListTableViewProtocol
    
    private let url = "https://stoplight.io/mocks/kode-education/trainee-test/25143926/users"
    private var employees = [Employee]()
    private var employeesFiltered = [Employee]()
    
    required init(view: EmployeeListTableViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchEmployeeData()
    }
    
    func showEmployeeListWithoutFilter() {
        let section = SectionCellViewModel()
        employees.forEach { emploee in
            section.rows.append(TableViewCellModel(employess: emploee))
        }
        view.reloadEmployeeList(for: section)
    }
    
    func showEmployeeListFiltered(for text: String) {
        let section = SectionCellViewModel()
        employeesFiltered = employees.filter { $0.fullName.lowercased().contains(text) }
        print(employeesFiltered.count)
        employeesFiltered.forEach { emploee in
            section.rows.append(TableViewCellModel(employess: emploee))
        }
        view.reloadEmployeeListSorted(for: section)
    }
    
    func fetchEmployeeData() {
        clearData()
        Task {
            let section = SectionCellViewModel()
            
            employees = await NetworkManager.shared.fetchEmployeeData(from: url)
            employees.forEach { emploee in
                section.rows.append(TableViewCellModel(employess: emploee))
            }
            await MainActor.run {
                view.reloadEmployeeList(for: section)
            }
        }
    }
}

//MARK: - private func

extension EmploeeListPresenter {
    private func clearData() {
        employees.removeAll()
        ImageLoader.shared.clearCache()
    }
}

