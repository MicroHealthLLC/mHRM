module AppointmentsHelper
  def appointment_back_url appointment
    appointment.related_to_id ? appointment.case : appointments_path
  end

  def date_time_form(datetime)
    datetime.strftime("%Y-%m-%d %I:%M %p") if datetime
  end

  def appointment_tabs
    tabs =  [ ]
    tabs<< {:name => 'capture', :partial => 'appointments/partials/captures', :label => 'Assessments'}
    tabs<< {:name => 'disposition', :partial => 'appointments/partials/disposition', :label => 'Dispositions'}
    tabs<< {:name => 'procedure', :partial => 'appointments/partials/procedure', :label => 'Procedures'}
    if module_enabled? 'billings'
      tabs<< {:name => 'billing', :partial => 'appointments/partials/billing', :label => 'Billings'}
    end
    tabs<< {:name => 'note', :partial => 'appointments/partials/notes', :label => 'Notes'}
    tabs<< {:name => 'signature', :partial => 'appointments/partials/signature', :label => 'Signatures'}
    tabs
  end

  def appointment_case_tabs
    tabs =  [ ]

    if @needs or @plans or @goals or @tasks or @jsignatures
      tabs<< {:name => 'care_plan', :partial => 'cases/show_case/care_plan', :label => :care_plan}
    end

    #  if @cases
    #    tabs<<  {:name => 'subcases', :partial => 'cases/show_case/subcases', :label => :subcases}
    #  end

    if @case_supports
      tabs<< {:name => 'case_supports', :partial => 'cases/show_case/case_support', :label => :case_supports}
    end

    if @notes
      tabs<<  {:name => 'notes', :partial => 'cases/show_case/notes', :label => :notes}
    end

    if @documents
      tabs<< {:name => 'documents', :partial => 'cases/show_case/documents', :label => :documents}
    end

    if @enrollments
      tabs<< {:name => 'enrollments', :partial => 'cases/show_case/enrollments', :label => :enrollments}
    end

    if @teleconsults
      tabs<< {:name => 'teleconsults', :partial => 'cases/show_case/teleconsults', :label => :teleconsults}
    end

    if @checklists
      tabs<< {:name => 'checklists', :partial => 'cases/show_case/checklists', :label => :checklists}
    end

    if @transports
      tabs<< {:name => 'transports', :partial => 'cases/show_case/transports', :label => :transports}
    end

    if @measurement_records
      tabs<< {:name => 'measurement_records', :partial => 'cases/show_case/measurement_records', :label => 'Measurements'}
    end

    if @appointments
      tabs<< {:name => 'appointments', :partial => 'cases/show_case/appointments', :label => :appointments}
    end

    if @referrals
      tabs<<    {:name => 'referrals', :partial => 'cases/show_case/referrals', :label => :referrals}
    end

    if @worker_compensations
      tabs<<  {:name => 'worker_compensations', :partial => 'cases/show_case/worker_compensation', :label => :worker_compensation}
    end

    if @job_apps
      tabs<<  {:name => 'job_applications', :partial => 'cases/show_case/job_app', :label => 'Job Applications'}
    end

    if @case_organizations
      tabs<<  {:name => 'case_organizations', :partial => 'cases/show_case/case_organizations', :label => 'Share Organizations'}
    end


    tabs
  end

  
end
