require 'spec_helper'

describe Design do
  let(:valid_attributes) { {
    :name => "valid",
    :designer => "tester",
    :image => fixture_file_upload('fourmoons.jpg', 'image/jpeg')
  } }
  describe 'with proper attributes' do
    it 'should save' do
      Design.create!(valid_attributes)
    end
  end
  describe 'should not save' do
    it 'without a name' do
      valid_attributes.delete(:name)
      expect{ Design.create!(valid_attributes) }.to raise_error
    end
    it 'without a designer' do
      valid_attributes.delete(:designer)
      expect{ Design.create!(valid_attributes) }.to raise_error
    end
    it 'with the same name' do
      Design.create!(valid_attributes)
      expect{ Design.create!(valid_attributes) }.to raise_error
    end
  end
end
