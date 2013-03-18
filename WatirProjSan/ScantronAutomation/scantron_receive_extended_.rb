#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("web_scraping","base/base")

class Scantron_receive_extended < Base
  
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def initialize(args)
    super()
    
    #require "#{$config.base_path}scantron_performance_interface"
    #i = Scantron_Performance_Interface.new
    #success = i.email_checking
    
    
    require "#{$config.base_path}scantron_performance_interface"
    i = Scantron_Performance_Interface.new
    i.download_ordered_file
    
    
    
  end
  #---------------------------------------------------------------------------
  
  

end

Scantron_receive_extended.new(ARGV)