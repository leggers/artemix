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

  validates :artwork, :presence => true

  # For MVP, this method moves, resizes, composites, and mirrors. Nothing else
  def apply
    image = Magick::ImageList.new(artwork.image.path)
    template = Magick::ImageList.new(Artwork.find_by_name('template').image.path)

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

    design_image = template[0].composite(image, image_x, image_y, Magick::DstOverCompositeOp)

    if mirror
      # if leg == "left"
      #   image_x = template[0].columns - image_x - width
      # else
      #   image_x = image_x - 5965 # TODO: do this right
      # end
      # image[0].flop!
      # design_image.composite!(image, image_x, image_y, Magick::DstOverCompositeOp)
      design_image.flop!
      design_image.composite!(image, image_x, image_y, Magick::DstOverCompositeOp)
      design_image.flop!
    end
    

    artwork_name = artwork.name
    design_name = "#{artwork_name}_design.png"
    

    # design_name # NEEDS TO RETURN PATH

    design_image
  end

end
