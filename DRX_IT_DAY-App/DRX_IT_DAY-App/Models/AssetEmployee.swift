//
//  AssetEmployee.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 29.04.2021.
//

import Foundation

/**
 Model class for  AssetEmployee
 */
class AssetEmployee: Decodable {
    
    var _id: String!
    var employeeName: String!
    var costCenterId: Int!
    var fromCountry: String!
    var toCountry: String!
    var asset: Asset!
    
    init(empName: String, costCenterId: Int, fromCountry: String, toCountry: String, assetName: String, assetDesc: String, startDate: String, endDate: String) {
        
        employeeName = empName
        self.costCenterId = costCenterId
        self.fromCountry = fromCountry
        self.toCountry = toCountry
        self.asset = Asset(name: assetName, description: assetDesc, startDate: startDate, endDate: endDate)
    }
    
    init(id: String, empName: String, costCenterId: Int, fromCountry: String, toCountry: String, assetName: String, assetDesc: String, startDate: String, endDate: String) {
        
        _id = id
        employeeName = empName
        self.costCenterId = costCenterId
        self.fromCountry = fromCountry
        self.toCountry = toCountry
        self.asset = Asset(name: assetName, description: assetDesc, startDate: startDate, endDate: endDate)
    }
    
}
