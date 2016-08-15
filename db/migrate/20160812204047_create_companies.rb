class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :company_code
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :companies, :deleted_at
  end
end
