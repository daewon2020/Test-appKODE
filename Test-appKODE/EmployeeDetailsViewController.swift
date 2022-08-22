//
//  EmployeeDetailsViewController.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 22.08.2022.
//

import UIKit

class EmployeeDetailsViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var nameTagLabel: UILabel!
    @IBOutlet weak var detailsTableView: UITableView!
    
    var viewModel: TableViewCellModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        let attributedString = NSMutableAttributedString()
        let name = viewModel.employee.fullName
        let tag = viewModel.employee.userTag
        let position = viewModel.employee.position
        attributedString.append(
            NSMutableAttributedString(
                string: name,
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 24)
                ]
            )
        )
        attributedString.append(
            NSMutableAttributedString(
                string: " " + tag.lowercased(),
                attributes: [
                    .foregroundColor: #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.6078431373, alpha: 1),
                    .font: UIFont.systemFont(ofSize: 17, weight: .light)
                ]
            )
        )
        nameTagLabel.attributedText = attributedString
        
        positionLabel.text = position
        positionLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        positionLabel.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3607843137, alpha: 1)
        
        Task {
            avatar.image = await viewModel.avatar
            avatar.layer.cornerRadius = avatar.frame.width / 2
        }
    }
    
    func showAlert(with message: String) {
        let attributedString = NSMutableAttributedString(
            string: message,
            attributes: [
                .font : UIFont.systemFont(ofSize: 20, weight: .regular)
            ]
        )
        let alertController = UIAlertController(title: message, message: nil , preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.setValue(attributedString, forKey: "attributedTitle")
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension EmployeeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCellID", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if indexPath.row == 0 {
            content.image = UIImage(systemName: "star")
            content.text = viewModel.employee.birthdayFull
            content.secondaryText = viewModel.employee.age
        } else {
            content.image = UIImage(systemName: "phone")
            content.text = viewModel.employee.phone
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
}

extension EmployeeDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            showAlert(with: viewModel.employee.phone)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
