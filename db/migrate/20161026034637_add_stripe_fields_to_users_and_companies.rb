class AddStripeFieldsToUsersAndCompanies < ActiveRecord::Migration
  def change
    add_column :users, :account_admin, :boolean, default: false
    add_column :companies, :stripe_customer_id, :string
    add_column :companies, :tier, :string
    add_column :companies, :active_until, :datetime
    add_column :companies, :subscription_id, :string
  end
end
