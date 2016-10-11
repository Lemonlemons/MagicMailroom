class AddConfirmedToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :confirmed, :boolean, default: false
  end
end
