var mongoose = require("mongoose") // include mongoose db

// Schema for CostCenter
var costCenterSchema = new mongoose.Schema({
  _id: { type: Number, required: true },
  name: { type: String, required: true },
  managerName: { type: String, required: true },
  isDeleted: { type: Boolean, required: true, default: false }
})

// Creates the CostCenter Model
const costCenterModel = mongoose.model("costCenter", costCenterSchema)

// Exports data to be used in other files
module.exports = costCenterModel
