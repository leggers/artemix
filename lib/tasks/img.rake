namespace :img do
  desc "TODO"
  task covers: :environment do
    directory = "#{Rails.root}/app/assets/images"
    template = Magick::ImageList.new("#{directory}/template.png")
    width = template[0].columns
    height = template[0].rows
    white = template[0].pixel_color(5, 5)
    opacity = (Magick::TransparentOpacity-Magick::OpaqueOpacity).abs * 0.75
    left_leg = template[0].crop(0, 0, width/2, height).paint_transparent(white, opacity)
    right_leg = template[0].crop(width/2, 0, width/2, height).paint_transparent(white, opacity)

    left_leg.write("#{directory}/left_leg.png")
    right_leg.write("#{directory}/right_leg.png")
  end

end
