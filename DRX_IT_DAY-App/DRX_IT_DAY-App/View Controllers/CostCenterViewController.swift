//
//  CostCenterViewController.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 29.04.2021.
//

import UIKit

class CostCenterViewController: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CostCenterTableViewCell.self, forCellReuseIdentifier: CostCenterTableViewCell.identifier)
        return table
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search by name or id"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        return searchBar
    }()
    
    var costCenterArray = [CostCenter]()
    var filteredArray = [CostCenter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cost Center"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(showAddAlert))
        self.navigationItem.rightBarButtonItem  = addButton
        
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
        NetworkManager.shared.fetchCostCenters { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let costCenters):
                self.costCenterArray = costCenters
                self.filteredArray = self.costCenterArray
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
        
    }
    
    // Shows the alert for adding a Cost Center
    @objc func showAddAlert() {
        let alert = UIAlertController(title: "Add Cost Center", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Id"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Manager first and last name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            // Force unwrapping because we know it exists
            guard let id = alert?.textFields![0].text else { return }
            guard let name = alert?.textFields![1].text else { return }
            guard let managerName = alert?.textFields![2].text else { return }
            
            var errorMessage = self.dataValidator(name: name, managerName: managerName)
            if Int(id) == nil { errorMessage += "Invalid id!\n" }
            
            if errorMessage == "" {
            let newCostCenter = CostCenter(id: Int(id)!, name: name, managerName: managerName)
            self.doAddRequest(costCenter: newCostCenter)
            }
            else {
                self.showAlert(message: errorMessage)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    // Shows the alert for updating a Cost Center
    func showUpdateAlert(costCenter: CostCenter) {
        let alert = UIAlertController(title: "Edit Cost center", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.text = costCenter.name
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Manager first and last name"
            textField.text = costCenter.managerName
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alert] (_) in
            // Force unwrapping because we know it exists
            guard let name = alert?.textFields![0].text else { return }
            guard let managerName = alert?.textFields![1].text else { return }
            
            let errorMessage = self.dataValidator(name: name, managerName: managerName)
            
            if errorMessage == "" {
                let updatedCostCenter = CostCenter(id: costCenter._id, name: name, managerName: managerName)
                self.doUpdateRequest(costCenter: updatedCostCenter)
            } else {
                self.showAlert(message: errorMessage)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    // Execute a request for adding a cost center
    func doAddRequest(costCenter: CostCenter) {
        NetworkManager.shared.addCostCenter(costCenter: costCenter) { [weak self] result in
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
    
    // Execute a request for updating a cost center
    func doUpdateRequest(costCenter: CostCenter) {
        NetworkManager.shared.updateCostCenter(costCenter: costCenter) { [weak self] result in
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
    
    //MARK: - DATA VALIDATOR
    func dataValidator(name: String, managerName: String) -> String {
        var errorMessage = ""
        
        if name.count < 3 {
            errorMessage += "Invalid name!\n"
        }
        if !Validator.shared.validateFirstAndLastName(managerName) {
            errorMessage += "Invalid manager name!\n"
        }
        
        return errorMessage
    }
    
    // Execute a request to set a cost center as deleted
    func setAsDeletedAction(id: Int) {
        NetworkManager.shared.setAsDeletedCostCenter(id: id) { [weak self] result in
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
    
    // Execute a request to delete a Cost Center
    func deleteAction(id: Int, isDeleted: Bool) {
        NetworkManager.shared.deleteCostCenter(id: id, isDeleted: isDeleted) { [weak self] result in
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
extension CostCenterViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CostCenterTableViewCell.identifier, for: indexPath) as! CostCenterTableViewCell
        cell.setup(costCenter: filteredArray[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // edit action
        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.showUpdateAlert(costCenter: self.filteredArray[indexPath.row])
            
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
            
            let costCenter = self.filteredArray[indexPath.row]
            
            if costCenter.isDeleted == true {
                self.deleteAction(id: costCenter._id, isDeleted: costCenter.isDeleted)
            }
            else {
                self.setAsDeletedAction(id: costCenter._id)
            }
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}


// MARK: - SEARCHBAR DELEGATE
extension CostCenterViewController: UISearchBarDelegate {
    
    /* DELEGATE METHODS */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
        searchBar.text = ""
        filteredArray = costCenterArray
        reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = []
        if searchText.isEmpty {
            filteredArray = costCenterArray
        }
        else {
            for costCenter in costCenterArray {
                
                if costCenter.name.lowercased().contains(searchText.lowercased()) || String(costCenter._id).lowercased().contains(searchText.lowercased()) {
                    
                    filteredArray.append(costCenter)
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


