require 'active_record'
require './lib/employee'
require './lib/division'
require './lib/project'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "Welcome to the Employee Tracker!"
  menu
end

def menu
  choice = nil
  until choice == 'e'
    puts "Press 'a' to add an Employee, 'b' to create a project/add an employee to a project, 'c' to view employee information, 
    'd' to search for employees, divisions, or projects,"
    puts "Press 'e' to exit."
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


    else
      puts "Sorry, that wasn't a valid option."
    end
  end
end

def add_employee
  puts "What is the name of the employee to be added?"
  employee_name = gets.chomp
  puts "What division is this employee in?"
  division_name = gets.chomp
  if Division.where(name: division_name).exists?  #alternative syntax: name => division_name. colon before name is not necessary without hash rocket. Appropriate to use (name: division_name) so long as key is not required to be in quotes (ie, {"John" => "good_friend"}) Note other alternative: Division.exists?({:name => division_name})  #If division already exists, don't add.  See: http://guides.rubyonrails.org/active_record_querying.html
    division = Division.where({:name => division_name}).first  #ie, if the division already exists, then the division for purposes of this entry will be the division where the name is division_entry
  else
    division = Division.new({:name => division_name})  #different syntaxes on hashes used here for illustrative purposes
    division.save
  end
  employee = Employee.new({name: employee_name, division: division_name})
  employee.save
  puts "#{employee_name} has been saved as an employee, in the #{division_name} division"
end

def add_employee_to_project
  puts "Would you like to create a project only at this time (press 'a'), or add an employee to a new or existing project (press 'b')"
  if gets.chomp == 'a'
      puts "What is the name of the project you want to create?"
      project_name = gets.chomp
      project = Project.new({:name => project_name}) 
      puts "#{project_name} has been created."
      puts "Press 'a' to do further action with respect to projects, or 'b' to return to the main menu"
        if gets.chomp == 'a'
          add_employee_to_project
        elsif gets.chomp == 'b'
          menu
  elsif gets.chomp == 'b'
      puts "What is the name of the project to which you want to add employees"
      project_name = gets.chomp
      loop do
        puts "What is the name of the employee to be added to a project"
        employee_name = gets.chomp
        if Project.where(name: division_name).exists?  
          project = Project.where({:name => project_name}).first  
        else
          project = Project.new({:name => project_name}) 
        end
        project.employees.new({:name => employee_name})
        project.save 
        puts "#{employee_name} has been added to #{project_name}"
        puts "Would you like to add another employee to #{project_name}? (y/n)"
       break if gets.chomp == 'n'
      end
        puts "Would you like to add employees to another project? (y/n)"
        if gets.chomp == 'y'
          employee_to_project
        elsif gets.chomp == 'n'
          menu
       end
    end
  end

def show_employees
  puts "here are all of the employees, the divisions they are in and the projects they are working on:"
  ***************
end

def search_employees

end




def list
  puts "Here is everything you need to do:"
  tasks = Task.not_done
  tasks.each { |task| puts task.name }
end

def mark_done
  puts "Which of these tasks would you like to mark as done?"
  Task.all.each { |task| puts task.name }

  done_task_name = gets.chomp
  done_task = Task.where({:name => done_task_name}).first   #could also do .pop method if only going to be one match
  done_task.update({:done => true})  #can also user update_attributes...these update the model and save to the database
end


welcome