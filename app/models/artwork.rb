class Artwork < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>", :canvas => "300x660>" }, :default_url => "/images/:style/missing.png"

  # validates_presence_of :name
  # validates_uniqueness_of :name, :case_sensitive => false
  validates_inclusion_of :locked, :in => [true, false]

  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => /image\/(jpg|jpeg|png|gif)/

  has_many :transforms
end
