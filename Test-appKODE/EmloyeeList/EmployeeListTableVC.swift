//
//  EmployeeListTableVC.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 10.08.2022.
//

import UIKit

protocol EmployeeListTableViewProtocol: AnyObject {
    func refreshEmployeeList()
}

final class EmployeeListTableVC: UITableViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private var presenter: EmploeeListPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = EmploeeListPresenter(view: self)
        tableView.register(
            UINib(
                nibName: "EmployeeTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "employeeCellID"
        )
        
        setupSearchController()
        fetchEmployeeData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DataManager.shared.employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "employeeCellID",
            for: indexPath
        ) as? EmployeeTableViewCell else { return UITableViewCell() }
        
        let employee = DataManager.shared.employees[indexPath.row]
        let mainText = NSMutableAttributedString()
        mainText.append(NSAttributedString(string: employee.fullName))
        mainText.append(
            NSMutableAttributedString(
                string: " " + employee.userTag.lowercased(),
                attributes: [
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.6078431373, alpha: 1),
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                ]
            )
        )
        cell.cellMainText.attributedText = mainText
        cell.cellSubtitle.text = employee.position
        cell.cellImage.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.6078431373, alpha: 1)
        cell.cellImage.layer.cornerRadius = cell.cellImage.frame.height / 2
        
        Task {
            if let image = await DataManager.shared.getEmploeeAvatar(from: employee.avatarUrl) {
                await MainActor.run {
                    cell.cellImage.image = image
                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        78.0
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}

//MARK: - private func

extension EmployeeListTableVC {
    func setupSearchController() {
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(
            UIImage(systemName: "list.bullet.indent"),
            for: .bookmark,
            state: .normal
        )
        searchController.searchBar.placeholder = "Введи имя, тег, почту..."
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func fetchEmployeeData() {
        presenter.fetachEmployeeData()
    }
}

//MARK: - UISearchResultsUpdating

extension EmployeeListTableVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        return
    }
}

//MARK: - UISearchBarDelegate

extension EmployeeListTableVC: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarBookmarkButtonClicked")
    }
}

//MARK: - EmployeeListTableViewProtocol

extension EmployeeListTableVC: EmployeeListTableViewProtocol {
    func refreshEmployeeList() {
        tableView.reloadData()
        print(DataManager.shared.employees.count)
    }
}

