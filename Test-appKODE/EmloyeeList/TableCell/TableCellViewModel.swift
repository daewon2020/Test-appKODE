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
    var sorting: SortList { get set }
}

class TableViewCellModel: TableViewCellModelProtocol {
    var employee: Employee
    var sorting: SortList

    var avatar: UIImage? {
        get async {
            await ImageLoader.shared.getImageFromCache(for: employee.avatarUrl)
        }
    }
    
    init(employess: Employee, sorting: SortList) {
        self.employee = employess
        self.sorting = sorting
    }
}

class SectionCellViewModel {
    var rows = [TableViewCellModelProtocol]()
    var sectionTitles = [Int: Int]()
    var rowsInSection = [[TableViewCellModelProtocol]]()
}
