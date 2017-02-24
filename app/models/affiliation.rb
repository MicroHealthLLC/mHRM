class Affiliation < ApplicationRecord
  has_many :users
  belongs_to :user
  belongs_to :affiliation_type
  belongs_to :affiliation_status, foreign_key: :status_id
  has_one :affiliation_extend_demography, :dependent => :destroy


  has_many :affiliation_attachments, foreign_key: :owner_id
  accepts_nested_attributes_for :affiliation_attachments, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :name
  after_save :send_notification

  def send_notification
    UserMailer.affiliation_notification(self).deliver_later
  end

  def affiliation_status
    if status_id
      super
    else
      AffiliationStatus.default
    end
  end

   def affiliation_type
    if affiliation_type_id
      super
    else
      AffiliationType.default
    end
  end

  def visible?
    User.current == user or User.current.allowed_to?(:edit_affiliations) or User.current.allowed_to?(:manage_affiliations)
  end

  def to_s
    name
  end

  def self.safe_attributes
    [:name, :affiliation_type_id, :note, :user_id, :status_id, :date_start, :date_end ]
  end

  def extend_informations
    affiliation_extend_demography || AffiliationExtendDemography.new(affiliation_id: self.id)
  end

  def to_pdf(pdf)
    pdf.font_size(25){  pdf.text "Affiliation ##{id}", :style => :bold}
    user.to_pdf_brief_info(pdf)
    pdf.text "<b>name: </b> #{name}", :inline_format =>  true
    pdf.text "<b>Affiliation Type: </b> #{affiliation_type}", :inline_format =>  true
    pdf.text "<b>Affiliation Status: </b> #{affiliation_status}", :inline_format =>  true
    pdf.text "<b>Date Start: </b> #{date_start}", :inline_format =>  true
    pdf.text "<b>Date End: </b> #{date_end}", :inline_format =>  true
    pdf.text "<b>Note: </b> #{ActionView::Base.full_sanitizer.sanitize(note)}", :inline_format =>  true
  end

  def for_mail
    output = ""
    output<< "<h2>Affiliation ##{id} </h2>"
    output<< "<b>name: </b> #{name}<br/>"
    output<< "<b>Affiliation type: </b> #{affiliation_type}<br/>"
    output<< "<b>Affiliation Status: </b> #{affiliation_status}<br/>"
    output<< "<b>Date Start: </b> #{date_start}<br/>"
    output<< "<b>Date End: </b> #{date_end}<br/>"
    output<< "<b>Note: </b> #{note}<br/>"

    output.html_safe
  end

end
