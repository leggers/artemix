class LinkArtworksAndTransforms < ActiveRecord::Migration
  def change
    change_table :transforms do |t|
      t.integer :artwork_id
    end
  end
end
