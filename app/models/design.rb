class Design < ActiveRecord::Base
  has_attached_file :image

  validates_presence_of :name # 24 character soft upper limit for visual reasons
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

    img = self.write_waistband_text(img)
    last_intermediate = "#{Dir.tmpdir}/#{SecureRandom.hex}.png"
    img.write(last_intermediate)

    files << last_intermediate

    self.image = File.open(last_intermediate)
    save!

    files.each {|f| File.delete(f) if File.exists?(f)}
  end

  # private

  def write_waistband_text img
    # TODO: compensate for name length by shrinking and repositioning text
    img = write_left_waistband_text img
    img = write_right_waistband_text img
    img
  end

  def write_left_waistband_text img
    text = self.name_string
    left_waistband_angle = 12.3 # degrees
    text_writer = Magick::Draw.new
    text_writer.rotate(left_waistband_angle)
    text_writer.font_family = 'helvetica'
    text_writer.fill = 'white'
    text_writer.font_weight(700)

    text_x = 3000
    text_y = 565
    pointsize = 300

    offset_coefficient = text.length - 11
    if offset_coefficient > 0
      text_x -= self.max_x_offset(offset_coefficient) * 75
      text_y -= offset_coefficient * 1.5
      if offset_coefficient > 2
        pointsize -= offset_coefficient * 9
      end
    end

    text_writer.pointsize = pointsize
    text_writer.text(text_x, text_y, text)
    text_writer.draw(img)
    img
  end

  def write_right_waistband_text img
    right_leg_angle = -left_leg_angle
    text_writer = Magick::Draw.new
    text_writer.rotate(right_leg_angle)
    text_writer.font_family = 'helvetica'
    text_writer.pointsize = 150
    text_writer.fill = 'white'
    text_writer.text(6850, 3000, self.artist_string)
    text_writer.text(6850, 3160, self.desginer_string)
    text_writer.draw(img)
    img
  end

  def max_x_offset offset_coefficient
    offset_coefficient >= 5 ? 5 : offset_coefficient
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
