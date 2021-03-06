require 'rails_helper'

RSpec.describe "appointment_captures/new", type: :view do
  before(:each) do
    assign(:appointment_capture, AppointmentCapture.new(
      :user_id => 1,
      :appointment_id => 1,
      :assessment_id => 1,
      :disposition_id => 1,
      :procedure_id => 1,
      :note => "MyText"
    ))
  end

  it "renders new appointment_capture form" do
    render

    assert_select "form[action=?][method=?]", appointment_captures_path, "post" do

      assert_select "input#appointment_capture_user_id[name=?]", "appointment_capture[user_id]"

      assert_select "input#appointment_capture_appointment_id[name=?]", "appointment_capture[appointment_id]"

      assert_select "input#appointment_capture_assessment_id[name=?]", "appointment_capture[assessment_id]"

      assert_select "input#appointment_capture_disposition_id[name=?]", "appointment_capture[disposition_id]"

      assert_select "input#appointment_capture_procedure_id[name=?]", "appointment_capture[procedure_id]"

      assert_select "textarea#appointment_capture_note[name=?]", "appointment_capture[note]"
    end
  end
end
