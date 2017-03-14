class Plan < ApplicationRecord
  belongs_to :user
  belongs_to :case, optional: true
  belongs_to :assigned_to, optional: true, class_name: 'User'
  belongs_to :priority_type, optional: true
  belongs_to :plan_status, optional: true
  validates_presence_of :name
  has_many :plan_notes, foreign_key: :owner_id, dependent: :destroy

  has_many :goal_plans, dependent: :destroy
  has_many :goals, through: :goal_plans
  accepts_nested_attributes_for :goal_plans, reject_if: :all_blank, allow_destroy: true

  has_many :plan_tasks, dependent: :destroy
  has_many :tasks, through: :plan_tasks
  has_many :appointment_links, as: :linkable

  def self.safe_attributes
    [
        :priority_type_id, :user_id, :plan_status_id, :name, :assigned_to_id,
        :description, :date_completed, :date_due, :date_start,  :case_id,
        goal_plans_attributes: [GoalPlan.safe_attributes]
    ]
  end

  def available_tasks
    self.case.try(:tasks) || []
  end

  def available_goals
    self.case.try(:goals) || []
  end

  def self.enumeration_columns
    [
        ["#{PriorityType}", 'priority_type_id'],
        ["#{PlanStatus}", 'plan_status_id']
    ]
  end

  def priority_type
    if priority_type_id
      super
    else
      PriorityType.default
    end
  end

  def plan_status
    if plan_status_id
      super
    else
      PlanStatus.default
    end
  end

  def to_s
    name
  end

  def to_pdf(pdf, show_user = true)
    pdf.font_size(25){  pdf.table([[ "Plan ##{id}"]], :row_colors => ['eeeeee'], :column_widths => [ 523], :cell_style=> {align: :center})}
    user.to_pdf_brief_info(pdf) if show_user
    pdf.table([[" Plan "]], :row_colors => ['eeeeee'], :column_widths => [ 523], :cell_style=> {align: :center})

    pdf.table([[ "Name: ", " #{name}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Description: ", " #{ActionView::Base.full_sanitizer.sanitize(description)}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Goal status: ", " #{plan_status}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Priority: ", " #{priority_type}"]], :column_widths => [ 150, 373])

    pdf.table([[ "Date start: ", " #{date_start}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Date due: ", " #{date_due}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Date completed: ", " #{date_completed}"]], :column_widths => [ 150, 373])
  end

end
