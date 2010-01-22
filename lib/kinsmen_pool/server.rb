require 'sinatra/base'
require 'haml'
require 'sass'

module KinsmenPool
  module Server
    class Base < Sinatra::Base
      enable :logging
      set :root, File.dirname(__FILE__)

      configure do
        set :haml, {:format => :html5 }
      end

      configure :production do
        set :sass, {:style => :compact }
      end
      
      get '/' do
        haml :index
      end

      get '/diving.ics' do
        KinsmenPool::Models::Pool.all[5].calendar.to_ical
      end

      get '/application.css' do
        content_type 'text/css', :charset => 'utf-8'
        sass :application
      end
    end
  end
end