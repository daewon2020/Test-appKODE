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
    func showFrendlyMessage()
}

class EmployeeListViewController: UIViewController {
    
    @IBOutlet weak var employeeTableView: UITableView!
    @IBOutlet weak var tabCollectionView: UICollectionView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var presenter: employeeListPresenterProtocol!
    private var isFiltered = false
    private var frendlyMessageIsShow = false
    private var section = SectionCellViewModel()
    private var departaments = [String]()
    private var searchFailView = UIStackView()
    private var selectedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = employeeListPresenter(view: self)
        presenter.viewDidLoad()
        
        setupTableView()
        setupCollectionView()
        setupSearchController()
        createSearchFailView()
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
        selectedCell = indexPath.row
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
        
        if indexPath.row == selectedCell {
            self.selectedCell = indexPath.row
            cell.tabTitle.font = UIFont.boldSystemFont(ofSize: 16)
            cell.tabTitle.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.tabBottomStroke.isHidden = false
        } else {
            cell.tabTitle.font = UIFont.systemFont(ofSize: 15)
            cell.tabTitle.tintColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.6078431373, alpha: 1)
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
    
    func createSearchFailView() {
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
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
        
        searchFailView.alignment = .fill
        searchFailView.distribution = .fill
        searchFailView.axis = .vertical
        searchFailView.spacing = 10
        
        searchFailView.addArrangedSubview(imageView)
        searchFailView.addArrangedSubview(mainLabel)
        searchFailView.addArrangedSubview(subLabel)
        
        searchFailView.translatesAutoresizingMaskIntoConstraints = false
        
        employeeTableView.addSubview(searchFailView)
        
        NSLayoutConstraint.activate([
            searchFailView.centerYAnchor.constraint(equalTo: employeeTableView.centerYAnchor),
            searchFailView.centerXAnchor.constraint(equalTo: employeeTableView.centerXAnchor),
        ])
        
        searchFailView.isHidden = true
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
        searchFailView.isHidden = true
        employeeTableView.dataSource = self
        
        self.section = section
        employeeTableView.reloadData()
        tabCollectionView.reloadData()
    }
    
    func setDepartamentList(_ departaments: [String]) {
        self.departaments = departaments
    }
    
    func showFrendlyMessage() {
        searchFailView.isHidden = false
        employeeTableView.dataSource = nil
        employeeTableView.reloadData()
        tabCollectionView.reloadData()
    }
}

