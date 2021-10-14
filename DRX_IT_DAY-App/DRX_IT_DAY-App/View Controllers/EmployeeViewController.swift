//
//  EmployeeViewController.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 29.04.2021.
//

import UIKit

class EmployeeViewController: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.identifier)
        return table
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search by name or c.s. id"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        return searchBar
    }()
    
    var employeeArray = [Employee]()
    var filteredArray = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Employee"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .plain, target: self, action: #selector(showAddAlert))
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
        NetworkManager.shared.fetchEmployees{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let employees):
                self.employeeArray = employees
                self.filteredArray = self.employeeArray
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
        
    }
    
    // Shows the alert for adding an Employee
    @objc func showAddAlert() {
        let alert = UIAlertController(title: "Add Employee", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "First and last name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Cost center id"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            // Force unwrapping because we know it exists
            guard let name = alert?.textFields![0].text else { return }
            guard let costCenterId = alert?.textFields![1].text else { return }
            
            let errorMessage = self.dataValidator(name: name, costCenterId: costCenterId)
            
            if errorMessage == "" {
                let newEmployee = Employee(name: name, costCenterId: Int(costCenterId)!)
                self.doAddRequest(employee: newEmployee)
                
            }else {
                self.showAlert(message: errorMessage)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    // Execute a request for adding an Employee
    func doAddRequest(employee: Employee) {
        NetworkManager.shared.addEmployee(employee: employee) { [weak self] result in
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
    
    // Shows the alert for updating an Employee
    func showUpdateAlert(employee: Employee) {
        let alert = UIAlertController(title: "Edit Cost center", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "First and last name"
            textField.text = employee.name
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Cost center id"
            textField.text = String(employee.costCenterId)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alert] (_) in
            // Force unwrapping because we know it exists
            guard let name = alert?.textFields![0].text else { return }
            guard let costCenterId = alert?.textFields![1].text else { return }
            
            let errorMessage = self.dataValidator(name: name, costCenterId: costCenterId)
            
            if errorMessage == "" {
                let updatedEmployee = Employee(id: employee._id, name: name, costCenterId: Int(costCenterId)!)
                self.doUpdateRequest(employee: updatedEmployee)
                
            } else {
                self.showAlert(message: errorMessage)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    // Execute a request for updating an employee
    func doUpdateRequest(employee: Employee) {
        NetworkManager.shared.updateEmployee(employee: employee) { [weak self] result in
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
    
    // Execute a request for deleting an employee
    func deleteAction(id: String) {
        NetworkManager.shared.deleteEmployee(id: id) { [weak self] result in
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
    
    //MARK: - DATA VALIDATOR
    func dataValidator(name: String, costCenterId: String) -> String {
        var errorMessage = ""
        
        if !Validator.shared.validateFirstAndLastName(name) {
            errorMessage += "Invalid name!\n"
        }
        if Int(costCenterId) == nil {
            errorMessage += "Invalid cost center id!\n"
        }
        
        return errorMessage
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
extension EmployeeViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier, for: indexPath) as! EmployeeTableViewCell
        cell.setup(employee: filteredArray[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // edit action
        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.showUpdateAlert(employee: self.filteredArray[indexPath.row])
            
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
            self.deleteAction(id: self.filteredArray[indexPath.row]._id)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}


// MARK: - SEARCHBAR DELEGATE
extension EmployeeViewController: UISearchBarDelegate {
    
    /* DELEGATE METHODS */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
        searchBar.text = ""
        filteredArray = employeeArray
        reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = []
        if searchText.isEmpty {
            filteredArray = employeeArray
        }
        else {
            for employee in employeeArray {
                
                if employee.name.lowercased().contains(searchText.lowercased()) || String(employee.costCenterId).lowercased().contains(searchText.lowercased()) {
                    
                    filteredArray.append(employee)
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


