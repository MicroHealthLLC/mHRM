class Socioeconomic < ApplicationRecord
  belongs_to :user
  belongs_to :icdcm_code, :foreign_key => 'icdcm_code_id', class_name: 'Icd10datum'
  belongs_to :socioeconomic_type, optional: true
  belongs_to :socioeconomic_status, optional: true

  has_many :socioeconomic_attachments, foreign_key: :owner_id, dependent: :destroy
  accepts_nested_attributes_for :socioeconomic_attachments, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :user_id, :name

  def self.enumeration_columns
    [
        ["#{SocioeconomicType}", 'socioeconomic_type_id'],
        ["#{SocioeconomicStatus}", 'socioeconomic_status_id']
    ]
  end

  def socioeconomic_type
    if socioeconomic_type_id
      super
    else
      SocioeconomicType.default
    end
  end

  def socioeconomic_status
    if socioeconomic_status_id
      super
    else
      SocioeconomicStatus.default
    end
  end


  def to_s
    name
  end

  def self.safe_attributes
    [:name, :user_id, :icdcm_code_id, :date_identified, :date_resolved,
     :socioeconomic_status_id, :socioeconomic_type_id, :description]
  end

  def to_pdf(pdf, show_user = true)
    pdf.font_size(25){  pdf.table([[ "Socioeconomic ##{id}"]], :row_colors => ['#D999FF'], :column_widths => [ 523], :cell_style=> {align: :center})}
    user.to_pdf_brief_info(pdf) if show_user
    pdf.table([[" Socioeconomic "]], :row_colors => ['#D999FF'], :column_widths => [ 523], :cell_style=> {align: :center})
    pdf.table([[ "Name: ", " #{name}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Icdcm code: ", " #{icdcm_code}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Status: ", " #{socioeconomic_status}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Type: ", " #{socioeconomic_type}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Date identified: ", " #{date_identified}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Date resolved: ", " #{date_resolved}"]], :column_widths => [ 150, 373])

    pdf.table([[ "description: ", " #{ActionView::Base.full_sanitizer.sanitize(description)}"]], :column_widths => [ 150, 373])
  end
end
