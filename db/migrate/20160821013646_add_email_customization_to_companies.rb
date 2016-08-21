class AddEmailCustomizationToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :email_subject_line, :string
    add_column :companies, :email_title, :string
    add_column :companies, :email_body, :string
  end
end
