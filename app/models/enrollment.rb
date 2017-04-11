class Enrollment < ApplicationRecord
  audited except: [:created_by_id, :updated_by_id]
  belongs_to :user
  belongs_to :case
  belongs_to :enrollment_type, optional: true
  belongs_to :enrollment_status, optional: true

  has_many :enrollment_attachments, foreign_key: :owner_id, dependent: :destroy
  accepts_nested_attributes_for :enrollment_attachments, reject_if: :all_blank, allow_destroy: true
  has_many :appointment_links, as: :linkable

  validates_presence_of :name, :user_id, :note, :case_id

  def self.safe_attributes
    [:user_id, :name, :enrollment_type_id, :enrollment_status_id, :case_id,
     :date_start, :date_end, :note, enrollment_attachments_attributes: [Attachment.safe_attributes]]
  end

  def self.enumeration_columns
    [
        ["#{EnrollmentType}", 'enrollment_type_id'],
        ["#{EnrollmentStatus}", 'enrollment_status_id']
    ]
  end

  def enrollment_type
    if self.enrollment_type_id
      super

    else
      EnrollmentType.default
    end
  end

  def enrollment_status
    if self.enrollment_status_id
      super
    else
      EnrollmentStatus.default
    end
  end

  def to_s
    name
  end

  def to_pdf(pdf, show_user = true)
    pdf.font_size(25){  pdf.table([[ "Enrollment ##{id}"]], :row_colors => ['eeeeee'], :column_widths => [ 523], :cell_style=> {align: :center})}
    user.to_pdf_brief_info(pdf) if show_user
    pdf.table([[" Enrollment "]], :row_colors => ['eeeeee'], :column_widths => [ 523], :cell_style=> {align: :center})
    pdf.table([[ "Enrollment type: ", " #{enrollment_type}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Enrollment Status: ", " #{enrollment_status}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Date start: ", " #{date_start}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Date end: ", " #{date_end}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Note: ", " #{ActionView::Base.full_sanitizer.sanitize(note)}"]], :column_widths => [ 150, 373])
  end

  def can_send_email?
    true
  end

  def for_mail
    output = ""
    output<< "<h2>Enrollment ##{id} </h2><br/>"
    output<<"<b>Enrollment Type : </b> #{enrollment_type}<br/>"
    output<<"<b>Enrollment Status : </b> #{enrollment_status}<br/>"
    output<<"<b>Date start : </b> #{date_start}<br/>"
    output<<"<b>Date end : </b> #{date_end}<br/>"
    output<<"<b>Description: </b> #{description} <br/>"
    output.html_safe
  end
end
