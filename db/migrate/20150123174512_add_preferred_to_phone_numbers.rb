class AddPreferredToPhoneNumbers < ActiveRecord::Migration
  def change
    add_column :phone_numbers, :preferred, :boolean
  end
end
