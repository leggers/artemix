class AddContactToDesign < ActiveRecord::Migration
  def change
    add_column :designs, :contact, :string
  end
end
