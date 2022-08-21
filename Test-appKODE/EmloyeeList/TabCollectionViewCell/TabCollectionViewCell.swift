//
//  TabCollectionViewCell.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 20.08.2022.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tabTitle: UILabel!
    @IBOutlet weak var tabBottomStroke: UIView!

    override func prepareForReuse() {
        tabBottomStroke.isHidden = true
    }
}

