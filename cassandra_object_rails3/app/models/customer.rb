class Customer < CassandraObject::Base
  attribute :first_name,     :type => :string
  attribute :last_name,      :type => :string
  attribute :date_of_birth,  :type => :date
  attribute :preferences,    :type => :hash
  attribute :custom_storage, :type => String, :converter=>ReverseStorage

  validate :should_be_cool
  validates_presence_of :last_name

  after_create :set_after_create_called

  key :uuid

  index :last_name, :reversed=>true

  association :invoices, :unique=>false, :inverse_of=>:customer, :reversed=>true

  def after_create_called?
    @after_create_called
  end

  def set_after_create_called
    @after_create_called = true
  end

  private

  def should_be_cool
    unless ["Michael", "Anika", "Evan", "Tom"].include?(first_name)
      errors.add(:first_name, "must be that of a cool person")
    end
  end
end
