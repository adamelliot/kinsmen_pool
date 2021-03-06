require 'sinatra/base'
require 'haml'
require 'sass'

module KinsmenPool
  module Server
    class Base < Sinatra::Base
      enable :logging, :static
      set :root, File.dirname(__FILE__)

      configure do
        set :haml, {:format => :html5 }
      end

      configure :production do
        set :sass, {:style => :compact }
      end
      
      get '/' do
        @pools = KinsmenPool::Models::Pool.all
        haml :index
      end

      get %r{/([^\.\/]*).ics} do
        pool = KinsmenPool::Models::Pool.first(:slug => params[:captures].first)
        halt 404, 'No calendar like that...' if pool.nil?
        pool.calendar.to_ical
      end

      get '/application.css' do
        content_type 'text/css', :charset => 'utf-8'
        sass :application
      end

      not_found do
        "Not sure what you're looking for, but I don't think it's here..."
      end
    end
  end
end