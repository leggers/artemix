# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

rocket = Artwork.create!(
  :locked => false,
  :name => 'rocket',
  :image => File.open( "#{Rails.root}/app/assets/images/rocket.jpg" )
  )
p "Created rocket Artwork"
template = Artwork.create!(
  :locked => false,
  :name => 'template',
  :image => File.open( "#{Rails.root}/app/assets/images/template.png" )
)
p 'Created template Artwork'
d = Design.create!(
  :name => "liftoff",
  :designer => "leggers"
)
t = Transform.create!(
  :image_x => 330,
  :image_y => 1000,
  :width => 5425,
  :height => 11275,
  :leg => "left",
  :mirror => true,
  :artwork => rocket,
  :design => d
)
p 'Created Design entry, time to make image'
d.fabricate!
p 'Design fabricated'