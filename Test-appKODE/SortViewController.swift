//
//  SortViewController.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 15.08.2022.
//

import UIKit

final class SortViewController: UIViewController {

    @IBOutlet weak var aplhabetButton: UIButton!
    @IBOutlet weak var birthdayButton: UIButton!
    
    var employeeListPresenter: EmploeeListPresenterProtocol!
    var sorting: SortList!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch sorting {
        case .name:
            checkAplhabetButton()
        case .birthday:
            checkBirthdayButton()
        case .none:
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        employeeListPresenter.sorting = sorting
        employeeListPresenter.showEmployeeList(filteredBy: nil)
    }
    
    @IBAction func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        switch sender {
        case aplhabetButton:
            checkAplhabetButton()
            sorting = .name
            dismiss(animated: true)
        case birthdayButton:
            checkBirthdayButton()
            sorting = .birthday
            dismiss(animated: true)
        default:
            return
        }
    }
}

//MARK: - private func

extension SortViewController {
    private func checkAplhabetButton() {
        aplhabetButton.setImage(UIImage(named: "radioButtonChecked"), for: .normal)
        birthdayButton.setImage(UIImage(named: "radioButton"), for: .normal)
    }
    
    private func checkBirthdayButton() {
        aplhabetButton.setImage(UIImage(named: "radioButton"), for: .normal)
        birthdayButton.setImage(UIImage(named: "radioButtonChecked"), for: .normal)
    }
}
