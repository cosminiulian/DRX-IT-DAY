//
//  URLs.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 29.04.2021.
//

import Foundation

struct URLs {
    // MARK: - Main URL address
    static let ipAddress = "YOUR CURRENT IP ADDRESS" // MARK: - insert here !!
    static let main = "http://\(ipAddress):8888/"
    
    // Fetch Assets - Endpoint
    static let fetchAssets = main + "fetchAssets"
    // Add Asset - Endpoint
    static let addAsset = main + "addAsset"
    // Update Asset - Endpoint
    static let updateAsset = main + "updateAsset"
    // Delete Asset - Endpoint
    static let deleteAsset = main + "deleteAsset"
    
    // Fetch Cost Centers - Endpoint
    static let fetchCostCenters = main + "fetchCostCenters"
    // Add Cost Center - Endpoint
    static let addCostCenter = main + "addCostCenter"
    // Update Cost Center - Endpoint
    static let  updateCostCenter = main + "updateCostCenter"
    // Set As Deleted the Cost Center - Endpoint
    static let setAsDeletedCostCenter = main + "setAsDeletedCostCenter"
    // Delete Cost Center - Endpoint
    static let deleteCostCenter = main + "deleteCostCenter"
    
    // Fetch Cost Centers - Endpoint
    static let fetchEmployees = main + "fetchEmployees"
    // Add Cost Center - Endpoint
    static let addEmployee = main + "addEmployee"
    // Update Cost Center - Endpoint
    static let updateEmployee = main + "updateEmployee"
    // Delete Cost Center - Endpoint
    static let deleteEmployee = main + "deleteEmployee"
}
