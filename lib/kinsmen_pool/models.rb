require 'dm-core'
require 'stringex'
require 'icalendar'
require 'date'
require 'active_support'

include Icalendar

DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3:///Users/adam/Code/ruby/kinsmen_pool/db.sqlite3")

module KinsmenPool
  module Models
    class Pool
      include DataMapper::Resource

      property :id,     Serial
      property :name,   String
      property :slug,   String

      before :save, :sluggify

      def calendar
        cal = Calendar.new
    
        pool = self
        pool_events.each do |pool_event|
          cal.event do
            dtstart     pool_event.start_time
            dtend       pool_event.end_time
            summary     pool.name
            description pool_event.info
            url         pool_event.url
          end
        end
        cal
      end
      
      def clear_date(date)
        pool_events(:start_time.gte => date.midnight, :start_time.lte => date.end_of_day).destroy!
      end
      
      private
        def sluggify
          self.slug = self.name.to_url
        end
    end

    class PoolEvent
      include DataMapper::Resource

      belongs_to :pool

      property :id,         Serial
      property :start_time, DateTime
      property :end_time,   DateTime
      property :all_day,    Boolean,  :default => false
      property :info,       String
      property :url,        String,   :length => 200
    end

    class Pool
      has n, :pool_events
    end
  end
end

DataMapper.auto_migrate!
