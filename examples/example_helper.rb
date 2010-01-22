$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'micronaut'
require 'kinsmen_pool'
require 'factory_girl'

require File.expand_path(File.dirname(__FILE__)) + '/factories'

def not_in_editor?
  !(ENV.has_key?('TM_MODE') || ENV.has_key?('EMACS') || ENV.has_key?('VIM'))
end

Micronaut.configure do |c|
  c.color_enabled = not_in_editor?
  c.filter_run :focused => true
end

