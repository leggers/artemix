class Design < ActiveRecord::Base
  has_attached_file :image

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :designer

  has_many :transforms
  has_many :artworks, :through => :transforms

  def fabricate!
    # put images on legs
    files = []
    img = Magick::ImageList.new( Artwork.find_by_name('template').image.path )

    transforms.each do |t| 
      img_path = t.apply(img)
      files << img_path
      img = Magick::ImageList.new(img_path)
    end

    # put text on waistband
    right_leg_angle = 12.3 # degrees
    left_leg_angle = -right_leg_angle


    self.image = File.open(img.filename)
    save!

    files.each {|f| File.delete(f) if File.exists?(f)}
  end

  def artist_string
    base = "Artwork by "
    self.artworks.each { |a| base << a.artist.strip + " and " }
    base[0...-5]
  end

  def desginer_string
    "Designed by " + self.designer.strip
  end

  def name_string
    "#" + self.name.titleize.gsub(/\s+/, '')
  end

  def artist?
    self.artworks.each { |a| return true unless a.artist.empty? }
    return false
  end
end
