require 'test/unit'
require 'watir'
class SubmitNewBlogPost < Test::Unit::TestCase
  @@blogHeadline = "All 50 US states as CSV, XML, JSON and XLS files"
  @@blogURL ="http://www.tellingmachine.com/post/all-50-states-as-xml-json-csv-xls-files.aspx"
  @@blogDescription = "<<
  Every now and then I need to work with US states data, but I never seem to find the right format on the interweb. 
  The best I found so far is the following wiki article: http://en.wikipedia.org/wiki/U.S._state. 
  This article provide a download link to a set of flies with states data."
  "
   
  @@blogTags = 
             {".net"              =>    false, 
              "agile"             =>    false,
              "ajax"              =>    false,
              "announcement"      =>    false,
              "apple"             =>    false,
              "books"             =>    false,
              "c-and-cpp"         =>    false,
              "coldfusion"        =>    false,
              "css-html"          =>    false,
              "database"          =>    false,
              "eclipse"           =>    false,
              "flash-flex"        =>    false,
              "frameworks"        =>    false,
              "games"             =>    false,
              "groovy"            =>    false,
              "gui"               =>    false,
              "hardware"          =>    false,
              "how-to"            =>    true,
              "humor"             =>    false,
              "java"              =>    false,
              "javascript"        =>    false,
              "methodology"       =>    false,
              "microsoft"         =>    false,
              "mobile"            =>    false,
              "news"              =>    false,
              "open source"       =>    false,
              "opinion"           =>    false,
              "other languages"   =>    false,
              "perl"              =>    false,
              "php"               =>    false,
              "python"            =>    false,
              "research"          =>    false,
              "reviews"           =>    false,
              "ria"               =>    false,
              "ruby"              =>    true,
              "security"          =>    false,
              "server"            =>    false,
              "standards"         =>    false,
              "tools"             =>    true,
              "trends"            =>    false,
              "unix-linux"        =>    false,
              "usability"         =>    false,
              "web 2.0"           =>    false,
              "web design"        =>    false,
              "web services"      =>    false,
              "windows"           =>    false,
              "xml"               =>    false
             }
            
  def log_in( user_name, password)
    b = get_browser
    b.link(:href, "http://www.dzone.com/links/loginLightbox.html").click
    b.text_field(:name, "j_username").set user_name
    b.text_field(:name, "j_password").set password
    b.checkbox(:name, "_acegi_security_remember_me").clear 
    b.button(:value, "Login").click
  end
   
  def log_out
    b = get_browser
    b.link(:href, "http://www.dzone.com/links/login.html?logout=true").click
  end
 
  def get_browser
    if (@b.nil?)
      @b = Watir::IE.new
    end
    return @b
  end
   
  def is_logged_out
    b = get_browser
    if (b.link(:href, "http://www.dzone.com/links/login.html?logout=true").exists?)
      return false
    else
      return true
    end
  end
   
  def submit_new_article(headline, url, description, tags)
    b = get_browser
    b.link(:href, "http://www.dzone.com/links/add.html").click
    b.text_field(:name, "title").set headline
    b.text_field(:name, "url").set url
    b.text_field(:name, "description").set description
      
    tags.each do | tag, should_be_checked |
      if(should_be_checked)
        b.checkbox(:value, tag).set
      end
    end
    b.button(:value, "Submit" ).click
    return b.url
  end
   
  def promote_blog_post
    b = get_browser
    b.goto("http://www.dzone.com")
    if(!is_logged_out)
      log_out
    end
    log_in("klausg","SillyYouIfYouBelieveThisIsMyRealPassword")
    new_article_url = submit_new_article(@@blogHeadline, @@blogURL, @@blogDescription, @@blogTags)
    log_out
    b.close
  end
         
  def test_promote_blog_post
    promote_blog_post
  end
end