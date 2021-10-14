var employeeModel = require("../models/employee_model") // include employee model

const express = require("express")
const employeesRoute = express.Router() // create custom router

// POST REQUEST: - CREATE EMPLOYEE
employeesRoute.post("/addEmployee", (req, res) => {
  var employee = new employeeModel({
    name: req.body.name,
    costCenterId: req.body.costCenterId
  })

  employee.save().then(() => {
    if (employee.isNew == false) {
      // if the data is saved on the server and database then return false
      res.json({
        message: "Employee created successfully!"
      })
    } else {
      res.json({
        message: "Failed to save the employee!"
      })
    }
  })
})

// PUT REQUEST: - UPDATE EMPLOYEE
employeesRoute.put("/updateEmployee", (req, res) => {
  if (req.body.id != null) {
    employeeModel.findOneAndUpdate(
      {
        _id: req.body.id
      },
      {
        name: req.body.name,
        costCenterId: req.body.costCenterId
      },
      (error) => {
        if (error != null) {
          res.json({
            error: "Failed to update employee: " + error
          })
        } else {
          res.json({
            message: "Employee Updated!"
          })
        }
      }
    )
  }
})

// DELETE REQUEST: - DELETE EMPLOYEE
employeesRoute.delete("/deleteEmployee", (req, res) => {
  if (req.body.id != null) {
    // Find the employee with that specific id and delete it
    employeeModel.findOneAndRemove(
      {
        _id: req.body.id
      },
      (error) => {
        if (error != null) {
          res.json({
            error: "Failed to delete employee: " + error
          })
        } else {
          res.json({
            message: "Employee Deleted!"
          })
        }
      }
    )
  }
})

// GET REQUEST - FETCH ALL EMPLOYEES
employeesRoute.get("/fetchEmployees", (req, res) => {
  employeeModel.find({}).then((dbItem) => {
    res.send(dbItem)
  })
})

module.exports = employeesRoute // exports the router when is included
