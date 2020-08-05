# require './my_app'
# run MyApp.new

require './my_rack_middleware'
require './start'

use Rack::Reloader
use MyRackMiddleware

run Sinatra::Application
