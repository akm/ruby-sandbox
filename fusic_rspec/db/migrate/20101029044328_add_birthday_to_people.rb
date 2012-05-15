class AddBirthdayToPeople < ActiveRecord::Migration
  def self.up
    change_table("people") do |t|
      t.date :birthday
    end
  end

  def self.down
    change_table("people") do |t|
      t.remove :birthday
    end
  end
end
