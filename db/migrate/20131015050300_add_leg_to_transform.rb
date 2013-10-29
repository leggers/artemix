class AddLegToTransform < ActiveRecord::Migration
  def change
    change_table :transforms do |t|
      t.string :leg
    end
  end
end
