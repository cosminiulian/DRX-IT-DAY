//
//  CostCenter.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 01.05.2021.
//

import Foundation

/**
 Model class for  CostCenter
 */
class CostCenter: Decodable {
    
    var _id: Int!
    var name: String!
    var managerName: String!
    var isDeleted: Bool!
    
    init(id: Int, name: String, managerName: String) {
        _id = id
        self.name = name
        self.managerName = managerName
        self.isDeleted = false
    }
    
}
