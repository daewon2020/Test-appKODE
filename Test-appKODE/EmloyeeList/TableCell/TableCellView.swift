//
//  EmployeeTableViewCell.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 11.08.2022.
//

import UIKit

protocol TableCellViewProtocol {
    var viewModel: TableViewCellModel { get set }
}

class TableCellView: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellMainText: UILabel!
    @IBOutlet weak var cellSubtitle: UILabel!
    @IBOutlet weak var cellBithday: UILabel!
    
    private let startColor = CGColor(red: 0.955, green: 0.955, blue: 0.965, alpha: 1.0)
    private let endColor = CGColor(red: 0.979, green: 0.981, blue: 0.981, alpha: 1.0)
    
    var viewModel: TableViewCellModelProtocol! {
        didSet {
            updateView()
        }
    }
    override func prepareForReuse() {
        cellImage.image = UIImage(named: "goose")
    }
    
    private func updateView() {
        cellImage.layer.cornerRadius = cellImage.frame.height / 2
        cellBithday.isHidden = true
        
        if viewModel == nil {
            let cellSubtitleFrame = CGRect(
                x: 0,
                y: 0,
                width: cellSubtitle.bounds.width / 2 ,
                height: cellSubtitle.bounds.height
            )
            
            cellImage.layer.addSublayer(createGradientLayer(frame: cellImage.bounds))
            cellMainText.layer.addSublayer(createGradientLayer(frame: cellMainText.bounds))
            cellSubtitle.layer.addSublayer(createGradientLayer(frame: cellSubtitleFrame))
        
        } else {
            cellImage.layer.sublayers?.removeAll()
            cellMainText.layer.sublayers?.removeAll()
            cellSubtitle.layer.sublayers?.removeAll()
            
            if viewModel.sorting == .birthday {
                if let date = viewModel.employee.birthdayShort {
                    cellBithday.isHidden = false
                    cellBithday.text = date
                }
            }
            
            let mainText = NSMutableAttributedString()
            mainText.append(NSAttributedString(string: viewModel.employee.fullName))
            mainText.append(
                NSMutableAttributedString(
                    string: " " + viewModel.employee.userTag.lowercased(),
                    attributes: [
                        .foregroundColor: #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.6078431373, alpha: 1),
                        .font: UIFont.systemFont(ofSize: 14),
                    ]
                )
            )
            cellMainText.attributedText = mainText
            cellSubtitle.text = viewModel.employee.position
            
            Task {
                if let avatar = await viewModel.avatar {
                    await MainActor.run {
                        cellImage.image = avatar
                    }
                }
            }
        }
    }
    
    private func createGradientLayer(frame: CGRect) -> CALayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.cornerRadius = gradientLayer.frame.height / 2
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        return gradientLayer
    }
}
