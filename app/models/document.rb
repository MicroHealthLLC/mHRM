class Document < ApplicationRecord
  audited except: [:created_by_id, :updated_by_id]
  belongs_to :document_type
  belongs_to :user
  belongs_to :case, optional: true, foreign_key: :related_to_id

  validates_presence_of :title
  before_validation do
    if self.expiration_date.present? and self.date.present? and self.date > self.expiration_date
      errors[:base] << "Expiration date cannot be earlier than date"
    end
  end
  
  scope :not_private, -> {where(is_private: false)}
  scope :not_related, -> {where(related_to_id: nil)}

  has_many :document_notes, foreign_key: :owner_id

  has_many :document_attachments, foreign_key: :owner_id, dependent: :destroy
  accepts_nested_attributes_for :document_attachments, reject_if: :all_blank, allow_destroy: true
  has_many :appointment_links, as: :linkable

  default_scope -> {where(is_private: false).or(where(private_author_id: User.current_user.id)) }

  def self.for_profile
    where(related_to_id: nil)
  end

   def self.for_cases
    where.not(related_to_id: nil)
  end

  before_create :check_private_author

  def self.include_enumerations
    includes(:document_type, :case).
        references(:document_type, :case)
  end

  def self.csv_attributes
    [
        'Title',
        'Document Type',
        'date'

    ]
  end

  def check_private_author
    if self.is_private
      self.private_author_id = User.current_user.id
    end
  end

  def self.enumeration_columns
    [
        ["#{DocumentType}", 'document_type_id']
    ]
  end

  def visible?
    User.current == user or User.current.allowed_to?(:edit_documents) or User.current.allowed_to?(:manage_documents)
  end

  def self.safe_attributes
    [:title, :description, :is_client_document, :related_to_id, :snomed, :expiration_date,
     :related_to_type, :user_id, :document_type_id, :date, :private_author_id,
     :is_private, document_attachments_attributes: [Attachment.safe_attributes]]
  end

  def little_description
    output = ''
    output<< "<p> #{document_type} </p>"

    output.html_safe
  end


  def to_pdf(pdf, show_user = true)
    pdf.font_size(25){  pdf.table([[ "Document ##{id}"]], :row_colors => ['eeeeee'], :column_widths => [ 523], :cell_style=> {align: :center})}
    user.to_pdf_brief_info(pdf) if show_user
    pdf.table([[" Document "]], :row_colors => ['eeeeee'], :column_widths => [ 523], :cell_style=> {align: :center})
    pdf.table([[ "Title: ", " #{title}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Description: ", " #{ActionView::Base.full_sanitizer.sanitize(description)}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Document type: ", " #{document_type}"]], :column_widths => [ 150, 373])
  end

  def for_mail
    output = ""
    output<< "<h2>Document ##{id} </h2>"
    output<< "<b>Title: </b> #{title}<br/>"
    output<< "<b>Description: </b> #{description}<br/>"
    output<< "<b>Document type: </b> #{document_type}<br/>"
    output<< "<b>Expiration date: </b> #{expiration_date}<br/>"
    output.html_safe
  end

  def can_send_email?
    true
  end

  def to_s
    title
  end

end
