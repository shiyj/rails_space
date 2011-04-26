class AddGender < ActiveRecord::Migration
  def self.up
  	add_column :specs,:gender,:string
  end

  def self.down
  	remove_column :specs,:gender
  end
end
