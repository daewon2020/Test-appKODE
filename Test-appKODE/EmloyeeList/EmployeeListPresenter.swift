//
//  EmployeeListPresenter.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 10.08.2022.
//

import Foundation
import UIKit

protocol employeeListPresenterProtocol: AnyObject {
    init(view: EmployeeListTableViewProtocol)
    var sorting: SortList { get set }
    var isFiltered: Bool { get set }
    func fetchEmployeeData()
    func showEmployeeList(filteredBy text: String?)
    func viewDidLoad()
}

class employeeListPresenter: employeeListPresenterProtocol {
    unowned let view: EmployeeListTableViewProtocol
    
    private let url = "https://stoplight.io/mocks/kode-education/trainee-test/25143926/users"
    private var employees = [Employee]()
    private var employeesFiltered = [Employee]()
    
    var sorting = SortList.name
    var isFiltered = false
    
    required init(view: EmployeeListTableViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchEmployeeData()
    }
    
    func showEmployeeList(filteredBy text: String?) {
        let section = SectionCellViewModel()
        
        if let text = text {
            isFiltered = true
            employeesFiltered = employees.filter { $0.fullName.lowercased().contains(text) }
            employeesFiltered.forEach { employee in
                section.rows.append(TableViewCellModel(employess: employee, sorting: sorting))
                setDataForBithdaySorting(for: employee, in: section)
            }
            
        } else {
            isFiltered = false
            employees.forEach { employee in
                section.rows.append(TableViewCellModel(employess: employee, sorting: sorting))
                setDataForBithdaySorting(for: employee, in: section)
            }
        }
        
        if sorting == .name{
            let sortedSection = section.rows.sorted(
                by: { $0.employee.fullName < $1.employee.fullName }
            )
            section.rows = sortedSection
        }
        
        view.reloadEmployeeListFiltered(for: section)
    }
    
    func fetchEmployeeData() {
        clearData()
        Task {
            let section = SectionCellViewModel()
            
            employees = await NetworkManager.shared.fetchEmployeeData(from: url)
            employees.forEach { employee in
                section.rows.append(TableViewCellModel(employess: employee, sorting: sorting))
                setDataForBithdaySorting(for: employee, in: section)
            }
            print(section.sectionTitles)
            await MainActor.run {
                switch sorting {
                case .name:
                    let sortedSection = section.rows.sorted(
                        by: { $0.employee.fullName < $1.employee.fullName }
                    )
                    section.rows = sortedSection
                case .birthday:
                    
                    print("hello")
                }
                
                view.reloadEmployeeList(for: section)
            }
        }
    }
}

//MARK: - private func

extension employeeListPresenter {
    private func clearData() {
        employees.removeAll()
        //sorting = .name
        //isFiltered = false
        ImageLoader.shared.clearCache()
    }
    
    private func getYearFromString(birtday: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "YYYY-MM-DD"
        if let date = formatter.date(from: birtday) {
            formatter.dateFormat = "YYYY"
            return Int(formatter.string(from: date))
        }
        return nil
    }
    
    private func setDataForBithdaySorting(for employee: Employee, in section: SectionCellViewModel) {
        let tableViewCellModel = TableViewCellModel(employess: employee, sorting: sorting)
        if let year = getYearFromString(birtday: employee.birthday) {
            if let index = section.sectionTitles[year] {
                section.rowsInSection[index].append(tableViewCellModel)
            } else {
                section.sectionTitles[year] = section.sectionTitles.count
                section.rowsInSection.append([TableViewCellModelProtocol]())
                section.rowsInSection[section.sectionTitles.count - 1].append(tableViewCellModel)
            }
        }
    }
}
