class MtfHospital < ApplicationRecord
  belongs_to :user
  belongs_to :incident_category, optional: true
  belongs_to :incident_type, optional: true
  belongs_to :state_type, optional: true
  belongs_to :country_type, optional: true
  belongs_to :operation, optional: true
  belongs_to :verified_personnel_casualty_reporting_system, optional: true
  belongs_to :line_of_duty_investigation, optional: true

  has_many :mtf_hospital_attachments, foreign_key: :owner_id, dependent: :destroy
  accepts_nested_attributes_for :mtf_hospital_attachments, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :user_id, :mtf_hospital


  def incident_category
    if self.incident_category_id
      super
    else
      IncidentCategory.default
    end
  end

  def line_of_duty_investigation
    if self.line_of_duty_investigation_id
      super
    else
      LineOfDutyInvestigation.default
    end
  end

  def verified_personnel_casualty_reporting_system
    if self.verified_personnel_casualty_reporting_system_id
      super
    else
      VerifiedPersonnelCasualtyReportingSystem.default
    end
  end

  def operation
    if self.operation_id
      super
    else
      Operation.default
    end
  end

  def incident_type
    if self.incident_type_id
      super
    else
      IncidentType.default
    end
  end

  def state_type
    if state_id
      StateType.find_by(id: state_id)
    else
      StateType.default
    end
  end

  def country_type
    if country_id
      CountryType.find_by(id: country_id)
    else
      CountryType.default
    end
  end
  def to_s
    mtf_hospital
  end

  def self.safe_attributes
    [
        :user_id, :mtf_hospital, :incident_type_id,
        :incident_category_id, :date_od_incident, :date_diagnosed,
        :incident_location_address, :incident_location_city, :state_id,
        :country_id, :operation_id, :verified_personnel_casualty_reporting_system_id,
        :line_of_duty_investigation_id,
        :cause_of_injury, :injury_description, :pending_operation_procedure,
        mtf_hospital_attachments_attributes: [Attachment.safe_attributes]
    ]
  end
end
