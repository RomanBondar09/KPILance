require 'rails_helper'

describe User do
  it 'validates name presence' do
    should validate_presence_of(:username)
  end

  it 'validates name length' do
    should validate_length_of(:username).is_at_most(50)
  end

  it 'have secure password' do
    should have_secure_password
  end
end
