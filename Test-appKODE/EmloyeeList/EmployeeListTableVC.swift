//
//  EmployeeListTableVC.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 10.08.2022.
//

import UIKit


enum SortList {
    case name
    case birthday
}

protocol EmployeeListTableViewProtocol: AnyObject {
    func reloadEmployeeList(for section: SectionCellViewModel)
    func reloadEmployeeListFiltered(for sectioт: SectionCellViewModel)
}

final class EmployeeListTableVC: UITableViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private var presenter: EmploeeListPresenterProtocol!
    private var isFiltered = false
    private var section = SectionCellViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = EmploeeListPresenter(view: self)
        
        presenter.viewDidLoad()
        
        setupTableView()
        setupSearchController()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.section.sectionTitles.count > 0 && presenter.sorting == .birthday {
            let title = self.section.sectionTitles.sorted(by: { $0.key > $1.key})[section].key
            //print(self.section.sectionTitles.sorted(by: { $0.key > $1.key}))
            return String(title)
        }
        return nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if presenter.sorting == .birthday {
            return self.section.sectionTitles.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.sorting == .birthday {
            let index = self.section.sectionTitles.sorted(by: { $0.key > $1.key})[section].value
            //print(self.section.rowsInSection[index].count)
            return self.section.rowsInSection[index].count
            
        }
        
        if self.section.rows.count == 0 {
            return 10
        }
        
        return self.section.rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "employeeCellID",
            for: indexPath
        ) as? TableCellView else { return UITableViewCell() }
        let viewModel: TableViewCellModelProtocol!
        if section.rows.count == 0 {
            cell.viewModel = nil
            return cell
        }
        
        if presenter.sorting == .birthday {
            let index = self.section.sectionTitles.sorted(by: { $0.key > $1.key})[indexPath.section].value
            viewModel = self.section.rowsInSection[index][indexPath.row]
        } else {
            viewModel = section.rows[indexPath.row]
        }
        
        cell.viewModel = viewModel
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        78
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sortVC = segue.destination as? SortViewController else { return }
        sortVC.employeeListPresenter = presenter
        sortVC.sorting = presenter.sorting
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
                nibName: "TableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "employeeCellID"
        )
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    
    @objc func refresh() {
        refreshControl?.endRefreshing()
        presenter.fetchEmployeeData()
    }
}

//MARK: - UISearchResultsUpdating

extension EmployeeListTableVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filterText = searchController.searchBar.text, !filterText.isEmpty  else {
            presenter.showEmployeeList(filteredBy: nil)
            return
        }
        presenter.showEmployeeList(filteredBy: filterText.lowercased())
    }
}

//MARK: - UISearchBarDelegate

extension EmployeeListTableVC: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "sortSegue", sender: nil)
    }
}

//MARK: - EmployeeListTableViewProtocol

extension EmployeeListTableVC: EmployeeListTableViewProtocol {
    func reloadEmployeeListFiltered(for section: SectionCellViewModel) {
        self.section = section
        tableView.reloadData()
    }

    func reloadEmployeeList(for section: SectionCellViewModel) {
        self.section = section
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
}
