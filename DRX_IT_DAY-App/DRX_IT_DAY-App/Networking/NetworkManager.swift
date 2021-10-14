//
//  NetworkManager.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 29.04.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
  
    /// REQUESTS FOR ASSET EMPLOYEE
    
    // MARK: - GET REQUEST -> FETCH ASSETS FOR EMPLOYEES
    func fetchAssets(completed: @escaping (Result<[AssetEmployee], NSError>) -> Void) {
        
        guard let url = URL(string: URLs.fetchAssets) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert data using JSONDecoder
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let assets = try decoder.decode([AssetEmployee].self, from: data)
                completed(.success(assets))
                
            } catch {
                print("AssetEmployee Array: Failed to Decode!")
            }
            
        }
        
        task.resume() // execute the task
    }
    
    
    // MARK: - POST REQUEST -> ADD AN ASSET FOR EMPLOYEE
    func addAsset(asset: AssetEmployee, completed: @escaping (Result<String, NSError>) -> Void) {
        
        guard let url = URL(string: URLs.addAsset) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["employeeName":asset.employeeName,
                                         "costCenterId":String(asset.costCenterId),
                                         "fromCountry":asset.fromCountry,
                                         "toCountry":asset.toCountry,
                                         "name":asset.asset.name,
                                         "description":asset.asset.description,
                                         "startDate":asset.asset.startDate,
                                         "endDate":asset.asset.endDate
        ]
        let paramsString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let bodyData = paramsString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume() // execute the task
    }
    
    
    // MARK: - PUT REQUEST -> UPDATE ASSET FOR EMPLOYEE
    func updateAsset(asset: AssetEmployee, completed: @escaping (Result<String, NSError>) -> Void) {
        
        guard let url = URL(string: URLs.updateAsset) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["id" : asset._id,
                                         "employeeName":asset.employeeName,
                                         "costCenterId":String(asset.costCenterId),
                                         "fromCountry":asset.fromCountry,
                                         "toCountry":asset.toCountry,
                                         "name":asset.asset.name,
                                         "description":asset.asset.description,
                                         "startDate":asset.asset.startDate,
                                         "endDate":asset.asset.endDate
        ]
        
        let jsonString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        
        task.resume() // execute the task
    }
    
    // MARK: - DELETE REQUEST -> DELETE ASSET FOR EMPLOYEE
    func deleteAsset(id: String, completed: @escaping (Result<String, NSError>) -> Void) {
        
        guard let url = URL(string: URLs.deleteAsset) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["id":id]
        let jsonString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume() // execute the task
    }
    
    /// REQUESTS FOR COST CENTERS
    
    // MARK: - GET REQUEST -> FETCH COST CENTERS
    func fetchCostCenters(completed: @escaping (Result<[CostCenter], NSError>) -> Void) {
        
        guard let url = URL(string: URLs.fetchCostCenters) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert data using JSONDecoder
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let costCenters = try decoder.decode([CostCenter].self, from: data)
                completed(.success(costCenters))
                
            } catch {
                print("CostCenter Array: Failed to Decode!")
            }
            
        }
        
        task.resume() // execute the task
    }
    
    
    // MARK: - POST REQUEST -> ADD A COST CENTER
    func addCostCenter(costCenter: CostCenter, completed: @escaping (Result<String, NSError>) -> Void) {
        
        guard let url = URL(string: URLs.addCostCenter) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["id":String(costCenter._id),
                                         "name":costCenter.name,
                                         "managerName":costCenter.managerName
        ]
        
        let paramsString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let bodyData = paramsString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume() // execute the task
    }
    
    
    // MARK: - PUT REQUEST -> UPDATE COST CENTER
    func updateCostCenter(costCenter: CostCenter, completed: @escaping (Result<String, NSError>) -> Void) {
        
        guard let url = URL(string: URLs.updateCostCenter) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["id" : String(costCenter._id),
                                         "name":costCenter.name,
                                         "managerName":costCenter.managerName
        ]
        
        let jsonString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        
        task.resume() // execute the task
    }
    
    // MARK: - PUT REQUEST -> SET AS DELETED A COST CENTER
    func setAsDeletedCostCenter(id: Int, completed: @escaping (Result<String, NSError>) -> Void) {
        
        guard let url = URL(string: URLs.setAsDeletedCostCenter) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["id" : String(id)]
        
        let jsonString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        
        task.resume() // execute the task
    }
    
    
    // MARK: - DELETE REQUEST -> DELETE A COST CENTER
    func deleteCostCenter(id: Int, isDeleted: Bool, completed: @escaping (Result<String, NSError>) -> Void) {
        
        guard let url = URL(string: URLs.deleteCostCenter) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["id":String(id),
                                         "isDeleted":String(isDeleted)
        ]
        let jsonString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume() // execute the task
    }
    
    /// REQUESTS FOR EMPLOYEE
    
    // MARK: - GET REQUEST -> FETCH EMPLOYEES
    func fetchEmployees(completed: @escaping (Result<[Employee], NSError>) -> Void) {
        
        guard let url = URL(string: URLs.fetchEmployees) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert data using JSONDecoder
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let costCenters = try decoder.decode([Employee].self, from: data)
                completed(.success(costCenters))
                
            } catch {
                print("Employee Array: Failed to Decode!")
            }
            
        }
        
        task.resume() // execute the task
    }
    
    // MARK: - POST REQUEST -> ADD AN EMPLOYEE
    func addEmployee(employee: Employee, completed: @escaping (Result<String, NSError>) -> Void) {
        
        guard let url = URL(string: URLs.addEmployee) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["name":employee.name,
                                         "costCenterId":String(employee.costCenterId)
        ]
        
        let paramsString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let bodyData = paramsString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume() // execute the task
    }
    
    // MARK: - PUT REQUEST -> UPDATE AN EMPLOYEE
    func updateEmployee(employee: Employee, completed: @escaping (Result<String, NSError>) -> Void) {
        
        guard let url = URL(string: URLs.updateEmployee) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["id" : String(employee._id),
                                         "name":employee.name,
                                         "costCenterId":String(employee.costCenterId)
        ]
        
        let jsonString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        
        task.resume() // execute the task
    }
    
    
    
    // MARK: - DELETE REQUEST -> DELETE AN EMPLOYEE
    func deleteEmployee(id: String, completed: @escaping (Result<String, NSError>) -> Void) {
        
        guard let url = URL(string: URLs.deleteEmployee) else {
            completed(.failure(.init(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Invaild url"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        let params: [String : String] = ["id":id]
        let jsonString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error
            if let _ = error {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error task"])))
            }
            
            // Check if the response si valid
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Get Data
            guard let data = data else {
                completed(.failure(.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                return
            }
            
            // Convert Json Message to String
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        completed(.success(message))
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume() // execute the task
    }
}
