//
//  TableViewCellModel.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 14.08.2022.
//

import Foundation
import UIKit

protocol TableViewCellModelProtocol {
    var employee: Employee { get set }
    var avatar: UIImage? { get async }
}

class TableViewCellModel: TableViewCellModelProtocol {
    var employee: Employee
    
    var avatar: UIImage? {
        get async {
            await ImageLoader.shared.getImageFromCache(for: employee.avatarUrl)
        }
    }
    
    init(employess: Employee) {
        self.employee = employess
    }
}

class SectionCellViewModel {
    var rows = [TableViewCellModelProtocol]()
}
