# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

transform_defaults = {
  :image_x => 330 / 20,
  :image_y => 1000 / 20,
  :width => 5425 / 20,
  :height => 11275 / 20,
  :rotation => 0
}

template = Artwork.create!(
  :locked => true,
  :name => 'template',
  :image => File.open( "#{Rails.root}/app/assets/images/template.png" ),
  :artist => 'bombsheller'
)
p 'Created template Artwork'
# rocket = Artwork.create!(
#   :locked => false,
#   :name => 'rocket',
#   :artist => "NASA",
#   :attribution => 'http://commons.wikimedia.org/wiki/File:S81-30459.jpg',
#   :image => File.open( "#{Rails.root}/app/assets/images/rocket.jpg" )
#   )
# p "Created rocket Artwork"
# d = Design.create!(
#   :name => "liftoff",
#   :designer => "leggers"
# )
# t = Transform.create!(
#   transform_defaults.merge!({
#     :leg => "left",
#     :mirror => true,
#     :artwork => rocket,
#     :design => d
#   })
# )
# p 'Created Design entry, time to make image'
# d.fabricate!
# p 'Rocket Design fabricated'

# bb = Artwork.create!(
#   :locked => false,
#   :name => 'agrias narcissus',
#   :artist => 'tester1',
#   :attribution => 'http://commons.wikimedia.org/wiki/File:Agrias_narcissus_narcissus_MHNT.jpg',
#   :artist => 'Didier Descouens',
#   :image => File.open( "#{Rails.root}/app/assets/images/butterfly_blue.jpg" )
# )
# p 'Blue butterfly Artwork created'
# bz = Artwork.create!(
#   :name => 'baeotus aeilus',
#   :artist => 'tester2',
#   :locked => false,
#   :attribution => 'http://commons.wikimedia.org/wiki/File:Baeotus_aeilus_MHNT.jpg',
#   :artist => 'Didier Descouens',
#   :image => File.open( "#{Rails.root}/app/assets/images/butterfly_zebra.jpg" )
# )
# p 'Zebra butterfly Artwork created'
# d2 = Design.create!(
#   :name => "butterflies",
#   :designer => "leggers"
# )
# t2 = Transform.create!(
#   transform_defaults.merge!({
#     :leg => "left",
#     :mirror => false,
#     :artwork => bb,
#     :design => d2,
#     :rotation => Math::PI / 2
#   })
# )
# t3 = Transform.create!(
#   transform_defaults.merge!({
#     :leg => "right",
#     :mirror => false,
#     :artwork => bz,
#     :design => d2,
#     :rotation => 3 * Math::PI / 2
#   })
# )
# p 'Fabricating butterflies Design'
# d2.fabricate!