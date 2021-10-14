//
//  Employee.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 01.05.2021.
//

import Foundation

/**
 Model class for  Employee
 */
class Employee: Decodable {
    
    var _id: String!
    var name: String!
    var costCenterId: Int!
    
    init(name: String, costCenterId: Int) {
        self.name = name
        self.costCenterId = costCenterId
    }
    
    init(id: String, name: String, costCenterId: Int) {
        _id = id
        self.name = name
        self.costCenterId = costCenterId
    }
    
}
