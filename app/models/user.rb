class User < ApplicationRecord
  include Clearance::User

  has_many :maps, as: :owner, dependent: :destroy
end
