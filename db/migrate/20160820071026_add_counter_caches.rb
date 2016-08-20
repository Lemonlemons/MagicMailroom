class AddCounterCaches < ActiveRecord::Migration
  def change
    add_column :companies, :users_count, :integer, default: 0
    add_column :companies, :residents_count, :integer, default: 0
    add_column :users, :deliveries_count, :integer, default: 0
    add_column :residents, :deliveries_count, :integer, default: 0
  end
end
