$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'rubygems'
require 'kinsmen_pool'

KinsmenPool::Server::Base.run! :environment => :development