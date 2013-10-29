class CreateTransforms < ActiveRecord::Migration
  def change
    create_table :transforms do |t|
      t.integer :image_x
      t.integer :image_y
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
