require 'spec_helper'

describe Transform do
  let(:valid_attributes) { {
    :locked => false,
    :name => "valid",
    :image => fixture_file_upload('fourmoons.jpg', 'image/jpeg')
  } }
  before do
    @artwork = Artwork.create! valid_attributes
  end
  describe 'with proper values' do
    it 'should save' do
      Transform.create!({
        :image_x => 0,
        :image_y => 0,
        :height => 0,
        :width => 0,
        :artwork => @artwork,
        :leg => "left"
        })
    end
  end
  describe 'without proper values' do
    it 'should not save without image_x' do
      expect{ Transform.create!({
        :image_y => 0,
        :height => 0,
        :width => 0,
        :artwork => @artwork,
        :leg => "left"
        }) }.to raise_error
    end
    it 'should not save without image_y' do
      expect{ Transform.create!({
        :image_x => 0,
        :height => 0,
        :width => 0,
        :artwork => @artwork,
        :leg => "left"
        }) }.to raise_error
    end
    it 'should not save without height' do
      expect{ Transform.create!({
        :image_x => 0,
        :image_y => 0,
        :width => 0,
        :artwork => @artwork,
        :leg => "left"
        }) }.to raise_error
    end
    it 'should not save without width' do
      expect{ Transform.create!({
        :image_x => 0,
        :image_y => 0,
        :height => 0,
        :artwork => @artwork,
        :leg => "left"
        }) }.to raise_error
    end
    it 'should not save without an artwork' do
      expect{ Transform.create!({
        :image_x => 0,
        :image_y => 0,
        :height => 0,
        :width => 0,
        :leg => "left"
        }) }.to raise_error
    end
    it 'should not save without a leg specified' do
      expect{ Transform.create!({
        :image_x => 0,
        :image_y => 0,
        :height => 0,
        :width => 0,
        :artwork => @artwork
        }) }.to raise_error
    end
  end
end
