class CreateArtworks < ActiveRecord::Migration
  def change
    create_table :artworks do |t|
      t.boolean :locked
      t.string :name

      t.timestamps
    end
  end
end
