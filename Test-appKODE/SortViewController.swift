//
//  SortViewController.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 15.08.2022.
//

import UIKit

class SortViewController: UIViewController {

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
}
