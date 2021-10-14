var assetEmployeeExports = require("../models/asset_employee_model")
var assetEmployeeModel = assetEmployeeExports.assetEmployeeModel // include asset model

const express = require("express")
const assetsEmployeeRoute = express.Router() // create custom router

// POST REQUEST: - CREATE ASSET FOR AN EMPLOYEE
assetsEmployeeRoute.post("/addAsset", (req, res) => {
  var assetEmployee = new assetEmployeeModel({
    employeeName: req.body.employeeName,
    costCenterId: req.body.costCenterId,
    fromCountry: req.body.fromCountry,
    toCountry: req.body.toCountry,

    asset: {
      name: req.body.name,
      description: req.body.description,
      startDate: req.body.startDate,
      endDate: req.body.endDate
    }
  })

  assetEmployee.save().then(() => {
    if (assetEmployee.isNew == false) {
      // if the data is saved on the server and database then return false
      res.json({
        message: "Asset for employee created successfully!"
      })
    } else {
      res.json({
        message: "Failed to save the asset!"
      })
    }
  })
})

// PUT REQUEST: - UPDATE ASSET
assetsEmployeeRoute.put("/updateAsset", (req, res) => {
  if (req.body.id != null) {
    // Find the asset with that specific id and update his values
    assetEmployeeModel.findOneAndUpdate(
      {
        _id: req.body.id
      },
      {
        employeeName: req.body.employeeName,
        costCenterId: req.body.costCenterId,
        fromCountry: req.body.fromCountry,
        toCountry: req.body.toCountry,

        asset: {
          name: req.body.name,
          description: req.body.description,
          startDate: req.body.startDate,
          endDate: req.body.endDate
        }
      },
      (error) => {
        if (error != null) {
          res.json({
            error: "Failed to update asset: " + error
          })
        } else {
          res.json({
            message: "Asset Updated!"
          })
        }
      }
    )
  } else {
    res.json({
      error: "id doesn't exists!"
    })
  }
})

// DELETE REQUEST: - DELETE ASSET
assetsEmployeeRoute.delete("/deleteAsset", (req, res) => {
  if (req.body.id != null) {
    // Find the asset with that specific id and delete it
    assetEmployeeModel.findOneAndRemove(
      {
        _id: req.body.id
      },
      (error) => {
        if (error != null) {
          res.json({
            error: "Failed to delete cost center: " + error
          })
        } else {
          res.json({
            message: "Asset for Employee Deleted!"
          })
        }
      }
    )
  }
})

// GET REQUEST: - FETCH ASSETS
assetsEmployeeRoute.get("/fetchAssets", (req, res) => {
  assetEmployeeModel.find({}).then((dbItems) => {
    // get all DB items
    res.send(dbItems)
  })
})

module.exports = assetsEmployeeRoute // exports the router when is included
