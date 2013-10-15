class Artwork < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  # attr_accessor :name, :locked # need to add default value to locked

  validates :name, :presence => true
  validates_inclusion_of :locked, :in => [true, false]

  validates_attachment :image, :presence => true,
    :content_type => { 
      :content_type => 'image/jpeg'
    }
end
