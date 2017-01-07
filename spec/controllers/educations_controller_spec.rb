require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe EducationsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Education. As you add validations to Education, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:get_educations) {
     @educations = Education.visible
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EducationsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    login_client
    before(:each) do
      @education_enum = FactoryGirl.create(:enumeration)
      @education = FactoryGirl.create(:education, user_id: @user.id, education_type_id: @education_enum.id)
    end

    it "assigns all educations as @educations" do
      get :index, params: {}, session: valid_session
      expect(get_educations).to eq([@education])
    end
  end

  describe "GET #show" do
    it "assigns the requested education as @education" do
      get :show, params: {id: @education.to_param}, session: valid_session
      expect(assigns(:education)).to eq(@education)
    end
  end

  describe "GET #edit" do
    it "assigns the requested education as @education" do
      education = Education.create! valid_attributes
      get :edit, params: {id: education.to_param}, session: valid_session
      expect(assigns(:education)).to eq(education)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Education" do
        expect {
          post :create, params: {education: valid_attributes}, session: valid_session
        }.to change(Education, :count).by(1)
      end

      it "assigns a newly created education as @education" do
        post :create, params: {education: valid_attributes}, session: valid_session
        expect(assigns(:education)).to be_a(Education)
        expect(assigns(:education)).to be_persisted
      end

      it "redirects to the created education" do
        post :create, params: {education: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Education.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved education as @education" do
        post :create, params: {education: invalid_attributes}, session: valid_session
        expect(assigns(:education)).to be_a_new(Education)
      end

      it "re-renders the 'new' template" do
        post :create, params: {education: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested education" do
        education = Education.create! valid_attributes
        put :update, params: {id: education.to_param, education: new_attributes}, session: valid_session
        education.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested education as @education" do
        education = Education.create! valid_attributes
        put :update, params: {id: education.to_param, education: valid_attributes}, session: valid_session
        expect(assigns(:education)).to eq(education)
      end

      it "redirects to the education" do
        education = Education.create! valid_attributes
        put :update, params: {id: education.to_param, education: valid_attributes}, session: valid_session
        expect(response).to redirect_to(education)
      end
    end

    context "with invalid params" do
      it "assigns the education as @education" do
        education = Education.create! valid_attributes
        put :update, params: {id: education.to_param, education: invalid_attributes}, session: valid_session
        expect(assigns(:education)).to eq(education)
      end

      it "re-renders the 'edit' template" do
        education = Education.create! valid_attributes
        put :update, params: {id: education.to_param, education: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested education" do
      education = Education.create! valid_attributes
      expect {
        delete :destroy, params: {id: education.to_param}, session: valid_session
      }.to change(Education, :count).by(-1)
    end

    it "redirects to the educations list" do
      education = Education.create! valid_attributes
      delete :destroy, params: {id: education.to_param}, session: valid_session
      expect(response).to redirect_to(educations_url)
    end
  end

end
