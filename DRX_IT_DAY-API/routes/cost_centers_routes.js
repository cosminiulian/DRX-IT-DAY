var costCenterModel = require("../models/cost_center_model") // include cost center model

const express = require("express")
const costCentersRoute = express.Router() // create custom router

// POST REQUEST: - CREATE COST CENTER
costCentersRoute.post("/addCostCenter", (req, res) => {
  costCenterModel.findOne({ _id: req.body.id }).then((dbItem) => {
    if (dbItem == null) {
      // verify if the employee with that id exists

      var costCenter = new costCenterModel({
        _id: req.body.id,
        name: req.body.name,
        managerName: req.body.managerName
      })

      costCenter.save().then(() => {
        if (costCenter.isNew == false) {
          // if the data is saved on the server &  db then return false
          res.json({
            message: "Cost center created successfully!"
          })
        } else {
          res.json({
            message: "Failed to save the cost center!"
          })
        }
      })
    } else {
      // Get the name of existing food
      res.json({
        message: "The id already exists!"
      })
    }
  })
})

// PUT REQUEST: - UPDATE COST CENTER
costCentersRoute.put("/updateCostCenter", (req, res) => {
  if (req.body.id != null) {
    costCenterModel.findOneAndUpdate(
      {
        _id: req.body.id
      },
      {
        name: req.body.name,
        managerName: req.body.managerName
      },
      (error) => {
        if (error != null) {
          res.json({
            error: "Failed to update cost center: " + error
          })
        } else {
          res.json({
            message: "Cost Center Updated!"
          })
        }
      }
    )
  }
})

// PUT REQUEST: - UPDATE (isDeleted = true for) COST CENTER
costCentersRoute.put("/setAsDeletedCostCenter", (req, res) => {
  if (req.body.id != null) {
    costCenterModel.findOneAndUpdate(
      {
        _id: req.body.id
      },
      {
        isDeleted: true
      },
      (error) => {
        if (error != null) {
          res.json({
            error: "Failed to update cost center: " + error
          })
        } else {
          res.json({
            message: "Cost center set as deleted!"
          })
        }
      }
    )
  }
})

// DELETE REQUEST: - DELETE COST CENTER
costCentersRoute.delete("/deleteCostCenter", (req, res) => {
  if (req.body.isDeleted == "true") {
    if (req.body.id != null) {
      // Find the employee with that specific id and delete it
      costCenterModel.findOneAndRemove(
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
              message: "Cost Center Deleted!"
            })
          }
        }
      )
    }
  } else {
    res.json({
      message: "The cost center is not set as deleted!"
    })
  }
})

// GET REQUEST - FETCH COST CENTERS
costCentersRoute.get("/fetchCostCenters", (req, res) => {
  costCenterModel.find({}).then((dbItem) => {
    res.send(dbItem)
  })
})

module.exports = costCentersRoute // exports the router when is included
