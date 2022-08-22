//
//  EmployeeListPresenter.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 10.08.2022.
//

import Foundation
import UIKit

enum SortList {
    case name
    case birthday
}

enum Departament: String, CaseIterable {
    case all, android, ios, design, management, qa, back_office,frontend,hr
    case pr, backend, support, analytics
    
    var description: String {
        switch self {
        case .all:
            return "Все"
        case .android:
            return "Android"
        case .ios:
            return "iOS"
        case .design:
            return "Дизайн"
        case .management:
            return "Менеджмент"
        case .qa:
            return "QA"
        case .back_office:
            return"Бэк-офис"
        case .frontend:
            return "Frontend"
        case .hr:
            return "HR"
        case .pr:
            return "PR"
        case .backend:
            return "Backend"
        case .support:
            return "Техподдержка"
        case .analytics:
            return "Аналитика"
        }
    }
}

protocol employeeListPresenterProtocol: AnyObject {
    init(view: EmployeeListViewControllerProtocol)
    var sorting: SortList { get set }
    var isFiltered: Bool { get set }
    var selectedDepartament: Departament { get }
    var departaments: [String] { get }
    func fetchEmployeeData()
    func showEmployeeList(filteredBy text: String?)
    func viewDidLoad()
    func departamentCellDidTapped(at indexPath: IndexPath)
}

class employeeListPresenter: employeeListPresenterProtocol {
    unowned let view: EmployeeListViewControllerProtocol
    
    private let url = "https://stoplight.io/mocks/kode-education/trainee-test/25143926/users"
    private var employees = [Employee]()
    private var employeesFiltered = [Employee]()
    private var filterText: String? = nil
    
    var sorting = SortList.name
    var isFiltered = false

    var selectedDepartament = Departament.all
    var departaments = [String]()
    
    required init(view: EmployeeListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchEmployeeData()
    }
    
    func showEmployeeList(filteredBy text: String?) {
        var section = SectionCellViewModel()
        var employeesInDepartament = [Employee]()
        filterText = text
        
        employeesFiltered = employees
        
        if selectedDepartament != .all {
            employeesInDepartament = employeesFiltered.filter { $0.department == selectedDepartament.rawValue}
        } else {
            employeesInDepartament = employees
        }
            
        if let text = text {
            isFiltered = true
            employeesFiltered = employeesInDepartament.filter { $0.fullName.lowercased().contains(text) }
            section = getSection(from: employeesFiltered)
        } else {
            isFiltered = false
            section = getSection(from: employeesInDepartament)
            
        }
        
        if sorting == .name{
            let sortedSection = section.rows.sorted(
                by: { $0.employee.fullName < $1.employee.fullName }
            )
            section.rows = sortedSection
        }
        
        if section.rows.count == 0 {
            view.showFrendlyMessage()
        } else {
            view.reloadEmployeeListFiltered(for: section)
        }
    }
    
    func fetchEmployeeData() {
        clearData()
        Task {
            employees = await NetworkManager.shared.fetchEmployeeData(from: url)
            for departament in Departament.allCases {
                departaments.append(departament.description)
            }
            await MainActor.run {
                showEmployeeList(filteredBy: filterText)
                view.setDepartamentList(departaments)
            }
        }
    }
    
    func departamentCellDidTapped(at indexPath: IndexPath) {
        for departament in Departament.allCases {
            if  departament.description == departaments[indexPath.row] {
                selectedDepartament = departament
                showEmployeeList(filteredBy: filterText)
            }
        }
    }
}

//MARK: - private func

extension employeeListPresenter {
    private func clearData() {
        employees.removeAll()
        departaments.removeAll()
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
    
    private func getSection(from employees: [Employee]) -> SectionCellViewModel{
        let section =  SectionCellViewModel()
        
        employees.forEach { employee in
            section.rows.append(TableViewCellModel(employess: employee, sorting: sorting))
            setDataForBithdaySorting(for: employee, in: section)
        }
        
        let sortedSection = section.rows.sorted(
            by: { $0.employee.fullName < $1.employee.fullName }
        )
        section.rows = sortedSection
        
        return section
    }
    
    private func getFrendlyMessage() -> UIView {
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        let stackView = UIStackView()
        let mainLabel = UILabel()
        let subLabel = UILabel()
        if let image = UIImage(named: "magnifier") {
            imageView = UIImageView(image: image)
        }
        
        imageView.contentMode = .scaleAspectFit
        
        mainLabel.text = "Мы никого не нашли"
        mainLabel.font = UIFont.boldSystemFont(ofSize: 17)
        mainLabel.textAlignment = .center
        
        
        subLabel.text = "Попробуй скорректировать запрос"
        subLabel.font = UIFont.systemFont(ofSize: 16)
        subLabel.tintColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.6078431373, alpha: 1)
        subLabel.textAlignment = .center
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(mainLabel)
        stackView.addArrangedSubview(subLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
}
