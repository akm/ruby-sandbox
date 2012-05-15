class Payment < CassandraObject::Base
  attribute :reference_number, :type => :string
  attribute :amount,           :type => :integer

  key :natural, :attributes => :reference_number
end
