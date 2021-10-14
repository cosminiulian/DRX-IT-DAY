//
//  EmployeeTableViewCell.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 02.05.2021.
//

import UIKit
/*
 Custom Cell for Employee TableView
 */
class EmployeeTableViewCell: UITableViewCell {
    static let identifier = "EmployeeTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let costCenterIdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(costCenterIdLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        costCenterIdLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        costCenterIdLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        costCenterIdLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        costCenterIdLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        costCenterIdLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    
    func setup(employee: Employee) {
        nameLabel.text = employee.name
        costCenterIdLabel.text = String(employee.costCenterId)
    }
    
}


