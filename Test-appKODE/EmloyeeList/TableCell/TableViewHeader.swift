//
//  TableViewHeader.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 18.08.2022.
//

import UIKit

class TableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var headerTitle: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
