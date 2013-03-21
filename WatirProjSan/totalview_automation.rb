#!/usr/local/bin/ruby
require 'rubygems'
require 'watir'
require 'firewatir'
require 'fileutils'
require 'win32ole'
require 'zip/zip'

class Totalview_automation

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

    

    def runthis
      
        #run_for_all_eligible_students
        #i=0
        login
        click_students_tab
        run_for_all_eligible_students
        #fill_student_id
        #search_student
        #click_student_name
        #click_withdraw_student
        #pop_upwindow
        #withdraw_eligible
        
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
    
    def click_students_tab
      link = "/html/body/div/div[2]/div/div/div/ul/li[5]/a/div"
      textt = "Students"
       if browser.text.include? textt
          browser.link(:text, textt).click
           complete = true
       end
    end
    
    
    def run_for_all_eligible_students
      
      pids = $tables.attach("Withdrawing").withdrawing_eligible_pids
      
      pids.each{ |pid|
        
        withdrawing_table_record = $tables.attach("Withdrawing").by_primaryid(pid)
        
        student_id      = withdrawing_table_record.fields["student_id"].value
        agora_reason    = withdrawing_table_record.fields["agora_reason"].value
        k12_reason      = withdrawing_table_record.fields["k12_reason"].value
        effective_date  = withdrawing_table_record.fields["effective_date"].value
        
        effective_date_modified = Date.parse(effective_date.to_s).strftime("%m/%d/%Y")
        
        withdraw_reason_table = $tables.attach("WITHDRAW_REASONS").reason_by_code(k12_reason)
        reason = withdraw_reason_table.value
        
        k12_reason_modified = k12_reason +" "+"-"+" "+ reason
        
        fill_student_id
        search_student
        click_student_name
        click_withdraw_student
        pop_upwindow(k12_reason_modified,effective_date_modified,agora_reason)
      }
      
      
      
    end
    
    def fill_student_id
        link = "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[3]/td[2]/input"
        field_name = "0.17.1.1.3.1940662712.0.9.0.0.3.1.0.1.1.5.1.7"
        
        student_id = "2578"
        field_found = false
            until field_found
                if browser.text_field(:name, field_name).exists?
                    browser.text_field(:name, field_name).set student_id
                    field_found = true
                end
            end
    end
    
    def fill_student_idd(student_id)
        link = "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[3]/td[2]/input"
        field_name = "0.17.1.1.3.1940662712.0.9.0.0.3.1.0.1.1.5.1.7"
        
        #student_id = "2578"
        field_found = false
            until field_found
                if browser.text_field(:name, field_name).exists?
                    browser.text_field(:name, field_name).set student_id
                    field_found = true
                end
            end
    end
    
    def click_student_name
        link = "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/form/div/div/div/table/tbody/tr[2]/td[3]/a"
        complete = false
        until complete
            if browser.link(:xpath, link).exists?
                browser.cell(:xpath, link).click
                complete = true
            end
        end
    end
      
    def click_withdraw_student
        link_path  = "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/div[2]/ul/li[3]/a"
        
        complete = false
        until complete
            if browser.link(:xpath, link_path).exists?
                browser.link(:xpath, link_path).click
                complete = true
            end
        end
    end
    
    #tries = 0
    #div_id = "withdrawalUpdateContainer"
    #until browser.div(:id, div_id).exists? do
    #  sleep 1
    #  tries += 1
    #end
    #
    def pop_upwindow(k12_reason_modified,effective_date_modified,agora_reason)
      
        tries = 0
        div_id = "withdrawalUpdateContainer"
        until browser.div(:id, div_id).exists? do
          sleep 1
          tries += 1
        end
                
        teacher_initiated_name    = "0.17.1.1.3.1940662712.0.9.0.0.3.1.0.3.1.1.0.0.0.13.7.3.1.1.5.1.7"
        
        if browser.select_list(:name, teacher_initiated_name).exists?
          browser.select_list(:name, teacher_initiated_name).select("Teacher Initiated")
          complete = true
        end
        
        withdraw_reason_name      = "0.17.1.1.3.1940662712.0.9.0.0.3.1.0.3.1.1.0.0.0.13.7.3.1.1.5.1.9"
        #k12_reason = "A1 - Curriculum/Material"
        #k12_reason_modified
        
        if browser.select_list(:name, withdraw_reason_name).exists?
          browser.select_list(:name, withdraw_reason_name).select(k12_reason_modified)
          complete = true
        end
        
        school_withdraw_date_name  = "0.17.1.1.3.1940662712.0.9.0.0.3.1.0.3.1.1.0.0.0.13.7.3.1.1.5.1.13"
        #effective_date = "12/18/2012"
        #effective_date_modified
        
        if browser.text_field(:name, school_withdraw_date_name).exists?
          browser.text_field(:name, school_withdraw_date_name).set effective_date_modified
          field_found = true
        end
        
        transferring_to_name = "0.17.1.1.3.1940662712.0.9.0.0.3.1.0.3.1.1.0.0.0.13.7.3.1.1.5.1.15"
        #agora_reason = "7"
        
        if browser.text_field(:name, transferring_to_name).exists?
          browser.text_field(:name, transferring_to_name).set agora_reason
          field_found = true
        end
        
        withdraw_button_value = "Withdraw"
        cancel_button_value   = "Cancel"     
 
        browser.button(:value, cancel_button_value).click #replace cancel_button_value with withdraw_button_value
        
    end
    
    def login
        if !structure["login"]
          
            #enter username
            field = "username"
            field_found = false
            until field_found
                if browser.text_field(:name, field).exists?
                    browser.text_field(:name, field).set "jeniferhalverson"
                    field_found = true
                end
            end
            
            #enter password
            field = "password"
            field_found = false
            until field_found
                if browser.text_field(:name, field).exists?
                    browser.text_field(:name, field).set "password"
                    field_found = true
                end
            end
            
            #submit
            submit = "Login"
            browser.button(:value, submit).click
        end
        return structure["login"]
    end
   
    def start
        if !structure["start"]
            Watir::Browser.default = "firefox"
            session = Watir::Browser.new
            sleep 2
            session.goto("https://totalviewschool.k12.com")
            structure["browser"] = session
            structure["started"] = true
        end
        return structure["start"]
    end
    
    def search_student
        button_name ="submitButtonSearch"
        complete = false
        until complete
            if browser.button(:name, button_name).exists?
                browser.button(:name, button_name).click
                complete = true
            end
        end
    end
    
end
