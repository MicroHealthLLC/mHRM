json.extract! appointment_capture, :id, :user_id, :appointment_id, :assessment_id, :disposition_id, :procedure_id, :note, :created_at, :updated_at
json.url appointment_capture_url(appointment_capture, format: :json)