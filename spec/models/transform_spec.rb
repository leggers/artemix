require 'spec_helper'

describe Transform do
  let(:artwork_attributes) { {
    :locked => false,
    :name => "valid",
    :image => fixture_file_upload('fourmoons.jpg', 'image/jpeg'),
    :artist => 'test'
  } }
  let(:valid_strings) { {
    :image_x => '1',
    :image_y => '1',
    :height => '1',
    :width => '1',
    :rotation => "#{Math::PI / 2}"
  } }
  let(:valid_attributes) { {
    :image_x => 1,
    :image_y => 1,
    :height => 1,
    :width => 1,
    :rotation => Math::PI / 2,
    :artwork => @artwork,
    :leg => "left"
  } }
  let(:valid_negative_strings) { {
    :image_x => '-2',
    :image_y => '-1',
    :height => '4',
    :width => '5'
  } }
  before do
    @artwork = Artwork.create!(artwork_attributes)
  end
  describe 'with string values' do
    it 'should convert to numbers' do
      t = Transform.new(valid_strings)
      t.prepare_for_create
      t.image_x.should eq(valid_attributes[:image_x])
      t.image_y.should eq(valid_attributes[:image_y])
      t.height.should eq(valid_attributes[:height])
      t.width.should eq(valid_attributes[:width])
      t.rotation.should eq(valid_attributes[:rotation])
    end
    it 'should convert negative numbers properly' do
      t = Transform.new(valid_negative_strings)
      t.prepare_for_create
      t.image_x.should eq(-2)
      t.image_y.should eq(-1)
      t.height.should eq(4)
      t.width.should eq(5)
    end
  end
  describe 'with proper values' do
    it 'should save' do
      Transform.create!(valid_attributes)
    end
  end
  describe 'without proper values' do
    it 'should not save without image_x' do
      valid_attributes.delete(:image_x)
      expect{ Transform.create!(valid_attributes) }.to raise_error
    end
    it 'should not save without image_y' do
      valid_attributes.delete(:image_y)
      expect{ Transform.create!(valid_attributes) }.to raise_error
    end
    it 'should not save without height' do
      valid_attributes.delete(:height)
      expect{ Transform.create!(valid_attributes) }.to raise_error
    end
    it 'should not save without width' do
      valid_attributes.delete(:width)
      expect{ Transform.create!(valid_attributes) }.to raise_error
    end
    it 'should not save without an artwork' do
      valid_attributes.delete(:artwork)
      expect{ Transform.create!(valid_attributes) }.to raise_error
    end
    it 'should not save without a leg specified' do
      valid_attributes.delete(:leg)
      expect{ Transform.create!(valid_attributes) }.to raise_error
    end
  end
  describe 'scaling' do
    it 'should change values when scaled' do
      t = Transform.new(valid_attributes)
      t.scale
      t.image_x.should eq(valid_attributes[:image_x] * 20)
      t.image_y.should eq(valid_attributes[:image_y] * 20)
      t.height.should eq(valid_attributes[:height] * 20)
      t.width.should eq(valid_attributes[:width] * 20)
      t.rotation.should eq(valid_attributes[:rotation] * 180 / Math::PI)
    end
    it 'should scale negative numbers properly' do
      t = Transform.new(valid_negative_strings)
      t.prepare_for_create
      t.scale
      t.image_x.should eq(-40)
      t.image_y.should eq(-20)
      t.height.should eq(80)
      t.width.should eq(100)
    end
  end
end
