class Transform < ActiveRecord::Base
  validates :image_x, :presence => true
  validates :image_y, :presence => true
  validates :width, :presence => true # negative width correlates to a mirrored image
  validates :height, :presence => true
  validates_inclusion_of :leg, :in => [
    'left',
    'right'
  ]

  belongs_to :artwork
  belongs_to :design

  validates :artwork, :presence => true

  # For MVP, this method moves, resizes, composites, and mirrors. Nothing else
  # Input: a Magick::Image as an argument
  # Output: a Magick::Image that represents the composite of the inputted image on top of the transformed image
  # Imagine glueing transform's artwork onto the passed-in image.
  def apply(template_image)
    image = Magick::ImageList.new(artwork.image.path)

    # image[0].rotate!(rotation) unless rotation.nil?
    image.resize!(width, height)

    # x_copies = (image[0].columns / template[0].columns).ceil
    # y_copies = (image[0].rows / template[0].rows).ceil

    # To be tiling, see http://www.imagemagick.org/RMagick/doc/ilist.html#mosaic
    # tiled = Magick::ImageList.new
    # page = Magick::Rectangle.new(0,0,0,0)
    # x_copies.times do |x|
    #   y_copies.times do |y|

    #   end
    # end

    design_image = template_image.composite(image, image_x, image_y, Magick::DstOverCompositeOp)

    if mirror
      design_image.flop!
      design_image.composite!(image, image_x, image_y, Magick::DstOverCompositeOp)
      design_image.flop!
    end
    

    artwork_name = artwork.name
    design_name = "#{artwork_name}_design.png"
    

    # design_name # NEEDS TO RETURN PATH

    design_image.write("#{design_image.filename}.png")
    # delete the temporary images created, rescues for garbage-collected files
    File.delete(template_image.filename) rescue ""
    Magick::ImageList.new("#{design_image.filename}")[0]
  end

end
