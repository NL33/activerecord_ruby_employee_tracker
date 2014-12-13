class Employee < ActiveRecord::Base
  belongs_to :division
  has_and_belongs_to_many :projects
  has_many :contributions
  has_many :big_deals, through: :contributions

def project_name
 self.projects.each {|project| project.name}
end

 
end


