class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true

  STATUSES = %w[todo in_progress done].freeze

  validates :status,
    presence: true,
    inclusion: { in: STATUSES }

  VALID_PRIORITIES = (1..5).to_a

  validates :priority, presence: true, inclusion: { in: VALID_PRIORITIES }

  # Class method (so logic is only written once)
  def self.overdue_query
    where("due_date IS NOT NULL AND due_date < ? AND status != ?", Time.current, "done")
  end

  # Instance method
  def overdue?
    self.class.overdue_query.where(id: id).exists?
  end

  # Scope
  scope :overdue, -> { overdue_query }
  scope :with_status, ->(status) { where(status: status) }
  scope :sorted_by, ->(sort_param) {
    # Asc/desc switched because lowest priority is the highest.
    order_clause = case sort_param
    when "priority_desc" then { priority: :asc }
    when "priority_asc"  then { priority: :desc }
    when "due_desc"      then { due_date: :desc }
    when "due_asc"       then { due_date: :asc }
    else {}
    end
    order(order_clause)
  }
end
