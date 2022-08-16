//
//  SortViewController.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 15.08.2022.
//

import UIKit

class SortViewController: UIViewController {

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
        
        employeeListPresenter.showEmployeeListWithoutFilter()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        switch sender {
        case aplhabetButton:
            checkAplhabetButton()
            sorting = .name
        case birthdayButton:
            checkBirthdayButton()
            sorting = .birthday
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
