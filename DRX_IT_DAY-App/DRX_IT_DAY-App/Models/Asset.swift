//
//  Asset.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 29.04.2021.
//

import Foundation

/**
 Model class for  Asset
 */
class Asset: Decodable {
    
    var name: String!
    var description: String!
    var startDate: String!
    var endDate: String!
    
    init(name: String, description: String, startDate: String, endDate: String) {
        
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }
}
