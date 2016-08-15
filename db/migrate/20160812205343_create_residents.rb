class CreateResidents < ActiveRecord::Migration
  def change
    create_table :residents do |t|
      t.integer :company_id
      t.string :name
      t.string :apartment_number
      t.integer :phone
      t.string :email
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :residents, :company_id, name: 'resident_company_id_ix'
    add_index :residents, :deleted_at
  end
end
