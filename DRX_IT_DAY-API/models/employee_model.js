var mongoose = require("mongoose") // include mongoose db

// Schema for Employee
var employeeSchema = new mongoose.Schema({
  name: { type: String, required: true },
  costCenterId: { type: Number, required: true }
})

// Creates the Employee Model
const employeeModel = mongoose.model("employee", employeeSchema)

// Exports data to be used in other files
module.exports = employeeModel
