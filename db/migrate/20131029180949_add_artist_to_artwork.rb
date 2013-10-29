class AddArtistToArtwork < ActiveRecord::Migration
  def change
    add_column :artworks, :artist, :string
    add_column :artworks, :attribution, :string
  end
end
