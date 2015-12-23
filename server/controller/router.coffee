# ==============================================================================
#  This file defines the middleware that will handle all the routes of the
#  application using express framework
# ==============================================================================

express = require 'express' # Route management framework
morgan  = require 'morgan'  # Log requests to the console
path    = require 'path'    # Path handler

# Set up configuration
environment = process.env.NODE_ENV
staticPath  = path.normalize(path.join(__dirname + "../../../" + "public/dist"))

# Express configuration (order does matter)
router = express()
router
  .use express.static(staticPath)
  .use morgan('dev', { skip: (req, res) -> environment is 'test' })
  .get '/', (req, res) -> res.sendFile('index.html', { 'root': staticPath })

module.exports = router
