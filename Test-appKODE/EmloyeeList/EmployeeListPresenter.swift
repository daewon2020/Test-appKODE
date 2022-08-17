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
    var sorting: SortList { get set }
    var isFiltered: Bool { get set }
    func fetchEmployeeData()
    func showEmployeeList(filteredBy text: String?)
    func viewDidLoad()
}

class EmploeeListPresenter: EmploeeListPresenterProtocol {
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
            employeesFiltered.forEach { emploee in
                section.rows.append(TableViewCellModel(employess: emploee, sorting: sorting))
                let tableViewCellDodel = TableViewCellModel(employess: emploee, sorting: sorting)
                if let year = getYearFromString(birtday: emploee.birthday) {
                    if let index = section.sectionTitles[year] {
                        section.rowsInSection[index].append(tableViewCellDodel)
                    } else {
                        section.sectionTitles[year] = section.sectionTitles.count
                        section.rowsInSection.append([TableViewCellModelProtocol]())
                        section.rowsInSection[section.sectionTitles.count - 1].append(tableViewCellDodel)
                    }
                }
            }
            
        } else {
            isFiltered = false
            employees.forEach { emploee in
                let tableViewCellModel = TableViewCellModel(employess: emploee, sorting: sorting)
                section.rows.append(tableViewCellModel)
                if let year = getYearFromString(birtday: emploee.birthday) {
                    if let index = section.sectionTitles[year] {
                        section.rowsInSection[index].append(tableViewCellModel)
                    } else {
                        section.sectionTitles[year] = section.sectionTitles.count
                        section.rowsInSection.append([TableViewCellModelProtocol]())
                        section.rowsInSection[section.sectionTitles.count - 1].append(tableViewCellModel)
                    }
                }
            }
            
            if sorting == .name{
                let sortedSection = section.rows.sorted(
                    by: { $0.employee.fullName < $1.employee.fullName }
                )
                section.rows = sortedSection
            }
        }
        
        view.reloadEmployeeListFiltered(for: section)
    }
    
    func fetchEmployeeData() {
        clearData()
        Task {
            let section = SectionCellViewModel()
            
            
            employees = await NetworkManager.shared.fetchEmployeeData(from: url)
            employees.forEach { emploee in
                let tableViewCellDodel = TableViewCellModel(employess: emploee, sorting: sorting)
                section.rows.append(tableViewCellDodel)
                if let year = getYearFromString(birtday: emploee.birthday) {
                    if let index = section.sectionTitles[year] {
                        section.rowsInSection[index].append(tableViewCellDodel)
                    } else {
                        section.sectionTitles[year] = section.sectionTitles.count
                        section.rowsInSection.append([TableViewCellModelProtocol]())
                        section.rowsInSection[section.sectionTitles.count - 1].append(tableViewCellDodel)
                    }
                }
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

extension EmploeeListPresenter {
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
}
