class Person < CassandraObject::Base
  attribute :name, :type => :string
  attribute :age,  :type => :integer
end
