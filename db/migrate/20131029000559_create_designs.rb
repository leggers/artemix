class CreateDesigns < ActiveRecord::Migration
  def change
    create_table :designs do |t|
      t.string :name
      t.string :designer
      t.attachment :image

      t.timestamps
    end
    add_column :transforms, :design_id, :integer
  end
end
