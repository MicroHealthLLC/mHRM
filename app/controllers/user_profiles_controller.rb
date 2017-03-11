class UserProfilesController < ApplicationController
  include ApplicationHelper
  add_breadcrumb I18n.t(:home), :root_path
  before_action  :authenticate_user!
  before_action :authorize, except: [:occupational_record, :profile_record ]

  def profile_record
    @languages = Language.visible.all_data if module_enabled?( 'languages')  && can?(:manage_roles, :view_languages, :manage_languages)
    @contacts = Contact.visible.all_data if module_enabled?( 'contacts')  && can?(:manage_roles, :view_contacts, :manage_contacts)
    @affiliations = Affiliation.visible.all_data if module_enabled?( 'affiliations')  && can?(:manage_roles, :view_affiliations, :manage_affiliations)
    @user_insurances = UserInsurance.visible.all_data if module_enabled?( 'user_insurances')  && can?(:manage_roles, :view_user_insurances, :manage_user_insurances)
    @documents = Document.for_profile.visible.all_data if module_enabled?( 'documents')  && can?(:manage_roles, :view_documents, :manage_documents)
  end

  def occupational_record
    @educations = Education.visible.all_data if module_enabled?( 'educations')  && can?(:manage_roles, :view_educations, :manage_educations)
    @other_skills = OtherSkill.visible.all_data if module_enabled?( 'other_skills')  && can?(:manage_roles, :view_other_skills, :manage_other_skills)
    @certifications = Certification.visible.all_data if module_enabled?( 'certifications')  && can?(:manage_roles, :view_certifications, :manage_certifications)
    @clearances = Clearance.visible.all_data if module_enabled?( 'clearances')  && can?(:manage_roles, :view_clearances, :manage_clearances)
    @positions = Position.visible.all_data if module_enabled?( 'positions')  && can?(:manage_roles, :view_positions, :manage_positions)
    @injuries = Injury.visible.all_data if module_enabled?( 'injuries')  && can?(:manage_roles, :view_injuries, :manage_injuries)
    @worker_compensations = WorkerCompensation.visible.all_data if module_enabled?( 'worker_compensations')  && can?(:manage_roles, :view_worker_compensations, :manage_worker_compensations)
    @job_applications = JobApplication.visible.all_data if module_enabled?( 'job_applications')  && can?(:manage_roles, :view_job_applications, :manage_job_applications)
  end
end