require 'spec_helper'

describe Artwork do
  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  # it { should validate_attachment_content_type(:image).
  #   allowing('image/jpg', 'image/png', 'image/gif') }
end
