class User < ApplicationRecord
  include Clearance::User

  has_many :maps, dependent: :destroy
end
