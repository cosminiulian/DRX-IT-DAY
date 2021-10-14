//
//  AssetViewController.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 29.04.2021.
//

import UIKit

class AssetViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(AssetTableViewCell.self, forCellReuseIdentifier: AssetTableViewCell.identifier)
        return table
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search by name"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        return searchBar
    }()
    
    var assetArray = [AssetEmployee]()
    var filteredArray = [AssetEmployee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Asset"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(image: UIImage(systemName: "note.text.badge.plus"), style: .plain, target: self, action: #selector(showAddAlert))
        navigationItem.rightBarButtonItem  = addButton
        
        setSearchBarButton(shouldShow: true)
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    @objc func searchButtonAction() {
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    
    // Reload data from API
    func reloadData() {
        NetworkManager.shared.fetchAssets { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let assets):
                self.assetArray = assets
                self.filteredArray = self.assetArray
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    // Shows the alert for adding an Asset for Employee
    @objc func showAddAlert() {
        let alert = UIAlertController(title: "Add Asset", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Description"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Start date (dd/MM/yyyy)"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "End date (dd/MM/yyyy)"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Employee first and last name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Cost center id"
            textField.keyboardType = .numberPad
        }
        alert.addTextField { (textField) in
            textField.placeholder = "From country"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "To country"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            // Force unwrapping the textFields because we know it exists
            guard let name = alert?.textFields![0].text else { return }
            guard let description = alert?.textFields![1].text else { return }
            guard let startDate = alert?.textFields![2].text else { return }
            guard let endDate = alert?.textFields![3].text else { return }
            guard let empName = alert?.textFields![4].text else { return }
            guard let costCenterId = alert?.textFields![5].text else { return }
            guard let fromCountry = alert?.textFields![6].text else { return }
            guard let toCountry = alert?.textFields![7].text else { return }
            
            // Validate the data
            let errorMessage = self.dataValidator(name: name, description: description, startDate: startDate, endDate: endDate, empName: empName, costCenterId: costCenterId, fromCountry: fromCountry, toCountry: toCountry)
            
            if errorMessage == "" {
                let newAsset = AssetEmployee(empName: empName, costCenterId: Int(costCenterId)!, fromCountry: fromCountry, toCountry: toCountry, assetName: name, assetDesc: description, startDate: startDate, endDate: endDate)
                self.doAddRequest(asset: newAsset)
                
            } else {
                self.showAlert(message: errorMessage)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    //MARK: - DATA VALIDATOR
    func dataValidator(name: String, description: String, startDate: String, endDate: String, empName: String, costCenterId: String, fromCountry: String, toCountry: String) -> String {
        
        var errorMessage = ""
        if name.count < 3 {
            errorMessage += "Invalid name!\n"
        }
        if description.count < 3 {
            errorMessage += "Invalid description!\n"
        }
        if !Validator.shared.validateDate(startDate) {
            errorMessage += "Invalid (start) date!\n"
        }
        if !Validator.shared.validateDate(endDate) {
            errorMessage += "Invalid (end) date!\n"
        }
        if !Validator.shared.validateFirstAndLastName(empName) {
            errorMessage += "Invalid employee name!\n"
        }
        if Int(costCenterId) == nil {
            errorMessage += "Invalid cost center id!\n"
        }
        if fromCountry.count < 3 {
            errorMessage += "Invalid (from) Country!\n"
        }
        if toCountry.count < 3 {
            errorMessage += "Invalid (to) Country!\n"
        }
        
        return errorMessage
    }
    
    // Shows the alert to view the details of an asset
    func showDetailsAlert(asset: AssetEmployee) {
       
        /* Alert Message */
        var message = "\n"
        message += "Name: " + asset.asset.name + "\n\n"
        message += "Description: " + asset.asset.description + "\n\n"
        message += "Start date: " + asset.asset.startDate + "\n\n"
        message += "End date: " + asset.asset.endDate + "\n\n"
        message += "Employee name: " + asset.employeeName + "\n\n"
        message += "Cost center id: " + String(asset.costCenterId) + "\n\n"
        message += "From country: " + asset.fromCountry + "\n\n"
        message += "To country: " + asset.toCountry
        
        let messageParagraphStyle = NSMutableParagraphStyle()
        messageParagraphStyle.alignment = NSTextAlignment.left
        
        let attributedMessageText = NSMutableAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.paragraphStyle: messageParagraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0),
            ]
        )
        
        /* Alert Title */
        let title = "Asset Details"
        
        let attributedTitleText = NSMutableAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
            ]
        )
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.setValue(attributedMessageText, forKey: "attributedMessage")
        alert.setValue(attributedTitleText, forKey: "attributedTitle")
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    // Shows the alert to update the details of an asset
    func showUpdateAlert(asset: AssetEmployee) {
        let alert = UIAlertController(title: "Edit Asset", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.text = asset.asset.name
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Description"
            textField.text = asset.asset.description
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Start date"
            textField.text = asset.asset.startDate
        }
        alert.addTextField { (textField) in
            textField.placeholder = "End date"
            textField.text = asset.asset.endDate
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Employee first and last name"
            textField.text = asset.employeeName
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Cost center id"
            textField.text = String(asset.costCenterId)
            textField.keyboardType = .numberPad
        }
        alert.addTextField { (textField) in
            textField.placeholder = "From country"
            textField.text = asset.fromCountry
        }
        alert.addTextField { (textField) in
            textField.placeholder = "To country"
            textField.text = asset.toCountry
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alert] (_) in
            // Force unwrapping because we know it exists
            guard let name = alert?.textFields![0].text else { return }
            guard let description = alert?.textFields![1].text else { return }
            guard let startDate = alert?.textFields![2].text else { return }
            guard let endDate = alert?.textFields![3].text else { return }
            guard let empName = alert?.textFields![4].text else { return }
            guard let costCenterId = alert?.textFields![5].text else { return }
            guard let fromCountry = alert?.textFields![6].text else { return }
            guard let toCountry = alert?.textFields![7].text else { return }
            
            // Validate data
            let errorMessage = self.dataValidator(name: name, description: description, startDate: startDate, endDate: endDate, empName: empName, costCenterId: costCenterId, fromCountry: fromCountry, toCountry: toCountry)
            
            if errorMessage == "" {
                let updatedAsset = AssetEmployee(id: asset._id,empName: empName, costCenterId: Int(costCenterId)!, fromCountry: fromCountry, toCountry: toCountry, assetName: name, assetDesc: description, startDate: startDate, endDate: endDate)
                self.doUpdateRequest(asset: updatedAsset)
                
            } else {
                self.showAlert(message: errorMessage)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    // Execute a request for adding asset
    func doAddRequest(asset: AssetEmployee) {
        NetworkManager.shared.addAsset(asset: asset) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                self.reloadData()
                let message = message
                self.showAlert(message: message)
                
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    // Execute a request for updating asset
    func doUpdateRequest(asset: AssetEmployee) {
        NetworkManager.shared.updateAsset(asset: asset) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                self.reloadData()
                let message = message
                self.showAlert(message: message)
                
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    // Execute a request for deleting asset
    func deleteAction(id: String) {
        NetworkManager.shared.deleteAsset(id: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                self.reloadData()
                self.showAlert(message: message)
                
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    // Shows an alert with a custom message
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
}

// MARK: - TABLE VIEW DATA SOURCE & DELEGATE
extension AssetViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AssetTableViewCell.identifier, for: indexPath) as! AssetTableViewCell
        cell.setup(asset: filteredArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showDetailsAlert(asset: filteredArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // edit action
        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.showUpdateAlert(asset: self.filteredArray[indexPath.row])
            
            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // delete action
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            let asset = self.filteredArray[indexPath.row]
            self.deleteAction(id: asset._id)
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

// MARK: - SEARCHBAR DELEGATE
extension AssetViewController: UISearchBarDelegate {
    
    /* DELEGATE METHODS */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
        searchBar.text = ""
        filteredArray = assetArray
        reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = []
        if searchText.isEmpty {
            filteredArray = assetArray
        }
        else {
            for asset in assetArray {
                
                if asset.asset.name.lowercased().contains(searchText.lowercased()) {
                    filteredArray.append(asset)
                }
            }
        }
        tableView.reloadData()
    }
    
    /* CUSTOM METHODS */
    func setSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonAction))
            navigationItem.leftBarButtonItem  = searchButton
            
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        
    }
    
    func search(shouldShow: Bool) {
        setSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil // ternary operator
    }
    
}


