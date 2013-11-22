class ChangeRotationToFloat < ActiveRecord::Migration
  def change
    change_column :transforms, :rotation, :float
  end
end
