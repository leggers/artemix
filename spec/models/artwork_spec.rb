require 'spec_helper'

describe Artwork do
  let(:valid_attributes) { {
    :locked => false,
    :name => "valid",
    :image => fixture_file_upload('fourmoons.jpg', 'image/jpeg'),
    :artist => 'valid',
    :attribution => 'source'
  } }
  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  it { should validate_attachment_content_type(:image).
    allowing('image/jpg', 'image/png', 'image/gif') }
  describe 'with proper attributes' do
    it 'should save' do
      Artwork.create!(valid_attributes)
    end
  end
  describe 'should not save' do
    it 'without artist' do
      valid_attributes.delete(:artist)
      expect{ Artwork.create!(valid_attributes) }.to raise_error
    end
    it 'without an image' do
      valid_attributes.delete(:image)
      expect{ Artwork.create!(valid_attributes) }.to raise_error
    end
  end
end
