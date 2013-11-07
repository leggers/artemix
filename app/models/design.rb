class Design < ActiveRecord::Base
  has_attached_file :image

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :designer

  has_many :transforms
  has_many :artworks, :through => :transforms

  def fabricate!
    files = []
    img = Magick::ImageList.new( Artwork.find_by_name('template').image.path )

    transforms.each do |t| 
      img_path = t.apply(img)
      files << img_path
      img = Magick::ImageList.new(img_path)
    end

    self.image = File.open(img.filename)
    save!

    files.each {|f| File.delete(f) if File.exists?(f)}
  end
end
