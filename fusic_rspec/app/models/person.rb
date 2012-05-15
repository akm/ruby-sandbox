class Person < ActiveRecord::Base

  def self.hirata_list
    where("name like '%hirata%'").order(:name)
  end

  def puddingized_name
    "#{name}_pudding"
  end

  def age
    Date.today.year - birthday.year
  end

end
