class AddRotationToTransform < ActiveRecord::Migration
  def change
    add_column :transforms, :rotation, :integer
  end
end
