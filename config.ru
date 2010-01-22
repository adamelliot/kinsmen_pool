$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'kinsmen_pool'

run KinsmenPool::Server::Base
