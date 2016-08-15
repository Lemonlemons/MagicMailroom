class AddCompanyCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_code, :string
  end
end
