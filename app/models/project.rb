class Project < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  extend FriendlyId
  friendly_id :name, use: :slugged
end
