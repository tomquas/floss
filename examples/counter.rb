$: << File.expand_path('../../lib', __FILE__)

require 'floss/proxy'

class Counter
  attr_accessor :count

  def initialize
    self.count = 0
  end

  def get
    count
  end

  def reset
    self.count = 0
  end

  def increase(amount = 1)
    self.count += amount
  end
end


addresses = [10001, 10002, 10003].map { |port| "tcp://127.0.0.1:#{port}" }

$nodes = addresses.size.times.map do |i|
  combination = addresses.rotate(i)
  options = {id: combination.first, peers: combination[1..-1]}
  Floss::Proxy.new(Counter.new, options)
end

# Give your nodes some time to start up.
#$nodes.each(&:wait_until_ready)


$nodes.sample.reset
$nodes.sample.increase
100.times do |i|
  $nodes.sample.get
end

# sleep 30
