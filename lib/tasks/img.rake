namespace :img do
  require 'RMagick'
  desc "Takes a template file and converts it into the two template images seen on the site"
  task covers: :environment do
    directory = "#{Rails.root}/app/assets/images"
    template = Magick::ImageList.new("#{directory}/template.png")
    width = template[0].columns
    height = template[0].rows
    opacity = (Magick::TransparentOpacity-Magick::OpaqueOpacity).abs * 0.25
    scale_factor = 0.25

    left_leg = template[0].crop(0, 0, width/2, height).resize(scale_factor).paint_transparent('white', opacity)
    right_leg = template[0].crop(width/2, 0, width/2, height).resize(scale_factor).paint_transparent('white', opacity)

    left_leg.write("#{directory}/left_leg.png")
    right_leg.write("#{directory}/right_leg.png")
  end

end
