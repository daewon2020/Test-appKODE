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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            aplhabetButton.setImage(UIImage(named: "radioButtonChecked"), for: .normal)
            birthdayButton.setImage(UIImage(named: "radioButton"), for: .normal)
        case birthdayButton:
            aplhabetButton.setImage(UIImage(named: "radioButton"), for: .normal)
            birthdayButton.setImage(UIImage(named: "radioButtonChecked"), for: .normal)
        default:
            return
        }
    }
    
    @IBAction func alphabetButtonTapped(_ sender: UIButton) {
        aplhabetButton.setImage(UIImage(named: "radioButtonChecked"), for: .selected)
        birthdayButton.setImage(UIImage(named: "radioButton"), for: .normal)
    }
    
}
