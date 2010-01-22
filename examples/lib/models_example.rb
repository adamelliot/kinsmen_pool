require 'examples/example_helper'

describe KinsmenPool::Models::Pool do
  before :each do
    KinsmenPool::Models::Pool.all.destroy!
    KinsmenPool::Models::PoolEvent.all.destroy!
    
    @pool_event = Factory(:pool_event)
    @pool = @pool_event.pool
  end
  
  it "returns a calendar object with one event" do
    @pool.calendar.events.length.should == 1
  end
  
  it "returns a calendar object with the correct pool event" do
    @pool.calendar.events.first.summary.should == @pool.name
  end
  
  focused "clears all the events for a specific date" do
    @pool.clear_date(@pool_event.start_time)
    @pool.pool_events.count.should == 0
  end
end
