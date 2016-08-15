class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.integer :user_id
      t.integer :resident_id
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :deliveries, :user_id, name: 'delivery_user_id_ix'
    add_index :deliveries, :resident_id, name: 'delivery_resident_id_ix'
    add_index :deliveries, :deleted_at
  end
end
