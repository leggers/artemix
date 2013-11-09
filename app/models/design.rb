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
    # TODO: compensate for name length by shrinking and repositioning text
    left_leg_angle = 12.3 # degrees
    left_text = Magick::Draw.new
    left_text.rotate(left_leg_angle)
    left_text.font_family = 'helvetica'
    left_text.font_weight(700)
    left_text.pointsize = 300
    left_text.fill = 'white'
    left_text.text(3000, 565, self.name_string)
    left_text.draw(img)

    right_leg_angle = -left_leg_angle
    right_text = Magick::Draw.new
    right_text.rotate(right_leg_angle)
    right_text.font_family = 'helvetica'
    right_text.pointsize = 150
    right_text.fill = 'white'
    right_text.text(6850, 3000, self.artist_string)
    right_text.text(6850, 3160, self.desginer_string)
    right_text.draw(img)

    last_intermediate = "#{Dir.tmpdir}/#{SecureRandom.hex}.png"
    img.write(last_intermediate)

    self.image = File.open(last_intermediate)
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
