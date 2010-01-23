require 'mechanize'
require 'date'
require 'cgi'

include KinsmenPool::Models

module KinsmenPool
  module Mechanic
    SITE_URL = "http://www.edmonton.ca/attractions_recreation/sport_recreation/kinsmen-full-pool-schedule.aspx"
    
    def self.read_calendar
      agent = WWW::Mechanize.new
      page = agent.get SITE_URL
      
      # Assume a table for each week
      page.search("//table").each do |table|
        dates = []

        # Tables have 9 columns, first two are ignored when getting dates
        # First row of the table has the dates
        rows = table.search("tr")
        header = rows.shift
        headings = header.search('th')
        headings.shift
        headings.shift
        headings.each do |heading|
          dates.push Date.parse(heading.text)
        end

        rows.each do |row|
          pool_name = strip_html(row.search('th').first.inner_html).gsub(/\**$/, '')
          pool = Pool.first(:name => pool_name) || Pool.new(:name => pool_name)
          pool.save

          times = row.search('td')
          info = strip_html(times.shift.text).strip

          i = 0
          times.each do |time|
            pool.clear_date(dates[i])
            times = create_time_pairs(time.children, dates[i])
            times.each do |time|
              pool.pool_events.create(
                :start_time => time.begin,
                :end_time => time.end,
                :info => "")
#                :url => "SITE_URL")
            end
            i += 1
          end
        end
      end
    end
    
    private
      # Strips spaces and line break html nicely
      def self.strip_html(val)
        CGI.unescapeHTML(val.gsub(/\<br\>/, ' ').gsub(/[\s\302\240]+/, ' '))
      end

      def self.create_time_pairs(nodes, base_date)
        pairs = []
        nodes.each do |node|
          case node.name
          when "text"
            pairs << get_time_pair(node.text, base_date)
          when "p", "strong"
            pairs << create_time_pairs(node.children, base_date)
          else
            pairs
          end
        end

        join_pairs(pairs.flatten.compact)
      end
      
      # Assumes dates are always ordered earliest to latest
      def self.join_pairs(pairs)
        return [pairs].compact.flatten if pairs.nil? || pairs.length <= 1

        first = pairs.shift

        if pairs[0].first >= first.first && pairs[0].first <= first.end
          pairs[0] = first.first..pairs[0].end
          join_pairs(pairs).flatten
        else
          [first, join_pairs(pairs)].flatten
        end
      end

      def self.get_time_pair(str, base_date)
        str.gsub!(/\342\200\223/, '-')
        str.gsub!(/\s*([ap]m)/, '\1')
        date = base_date.clone
        arr = str.split(/[\s\302\240]+/)
        if !arr[0].nil?
#          puts "#{str}:#{arr.inspect}"
          arr = arr[0].split('-')
          if !arr[0].nil? && (arr[0].to_i != 0 || arr[0].downcase == 'noon')
            s = arr[0]
            e = arr[1]

            s = "12pm" if s == 'noon'
            e = "12pm" if e == 'noon'
            
            s << e[-2, 2] if s[-1] != 'm'[0]
            return (DateTime.parse("#{s} MST #{base_date.to_s}"))..(DateTime.parse("#{e} MST #{base_date.to_s}"))
          end
        end
        nil
      end
  end
end