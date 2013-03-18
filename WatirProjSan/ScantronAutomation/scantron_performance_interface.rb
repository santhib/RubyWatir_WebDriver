
#.........................................................................
#
# Author      : Santhi B
# Description : Automation of the scantron project. The main purpose of the project is 
#               to automate the steps that we perform everyday to download reports from 
#               their main server. 
# Steps       : Traverse thorough the web browser, then request the reports, wait for
#               an email conformation,check email for report ready status, again traverse
#               through through the website to enter downloads section, download the file,
#               rename it, move to destination folder, load into database.
#.........................................................................

#!/usr/local/bin/ruby
require 'rubygems'
require 'watir'
require 'firewatir'
require 'fileutils'
require 'win32ole'
require 'zip/zip'

class Scantron_Performance_Interface

    #---------------------------------------------------------------------------
    def initialize()
        @structure = structure
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    

    def download_scores
        login
        link_district_reports
        link_performance_current_scores
        link_students_all_subjects
        excel_student_all_subjects
        success = download_complete?("#{$config.temp_path}/scores.csv")
        browser.close
        return success
    end
    
    def email_checking
       
        outlookk = WIN32OLE.new('Outlook.Application')
        mapi = outlookk.GetNameSpace('MAPI')
        inbox = mapi.GetDefaultFolder(6)
        
        inbox.Items.each do |message|
          
            if message.Subject == "FW: A file is ready for you to download"
                message_content = message.Body
                #puts message_content
                if !message_content.empty?
                    @file_name = message_content.split("Filename:")[1].split("Description:")[0].strip
                    time_from_email = message_content.split("Requested At:")[1].split("(Pacific Time)")[0].strip
                    est_time = $db.get_data_single("SELECT DATE_ADD( '#{time_from_email}', INTERVAL +3 HOUR ) " )
                    d = DateTime.parse("#{est_time[0]}")
                    @time_web_format = d.strftime("%m/%-d/%y %l:%M")
                    
                    
                    puts @file_name
                    puts time_from_email
                    puts @time_web_format
                    download_ordered_file(@time_web_format)
                end
                t= Time.new
                message.Subject = message.Subject + t.strftime(" On %m/%d/%Y at %I:%M%p")
                return @file_name
            end
        end
    end

    def order_extended_report
        login
        link_performance_tests
        link_Student_scores_export_create
        radio_extended_scores
        export_parameters_select_startdate
        export_parameters_select_enddate
        submit_form_ok_button
        task_completed
        browser.close
    end
    
    def download_ordered_file
        #login
        #link_preferences_files
        ##download_file_after_email
        #download_file
        #extract_and_save_to_imports
        $tables.attach("SCANTRON_PERFORMANCE_EXTENDED").load
        #$reports.move_to_athena_reports(file_path)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure(struct_hash = nil)
        if @structure.nil?
            @structure = Hash.new
            set_structure(struct_hash) if !struct_hash.nil?
        end
        @structure
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def browser
        if !structure["browser"]
            start
        end
        return structure["browser"]
    end
    
    def download_complete?(file_path)
        i = 0
        complete = false
        until complete
            if File.exists?( file_path ) && !File.exists?( "#{ file_path }.part" )
                complete = true
            else
                if i == 5 || browser.link(:text, "Home Page").exists?
                    return false
                end
                sleep 60
                i+=1
            end
        end
        return true
    end
    
    def download_file_after_email
      link = "/html/body/form/table[5]/tbody/tr/td/table/tbody/tr/td/table[4]/tbody/tr[2]/td/table/tbody/tr[2]/td[2]/span/table/tbody/tr[2]/td[6]/span/a"
      if browser.text.include? @time_web_format
        browser.cell(:xpath, link).click
      end
      
    end
    
     def download_file
      link = "/html/body/form/table[5]/tbody/tr/td/table/tbody/tr/td/table[4]/tbody/tr[2]/td/table/tbody/tr[2]/td[2]/span/table/tbody/tr[2]/td[6]/span/a"
      #if browser.text.include? @time_web_format
        browser.cell(:xpath, link).click
      #end
      
    end
    
    def excel_student_all_subjects
        link = "/html/body/form/table[5]/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/table[2]/tbody/tr/td/table[2]/tbody/tr/td/table/tbody/tr/td[2]/a"
        complete = false
        until complete
            if browser.link(:xpath, link).exists?
                browser.cell(:xpath, link).click
                complete = true
            elsif browser.link(:text, "Home Page").exists?
                return false
            end
        end
    end
    
    def export_parameters_select_startdate
        #link = "/html/body/form/table[5]/tbody/tr/td/table/tbody/tr/td/table[4]/tbody/tr[2]/td/table/tbody/tr[3]/td[2]/span/select"
        
        month   = "StartMonth"
        day     = "StartDay"
        year    = "StartYear"
        
        start_date  = $school.current_school_year_start.mathable
        start_month = start_date.strftime("%B")
        start_day   = start_date.strftime("%d")[0].chr == "0" ? start_date.strftime("%d").delete("0") : start_date.strftime("%d")
        start_year  = start_date.strftime("%Y")
        
        if browser.select_list(:name, month).exists?
          browser.select_list(:name, month).select(start_month)
          complete = true
        end
        
        if browser.select_list(:name, day).exists?
          browser.select_list(:name, day).select(start_day)
          complete = true
        end
        
        if browser.select_list(:name, year).exists?
          browser.select_list(:name, year).select(start_year)
          complete = true
        end
        
    end
    
    def export_parameters_select_enddate
       #link = "/html/body/form/table[5]/tbody/tr/td/table/tbody/tr/td/table[4]/tbody/tr[2]/td/table/tbody/tr[3]/td[2]/span/select"
        
        month = "EndMonth"
        day = "EndDay"
        year = "EndYear"
        select_field_found = false
        
        end_date  = $base.today.mathable
        end_month = end_date.strftime("%B")
        end_day   = end_date.strftime("%d")[0].chr == "0" ? end_date.strftime("%d").delete("0") : end_date.strftime("%d")
        end_year  = end_date.strftime("%Y")
        
          if browser.select_list(:name, month).exists?
            browser.select_list(:name, month).select(end_month)
            complete = true
          end
          
          if browser.select_list(:name, day).exists?
            browser.select_list(:name, day).select(end_day)
            complete = true
          end
          
          if browser.select_list(:name, year).exists?
            browser.select_list(:name, year).select(end_year)
            complete = true
          end
          
      
    end
    
    def extract_and_save_to_imports
        if File.exists?("#{$config.imports_path}scantron_performance_extended_#{$filestamp}")
            File.rename("#{$config.imports_path}scantron_performance_extended_#{$filestamp}","#{$config.imports_path}scantron_performance_extended")
        end
        extract_path    = $config.init_path("#{$config.imports_path}scantron_performance_extended")
        file_path       = "#{extract_path}StudentResultsExport_Extended.csv"
        #EXPLICIT PATH DOWNLOAD FOLDER!!!
        zipfile_path    = "C:/Users/Perseus/Downloads/StudentResultsExport_Extended.zip"
        Zip::ZipFile.open(zipfile_path) do |zip_file|
            zip_file.extract('StudentData_Extended.csv', file_path)
        end
    end
    
    
    def link_district_reports
        link = "/html/body/table[5]/tbody/tr/td/table/tbody/tr/td/table[2]/tbody/tr/td/table/tbody/tr[2]/td/a/img"
        complete = false
        until complete
            if browser.link(:xpath, link).exists?
                browser.cell(:xpath, link).click
                complete = true
            end
        end
    end
    
    def link_performance_current_scores
        link = "/html/body/table[5]/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/table[2]/tbody/tr[9]/td/span/a"
        complete = false
        until complete
            if browser.link(:xpath, link).exists?
                browser.cell(:xpath, link).click
                complete = true
            end
        end
    end
    
    def link_performance_tests
        link = "/html/body/table[2]/tbody/tr/td[6]/a"
        complete = false
        until complete
            if browser.link(:xpath, link).exists?
                browser.cell(:xpath, link).click
                complete = true
            end
        end
    end
    
    def link_preferences_files
       #login
       link1 = "/html/body/table[4]/tbody/tr[2]/td[2]/table[2]/tbody/tr/td/a/img"
        complete = false
        until complete
            if browser.link(:xpath, link1).exists?
                browser.cell(:xpath, link1).click
                complete = true
            end
        end
        link2 = "/html/body/form/table[5]/tbody/tr/td/table/tbody/tr/td/table[3]/tbody/tr/td[10]/a/span/span"
        if browser.link(:xpath, link2).exists?
          browser.cell(:xpath, link2).click
          #complete = true
        end
    end
    
    def link_students_all_subjects
        link = "/html/body/table[5]/tbody/tr/td/table/tbody/tr/td[2]/table[2]/tbody/tr/td/table/tbody/tr[4]/td[2]/table/tbody/tr/td[2]/a"
        complete = false
        until complete
            if browser.link(:xpath, link).exists?
                browser.cell(:xpath, link).click
                complete = true
            end
        end
    end
    
    def link_Student_scores_export_create
        link = "/html/body/table[5]/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/table[2]/tbody/tr[16]/td/span/a[2]"
        complete = false
        until complete
            if browser.link(:xpath, link).exists?
                browser.cell(:xpath, link).click
                complete = true
            end
        end
    end
    
    def login
        if !structure["login"]
            #enter sitecode
            field = "SiteCode"
            field_found = false
            until field_found
                if browser.text_field(:name, field).exists?
                    browser.text_field(:name, field).set "72-7452-9700"
                    field_found = true
                end
            end
            #enter username
            field = "Username"
            field_found = false
            until field_found
                if browser.text_field(:name, field).exists?
                    browser.text_field(:name, field).set "1044540"
                    field_found = true
                end
            end
            #enter password
            field = "Password"
            field_found = false
            until field_found
                if browser.text_field(:name, field).exists?
                    browser.text_field(:name, field).set "PassW0rd"
                    field_found = true
                end
            end
            #submit
            submit = "Login"
            browser.button(:value, submit).click
        end
        return structure["login"]
    end
    
    def radio_extended_scores
      link = "/html/body/form/table[5]/tbody/tr/td/table/tbody/tr/td/table[4]/tbody/tr[2]/td/table/tbody/tr/td[2]/span/input[2]"
       if browser.link(:xpath, link).exists?
           browser.radio(:xpath, link).set
           complete = true
       end
    end
    
    def start
        if !structure["start"]
            Watir::Browser.default = "firefox"
            session = Watir::Browser.new
            sleep 2
            session.goto("https://admin.edperformance.com")
            structure["browser"] = session
            structure["started"] = true
        end
        return structure["start"]
    end
    
    def submit_form_ok_button
        #link = "/html/body/table[5]/tbody/tr/td/table/tbody/tr/td[2]/table[2]/tbody/tr/td/table/tbody/tr[4]/td[2]/table/tbody/tr/td[2]/a"
        complete = false
        until complete
            if browser.button(:id, "btnOk").exists?
                browser.button(:id, "btnOk").click
                complete = true
            end
        end
    end
    
    #def task_completed
    #    t = Time.now                      
    #    $time_minutes = t.strftime(":%M")            #=> "at :37"
    #    #puts time_minutes
    #    if browser.text.include? $time_minutes
    #        puts "Task completed"
    #        $timee = t.strftime("%Y-%m-%d")
    #    end    
    #end
    
    #def task_completed
    #    
    #    time_ordered = browser.table(:class => "List").cell(:class => "ListContent").value
    #    t = Time.now                      
    #    $time_minutes = t.strftime(":%M")            #=> "at :37"
    #    #puts time_minutes
    #    if browser.text.include? $time_minutes
    #        puts "Task completed"
    #        $timee = t.strftime("%Y-%m-%d")
    #    end    
    #end
    #
    
end