//
//  AssetTableViewCell.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 01.05.2021.
//

import UIKit
/*
 Custom Cell for Asset TableView
 */
class AssetTableViewCell: UITableViewCell {
    static let identifier = "AssetTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(statusImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        descLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        descLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        descLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        descLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        statusImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        statusImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        statusImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        statusImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(asset: AssetEmployee) {
        nameLabel.text = asset.asset.name
        descLabel.text = asset.asset.description
        
        if isDone(dateString: asset.asset.endDate) {
            statusImageView.image = UIImage(systemName: "checkmark")
            statusImageView.tintColor = .systemGreen
        } else {
            statusImageView.image = UIImage(systemName: "paperplane")
            statusImageView.tintColor = .systemOrange
        }
    }
    
    fileprivate func isDone(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: dateString)
        let today = Date()
       
        return today > date!
    }
    
}


