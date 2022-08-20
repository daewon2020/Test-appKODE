//
//  TabCollectionViewCell.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 20.08.2022.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tabTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
