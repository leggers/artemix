class UnscaleTransforms < ActiveRecord::Migration
  def change
    Transform.all do |t|
      scale_factor = 20
      t.image_x /= scale_factor
      t.image_y /= scale_factor
      t.height /= scale_factor
      t.width /= scale_factor
      t.rotation *= Math::PI / 180
      t.save!
    end
  end
end
