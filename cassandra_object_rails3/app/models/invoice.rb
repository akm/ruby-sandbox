class Invoice < CassandraObject::Base
  attribute :number,     :type=>:integer
  attribute :total,      :type=>:float
  attribute :gst_number, :type=>:string

  index :number, :unique=>true

  association :customer, :unique=>true, :inverse_of=>:invoices

  migrate 1 do |attrs|
    attrs["total"] ||= (rand(2000) / 100.0).to_s
  end

  migrate 2 do |attrs|
    attrs["gst_number"] = "66-666-666"
  end

  key :uuid
end
