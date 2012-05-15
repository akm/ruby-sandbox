class Customer < ActiveRecord::Base
  def self.csv_export
    filepath = Rails.root.join("tmp/test1.csv")
    File.open(filepath, 'w') do |f|
      Customer.find(:all, :order => "customer_code").each do |customer|
        f.puts("#{customer.customer_code},#{customer.name}")
      end
    end
  end

end
