$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'rubygems'
require 'kinsmen_pool'

run KinsmenPool::Server::Base
