require 'active_record'
require './lib/employee'
require './lib/division'
require './lib/project'
require './lib/big_deal'
require './lib/contribution'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "Welcome to the Employee Tracker!\n\n"
  menu
end

def menu
  choice = nil
  until choice == 'x'
    puts "Press 'a' to add an Employee, 'b' to create a project/add an employee to a project, 
    'c' to view employee information,'d' to search for employees, divisions, or projects, press 'e' to create a 
    Big Deal/add an employee to a Big Deal, press 'f' to provide a description of an employee's contribution
    to a Big Deal, or press 'g' to view the contributions of an employee to a Big Deal or all contributions made to a Big Deal.\n"
    puts "Press 'x' to exit."
    choice = gets.chomp
    case choice
    when 'a'
      add_employee
    when 'b'
      add_employee_to_project
    when 'c'
      show_employees
    when 'd'
      search_employees
    when 'e'
      add_employee_to_big_deal
    when 'f'
      add_contribution
    when 'g'
      search_contributions
    when 'x'
      puts "Good-bye!"

    else
      puts "Sorry, that wasn't a valid option."
    end
 end
end

def add_employee
  puts "What is the name of the employee you want to add?"
  employee_name = gets.chomp
  puts "What division is this employee in?"
  division_name = gets.chomp
  if Division.where(name: division_name).exists?  #alternative syntax: name => division_name. colon before name is not necessary without hash rocket. Appropriate to use (name: division_name) so long as key is not required to be in quotes (ie, {"John" => "good_friend"}) Note other alternative: Division.exists?({:name => division_name})  #If division already exists, don't add.  See: http://guides.rubyonrails.org/active_record_querying.html
    division = Division.where({:name => division_name}).first  #ie, if the division already exists, then the division for purposes of this entry will be the division where the name is division_entry
  else
    division = Division.new({:name => division_name})  #different syntaxes on hashes used here for illustrative purposes
    division.save
  end
  employee = Employee.new({name: employee_name, division_id: division.id})
  employee.save
  puts "#{employee_name} has been saved as an employee, in the #{division_name} division"
end

def add_employee_to_project
  puts "Would you like to create a project only at this time (press 'a'), or add an employee to a new or existing project (press 'b')"
  choice = gets.chomp.downcase
  case choice
  when 'a'
      puts "What is the name of the project you want to create?"
      project_name = gets.chomp
      project = Project.new({:name => project_name}) 
      puts "#{project_name} has been created."
      puts "Press 'x' to do further action with respect to projects, or 'y' to return to the main menu"
        if gets.chomp == 'x'
          add_employee_to_project
        elsif gets.chomp == 'y'
          menu
        end
  when 'b'
      puts "What is the name of the project to which you want to add an employee"
      project_name = gets.chomp
      loop do
        puts "What is the name of the employee to be added to a project"
        employee = Employee.where({:name => gets.chomp}).first
        if Project.where(name: project_name).exists?  
          project = Project.where({:name => project_name}).first  
        else
          project = Project.new({:name => project_name})
          project.save 
        end
        project.employees << @employee
        puts "The employee has been added to #{project_name}"
        puts "Would you like to add another employee to #{project_name}? (y/n)"
       break if gets.chomp == 'n'
      end
        puts "Would you like to add employees to another project? (y/n)"
        if gets.chomp == 'y'
          add_employee_to_project
        elsif gets.chomp == 'n'
          menu
       end
    else
      puts "Sorry, invalid option"
    end
end

def show_employees
  puts "Here are (i) all of the employees, (ii) the divisions they are in and (iii) the projects they are working on:\n\n"
  employees = Employee.all
  employees.each {|employee| puts "#{employee.id}: #{employee.name}, Division: #{employee.division.name}, 
     Projects: #{employee.project_name}\n" }
end

def search_employees
  puts "Please enter the name of the employee you want to search for\n"
  entered_name = gets.chomp
  if Employee.where(name: entered_name).exists?  
      employee = Employee.where({:name => entered_name}).first
      puts "#{employee.id}: #{employee.name}, Division: #{employee.division.name}, 
        Projects: #{employee.project_name}\n"
   else
      puts "We do not find an employee with than name."
   end
   puts "Would you like to search again? (y/n)"
     if gets.chomp == 'y'
      search_employees
     elsif gets.chomp == 'n'
      menu
     end
end

def add_employee_to_big_deal
  puts "Would you like to create a Big Deal only at this time (press 'a'), or add an employee to a new or existing Big Deal (press 'b')"
  choice = gets.chomp.downcase
  case choice
  when 'a'
      puts "What is the name of the Big Deal you want to create?"
      bigdeal_name = gets.chomp
      big_deal = BigDeal.new({:name => bigdeal_name}) 
      puts "#{bigdeal_name} has been created."
      puts "Press 'x' to do further action with respect to Big Deals, or 'y' to return to the main menu"
        if gets.chomp == 'x'
          add_employee_to_big_deal
        elsif gets.chomp == 'y'
          menu
        end
  when 'b'
      puts "What is the name of the Big Deal to which you want to add an employee"
      bigdeal_name = gets.chomp
      loop do
        puts "What is the name of the employee to be added to a Big Deal"
        employee_name = gets.chomp
        if Employee.where(name: employee_name).exists?  
          employee = Employee.where({:name => employee_name}).first  
        else
          employee = Employee.new({:name => employee_name})
          employee.save 
        end
        if BigDeal.where(name: bigdeal_name).exists?  
          big_deal = BigDeal.where({:name => bigdeal_name}).first  
        else
          big_deal = BigDeal.new({:name => bigdeal_name})
          big_deal.save 
        end
        big_deal.employees << employee
        puts "#{employee_name} has been added to #{bigdeal_name}"
        puts "Would you like to add another employee to #{bigdeal_name}? (y/n)"
       break if gets.chomp == 'n'
      end
        puts "Would you like to add employees to another Big Deal? (y/n)"
        if gets.chomp == 'y'
          add_employee_to_big_deal
        elsif gets.chomp == 'n'
          menu
       end
    else
      puts "Sorry, invalid option"
    end
end

def add_contribution
  puts "Please enter the name of the Big Deal to which you want to add the contribution"
    bigdeal_name = gets.chomp
         if BigDeal.where(name: bigdeal_name).exists?  
          big_deal = BigDeal.where({:name => bigdeal_name}).first  
        else
          big_deal = BigDeal.new({:name => bigdeal_name})
          big_deal.save 
        end
   puts "What is the name of the employee who has made the contribution?"
        employee_name = gets.chomp
        if Employee.where(name: employee_name).exists?  
          employee = Employee.where({:name => employee_name}).first  
        else
          employee = Employee.new({:name => employee_name})
          employee.save 
        end
    if !big_deal.employees.where(name:employee_name).exists?
        big_deal.employees << employee
    end
    puts "Please add a description for the contribution"
      contribution_description = gets.chomp
      new_contribution = Contribution.new({:description => contribution_description, :big_deal_id => big_deal.id, 
        :employee_id => employee.id})
      new_contribution.save
    puts "#{contribution_description} has been added as a contribution of #{employee_name} to #{bigdeal_name}"
    menu
end

def search_contributions
  puts "Here, you can search for contributions made by a given employee, or search for the contributions associated
  with a given Big Deal. \n"
  puts "Would you like to search by employee (press 'a') or by Big Deal (press 'b')?\n" 
  if gets.chomp == 'a'
    puts "Please enter the name of the employee whose contributions you want to view"
    employee_name = gets.chomp
    employee = Employee.where({:name => employee_name}).first
    employee.contributions.each_with_index {|contribution, index| puts "#{index + 1}: Contribution Id: #{contribution.id}. Big Deal: #{contribution.big_deal.name}, Contribution: #{contribution.description}\n"}
    puts "Press 'c' to search again, or 'd' to return to the main menu"
      if gets.chomp == 'c'
        search_contributions
      elsif gets.chomp == 'd'
         menu
      end
  elsif gets.chomp == 'b'
    puts "Please enter the name of the Big Deal whose contributions you want to view. \n"
    bigdeal_name = gets.chomp
    big_deal = BigDeal.where({:name => bigdeal_name}).first
    big_deal.contributions.each_with_index {|contribution, index| puts "#{index + 1}: Contribution Id: #{contribution.id}: Contribution: #{contribution.description}, Employee: #{contribution.employee.name}, Updated at: #{contribution.updated_at} \n" }
      puts "Press 'c' to search again, or 'd' to return to the main menu"
      if gets.chomp == 'c'
        search_contributions
      elsif gets.chomp == 'd'
         menu
      end
  end
 end
welcome