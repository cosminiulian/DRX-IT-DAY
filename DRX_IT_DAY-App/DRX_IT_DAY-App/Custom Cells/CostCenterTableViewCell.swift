//
//  CostCenterTableViewCell.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 02.05.2021.
//

import UIKit
/*
 Custom Cell for CostCenter TableView
 */

class CostCenterTableViewCell: UITableViewCell {
    static let identifier = "CostCenterTableViewCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let managerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let isDeletedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circlebadge.fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(managerLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(isDeletedImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        managerLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        isDeletedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        managerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        managerLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        managerLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        managerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        idLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        idLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        idLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        idLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        isDeletedImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        isDeletedImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        isDeletedImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        isDeletedImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(costCenter: CostCenter) {
        
        nameLabel.text = costCenter.name
        managerLabel.text = costCenter.managerName
        idLabel.text = String(costCenter._id)
        
        if costCenter.isDeleted == true {
            isDeletedImageView.tintColor = .red
        } else {
            isDeletedImageView.tintColor = .green
        }
    
    }

}


