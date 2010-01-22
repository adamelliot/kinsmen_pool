Factory.sequence(:pool_name) { |n| "Pool Type #{n}" }

Factory.define(:pool, :class => KinsmenPool::Models::Pool) do |u|
  u.name { Factory.next(:pool_name) }
end

Factory.define(:pool_event, :class => KinsmenPool::Models::PoolEvent) do |pe|
  pe.start_time DateTime.now
  pe.end_time   DateTime.now + 14400
  pe.all_day    false
  pe.info       "Something"
  pe.pool_id    { Factory(:pool).id }
end
