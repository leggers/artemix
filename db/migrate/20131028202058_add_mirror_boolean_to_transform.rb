class AddMirrorBooleanToTransform < ActiveRecord::Migration
  def change
    add_column :transforms, :mirror, :boolean, :default => false
  end
end
