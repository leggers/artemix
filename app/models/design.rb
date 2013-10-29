class Design < ActiveRecord::Base
  has_attached_file :image

  has_many :transforms
  has_many :artworks, :through => :transforms

  def fabricate!
    img = Magick::ImageList.new( File.open(Artwork.find_by_name('template').image.path) )[0]
    transforms.each {|t| img = t.apply(img)}
    self.image = File.open(img.filename)
    File.delete(img.filename)
    save!
  end
end
