#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("web_scraping","base/base")

class Scantron_order_extended < Base
  
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def initialize(args)
    super()
    
    require "#{$config.base_path}scantron_performance_interface"
    i = Scantron_Performance_Interface.new
    i.order_extended_report
    
  end
  #---------------------------------------------------------------------------

end

Scantron_order_extended.new(ARGV)