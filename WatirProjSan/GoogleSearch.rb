require "watir"


test_site = "http://www.google.com"
browser = Watir::Browser.new
browser.goto test_site
browser.text_field(:name, "q").set "pickaxe" # "q" is the name of the search field
browser.button(:name, "btnG").click # "btnG" is the name of the Search button
puts "  A Google page with results should be shown. 'Programming Ruby' should be high on the list."
if browser.text.include? "Programming Ruby"  
  puts "  Test Passed. Found the test string: 'Programming Ruby'. Actual Results match Expected Results."
else
  puts "  Test Failed! Could not find: 'Programming Ruby'." 
end

