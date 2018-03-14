require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  # TODO: Check if it can have pins through tagged_pin
end
