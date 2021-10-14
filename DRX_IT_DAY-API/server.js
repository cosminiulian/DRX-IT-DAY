const express = require("express") // use express to create our server
const bodyParser = require("body-parser") // body parser
const morgan = require("morgan") // morgan = show on console the type of request made
const mongoose = require("mongoose") // include mongoose db
const employeesRoute = require("./routes/employees_routes.js") // include routes for employees
const costCentersRoute = require("./routes/cost_centers_routes.js") // include routes for cost centers
const assetsEmployeeRoute = require("./routes/assets_employee_routes.js") // include routes for assets

require("dotenv").config() // include '.env' file

var app = express() // load our app server using express
app.use(bodyParser.urlencoded({ extended: true })) // apply body parser as urlencoded type
app.use(bodyParser.json()) // as json
app.use(bodyParser.raw()) // as raw data
app.use(morgan("short")) // use the short version of morgan
app.use(employeesRoute) //  use
app.use(costCentersRoute) //  included
app.use(assetsEmployeeRoute) //    routes

// Connection to mongoDB (Locally in our case)
mongoose.connect("mongodb://localhost/drxITDayDB", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  useFindAndModify: false
})
mongoose.connection
  .once("open", () => {
    console.log("Connected to DB!")
  })
  .on("error", (error) => {
    console.log("Failed to connect: " + error)
  })

/* 
  URL FORMAT: http://<IP_ADRESS>:<PORT>
 */
var server = app.listen(process.env.PORT, process.env.IP_ADDRESS, () => {
  console.log("Server is running!")
})
