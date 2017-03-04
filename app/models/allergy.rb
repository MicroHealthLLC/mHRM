class Allergy < ApplicationRecord
  belongs_to :user
  belongs_to :icdcm_code, :foreign_key => 'allergy_type_id', class_name: 'Icd10datum'
  belongs_to :allergy_status, optional: true

  has_many :allergy_attachments, foreign_key: :owner_id, dependent: :destroy
  accepts_nested_attributes_for :allergy_attachments, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :user_id

  def allergy_type
    icdcm_code
  end

  def self.enumeration_columns
    [
        ["#{AllergyStatus}", 'allergy_status_id']
    ]
  end

  def allergy_status
    if allergy_status_id
      super
    else
      AllergyStatus.default
    end
  end


  def to_s
    icdcm_code
  end


  def self.safe_attributes
    [
        :user_id, :allergy_type_id, :medication,
        :allergy_date, :allergy_status_id, :description,
        allergy_attachments_attributes: [Attachment.safe_attributes]
    ]
  end

  def to_pdf(pdf)
    pdf.font_size(25){  pdf.text "Allergy ##{id}", :style => :bold}
    user.to_pdf_brief_info(pdf)
    pdf.text "<b>medication: </b> #{icdcm_code}", :inline_format =>  true
    pdf.text "<b>Allergy Type: </b> #{allergy_type}", :inline_format =>  true
    pdf.text "<b>Allergy Status: </b> #{allergy_status}", :inline_format =>  true
    pdf.text "<b>Allergy date: </b> #{allergy_date}", :inline_format =>  true
    pdf.text "<b>description: </b> #{ActionView::Base.full_sanitizer.sanitize(description)}", :inline_format =>  true
  end
end
