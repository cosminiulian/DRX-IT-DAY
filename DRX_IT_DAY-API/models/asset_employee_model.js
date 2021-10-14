var mongoose = require("mongoose") // include mongoose

// Schema for Asset
var assetSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  startDate: { type: String, required: true },
  endDate: { type: String, required: true }
})

// Schema for AssetEmployee
var assetEmployeeSchema = new mongoose.Schema({
  employeeName: { type: String, required: true },
  costCenterId: { type: Number, required: true },
  fromCountry: { type: String, required: true },
  toCountry: { type: String, required: true },
  asset: assetSchema
})

// Creates the AssetEmployee Model
const assetEmployeeModel = mongoose.model("assetEmployee", assetEmployeeSchema)

// Exports datas to be used in other files
module.exports.assetEmployeeSchema = assetEmployeeSchema
module.exports.assetEmployeeModel = assetEmployeeModel
