class AddArtistToArtwork < ActiveRecord::Migration
  def change
    add_column :artworks, :artist, :string
  end
end
