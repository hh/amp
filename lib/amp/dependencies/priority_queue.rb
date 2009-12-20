# A priority queue implementation.
# This extension contains two implementations, a c extension and a pure ruby
# implementation. When the compiled extension can not be found, it falls back
# to the pure ruby extension.
#
# See CPriorityQueue and RubyPriorityQueue for more information.
unless $USE_RUBY
  begin
    require 'amp/CPriorityQueue'
    PriorityQueue = CPriorityQueue
  rescue LoadError # C Version could not be found, try ruby version
    need { 'priority_queue/ruby_priority_queue' }
    Amp::UI.debug "Loading alternative ruby: PriorityQueue"
    PriorityQueue = RubyPriorityQueue
  end
else
  need { 'priority_queue/ruby_priority_queue' }
  PriorityQueue = RubyPriorityQueue
end