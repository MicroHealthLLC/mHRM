class Jsignature < ApplicationRecord
  belongs_to :user
  belongs_to :signature_owner, polymorphic: true

  has_many :signature_attachments, foreign_key: :owner_id, dependent: :destroy
  accepts_nested_attributes_for :signature_attachments, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :user_id, :person_name, :signature

  def to_s
    person_name
  end

  def self.enumeration_columns
    [
    ]
  end
  def self.safe_attributes
    [:user_id, :person_name, :signature_owner_type,
     :signature_owner_id,
     :signature, signature_attachments_attributes: [Attachment.safe_attributes] ]
  end

  def self.include_enumerations
    includes(:user).
        references(:user)
  end

  def self.all_data
    where(nil)
  end

  def self.csv_attributes
    [
    'Person name',
    'User',
    'User title',
    'Created at',
    'Signature'
    ]
  end

  def little_description
    output = ''
    output<< "<p> Person name: #{person_name} </p>"
    output<< "<p> Signature: #{ActionController::Base.helpers.image_tag(signature.html_safe, size: '200x150')} </p>"

    output.html_safe
  end


  def to_pdf(pdf, name = 'Signature')
    pdf.table([[name]], :row_colors => ['eeeeee'], :column_widths => [ 523], :cell_style=> {align: :center})
    pdf.table([[ "Person Name: ", " #{person_name}"]], :column_widths => [ 150, 373])
    pdf.table([[ "Owner: ", " #{signature_owner_type}"]], :column_widths => [ 150, 373])
    render_signature(pdf, false )
    pdf.move_down(10)

  end

  def render_signature(pdf, one_tab = true)
    path = "public/signature"
    unless File.directory?(path)
      FileUtils.mkdir_p(path)
    end
    image = path + "/signature_#{id}.png"
    unless FileTest.exist?(image)
      data_url = signature
      png      = Base64.decode64(data_url['data:image/png;base64,'.length .. -1])
      File.open(image, 'wb') { |f| f.write(png) }
    end
    if one_tab
      pdf.image("#{Rails.root}/#{image}", :image_height => 150, :image_width => 300)
    else
      pdf.table([[ "", {image: "#{Rails.root}/#{image}", :image_height => 150, :image_width => 300}]], :column_widths => [ 150, 373])
    end
  end
end
