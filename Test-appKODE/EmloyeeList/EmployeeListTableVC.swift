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
    private var cellCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = EmploeeListPresenter(view: self)
        setupTableView()
        setupSearchController()
        fetchEmployeeData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellCount == 0 ? 10 : cellCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "employeeCellID",
            for: indexPath
        ) as? EmployeeTableViewCell else { return UITableViewCell() }
        
        cell.employeeModel = presenter.getEmployee(for: indexPath) 

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
    private func setupSearchController() {
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
    
    private func setupTableView() {
        tableView.register(
            UINib(
                nibName: "EmployeeTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "employeeCellID"
        )
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    
    @objc func refresh() {
        refreshControl?.endRefreshing()
        presenter.fetachEmployeeData()
    }
    
    private func fetchEmployeeData() {
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
        cellCount = presenter.getEmployeeCount()
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
}

