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
  let(:valid_numbers) { {
    :image_x => 1,
    :image_y => 1,
    :height => 1,
    :width => 1,
    :rotation => Math::PI / 2,
    :artwork => @artwork,
    :leg => "left"
  } } 
  before do
    @artwork = Artwork.create!(artwork_attributes)
  end
  describe 'with string values' do
    it 'should convert to numbers' do
      t = Transform.new(valid_strings)
      t.prepare_for_create
      t.image_x.should eq(valid_numbers[:image_x])
      t.image_y.should eq(valid_numbers[:image_y])
      t.height.should eq(valid_numbers[:height])
      t.width.should eq(valid_numbers[:width])
      t.rotation.should eq(valid_numbers[:rotation])
    end
  end
  describe 'with proper values' do
    it 'should save' do
      Transform.create!(valid_numbers)
    end
  end
  describe 'without proper values' do
    it 'should not save without image_x' do
      valid_numbers.delete(:image_x)
      expect{ Transform.create!(valid_numbers) }.to raise_error
    end
    it 'should not save without image_y' do
      valid_numbers.delete(:image_y)
      expect{ Transform.create!(valid_numbers) }.to raise_error
    end
    it 'should not save without height' do
      valid_numbers.delete(:height)
      expect{ Transform.create!(valid_numbers) }.to raise_error
    end
    it 'should not save without width' do
      valid_numbers.delete(:width)
      expect{ Transform.create!(valid_numbers) }.to raise_error
    end
    it 'should not save without an artwork' do
      valid_numbers.delete(:artwork)
      expect{ Transform.create!(valid_numbers) }.to raise_error
    end
    it 'should not save without a leg specified' do
      valid_numbers.delete(:leg)
      expect{ Transform.create!(valid_numbers) }.to raise_error
    end
  end
  describe 'scaling' do
    it 'should change values when scaled' do
      t = Transform.new(valid_numbers)
      t.scale
      t.image_x.should eq(valid_numbers[:image_x] * 20)
      t.image_y.should eq(valid_numbers[:image_y] * 20)
      t.height.should eq(valid_numbers[:height] * 20)
      t.width.should eq(valid_numbers[:width] * 20)
      p valid_numbers[:rotation]
      t.rotation.should eq(valid_numbers[:rotation] * 180 / Math::PI)
    end
  end
end
