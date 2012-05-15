class Appointment < CassandraObject::Base
  attribute :title,      :type => :string
  attribute :start_time, :type => :time
  attribute :end_time,   :type => :time_with_zone, :allow_nil => true

  key :natural, :attributes => :title
end
