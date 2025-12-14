class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true

  STATUSES = %w[todo in_progress done].freeze

  validates :status,
    presence: true,
    inclusion: { in: STATUSES }

  VALID_PRIORITIES = (1..5).to_a

  validates :priority, presence: true, inclusion: { in: VALID_PRIORITIES }
end
