//
//  EmployeeViewController.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 20.08.2022.
//

import UIKit

protocol EmployeeListViewControllerProtocol: AnyObject {
    func reloadEmployeeListFiltered(for section: SectionCellViewModel)
    func setDepartamentList(_ departamentList: [String])
}

class EmployeeListViewController: UIViewController {
    
    @IBOutlet weak var employeeTableView: UITableView!
    @IBOutlet weak var tabCollectionView: UICollectionView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var presenter: employeeListPresenterProtocol!
    private var isFiltered = false
    private var section = SectionCellViewModel()
    private var departaments = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = employeeListPresenter(view: self)
        presenter.viewDidLoad()
        
        setupTableView()
        setupCollectionView()
        setupSearchController()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sortVC = segue.destination as? SortViewController else { return }
        sortVC.employeeListPresenter = presenter
        sortVC.sorting = presenter.sorting
    }
}

//MARK: - UITableViewDelegate

extension EmployeeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        78
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "TableViewHeader"
        ) as? TableViewHeader else { return nil}
        
        if self.section.sectionTitles.count > 0 && presenter.sorting == .birthday {
            let title = self.section.sectionTitles.sorted(by: { $0.key > $1.key})[section].key
            headerView.headerTitle.text = String(title)

            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.section.sectionTitles.count > 0 && presenter.sorting == .birthday {
            return 60
        }
        return 0
    }
    
}

//MARK: - UITableViewDataSource

extension EmployeeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if presenter.sorting == .birthday {
            return self.section.sectionTitles.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.sorting == .birthday {
            let index = self.section.sectionTitles.sorted(by: { $0.key > $1.key})[section].value
            return self.section.rowsInSection[index].count
        }
        
        if self.section.rows.count == 0 {
            return 10
        }
        
        return self.section.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}

//MARK: - UICollectionDelegate

extension EmployeeListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.departamentCellDidTapped(at: indexPath)
        tabCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: departaments[indexPath.row].count * 13, height: 30)
    }
}

//MARK: - UICollectionViewDataSource

extension EmployeeListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.departaments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cellViewID",
            for: indexPath
        ) as? TabCollectionViewCell else { return UICollectionViewCell() }
        
        if let selectedCell = tabCollectionView.indexPathsForSelectedItems?.first, indexPath.row == selectedCell.row {
            cell.tabTitle.font = UIFont.boldSystemFont(ofSize: 16)
            cell.tabBottomStroke.isHidden = false
        } else {
            cell.tabTitle.font = UIFont.systemFont(ofSize: 15)
            cell.tabBottomStroke.isHidden = true
        }
        
        for departament in Departament.allCases {
            if departament.description == departaments[indexPath.row] {
                cell.tabTitle.text = departament.description
            }
        }
        
        return cell
    }
}

//MARK: - private func

extension EmployeeListViewController {
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
        searchController.automaticallyShowsScopeBar = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupTableView() {
        employeeTableView.dataSource = self
        employeeTableView.delegate = self
        
        employeeTableView.register(
            UINib(nibName: "TableViewCell", bundle: nil),
            forCellReuseIdentifier: "employeeCellID"
        )
        
        employeeTableView.register(
            UINib(nibName: "TableViewHeader", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "TableViewHeader")
        employeeTableView.refreshControl = UIRefreshControl()
        employeeTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    
    private func setupCollectionView() {
        tabCollectionView.dataSource = self
        tabCollectionView.delegate = self
        tabCollectionView.allowsSelection = true
        tabCollectionView.allowsMultipleSelection = false
        tabCollectionView.register(
            UINib(nibName: "TabCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "cellViewID"
        )
    }
    
    @objc func refresh() {
        employeeTableView.refreshControl?.endRefreshing()
        presenter.fetchEmployeeData()
    }
}

//MARK: - UISearchResultsUpdating

extension EmployeeListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filterText = searchController.searchBar.text, !filterText.isEmpty  else {
            presenter.showEmployeeList(filteredBy: nil)
            return
        }
        presenter.showEmployeeList(filteredBy: filterText.lowercased())
    }
}

//MARK: - UISearchBarDelegate

extension EmployeeListViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "sortSegue", sender: nil)
    }
}

//MARK: - EmployeeListViewControllerProtocol

extension EmployeeListViewController: EmployeeListViewControllerProtocol {
    func reloadEmployeeListFiltered(for section: SectionCellViewModel) {
        self.section = section
        employeeTableView.reloadData()
        tabCollectionView.reloadData()
    }

//    func reloadEmployeeList(for section: SectionCellViewModel) {
//        self.section = section
//        employeeTableView.refreshControl?.endRefreshing()
//        employeeTableView.reloadData()
//        tabCollectionView.reloadData()
//    }
    
    func setDepartamentList(_ departaments: [String]) {
        self.departaments = departaments
    }
}

