class CreateRequestSendings < ActiveRecord::Migration
  def self.up
    create_table :request_sendings do |t|
      t.string :method
      t.string :uri
      t.text :parameters
      t.text :headers

      t.timestamps
    end
  end

  def self.down
    drop_table :request_sendings
  end
end
