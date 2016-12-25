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

RSpec.describe NeedsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Need. As you add validations to Need, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # NeedsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all needs as @needs" do
      need = Need.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:needs)).to eq([need])
    end
  end

  describe "GET #show" do
    it "assigns the requested need as @need" do
      need = Need.create! valid_attributes
      get :show, params: {id: need.to_param}, session: valid_session
      expect(assigns(:need)).to eq(need)
    end
  end

  describe "GET #new" do
    it "assigns a new need as @need" do
      get :new, params: {}, session: valid_session
      expect(assigns(:need)).to be_a_new(Need)
    end
  end

  describe "GET #edit" do
    it "assigns the requested need as @need" do
      need = Need.create! valid_attributes
      get :edit, params: {id: need.to_param}, session: valid_session
      expect(assigns(:need)).to eq(need)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Need" do
        expect {
          post :create, params: {need: valid_attributes}, session: valid_session
        }.to change(Need, :count).by(1)
      end

      it "assigns a newly created need as @need" do
        post :create, params: {need: valid_attributes}, session: valid_session
        expect(assigns(:need)).to be_a(Need)
        expect(assigns(:need)).to be_persisted
      end

      it "redirects to the created need" do
        post :create, params: {need: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Need.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved need as @need" do
        post :create, params: {need: invalid_attributes}, session: valid_session
        expect(assigns(:need)).to be_a_new(Need)
      end

      it "re-renders the 'new' template" do
        post :create, params: {need: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested need" do
        need = Need.create! valid_attributes
        put :update, params: {id: need.to_param, need: new_attributes}, session: valid_session
        need.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested need as @need" do
        need = Need.create! valid_attributes
        put :update, params: {id: need.to_param, need: valid_attributes}, session: valid_session
        expect(assigns(:need)).to eq(need)
      end

      it "redirects to the need" do
        need = Need.create! valid_attributes
        put :update, params: {id: need.to_param, need: valid_attributes}, session: valid_session
        expect(response).to redirect_to(need)
      end
    end

    context "with invalid params" do
      it "assigns the need as @need" do
        need = Need.create! valid_attributes
        put :update, params: {id: need.to_param, need: invalid_attributes}, session: valid_session
        expect(assigns(:need)).to eq(need)
      end

      it "re-renders the 'edit' template" do
        need = Need.create! valid_attributes
        put :update, params: {id: need.to_param, need: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested need" do
      need = Need.create! valid_attributes
      expect {
        delete :destroy, params: {id: need.to_param}, session: valid_session
      }.to change(Need, :count).by(-1)
    end

    it "redirects to the needs list" do
      need = Need.create! valid_attributes
      delete :destroy, params: {id: need.to_param}, session: valid_session
      expect(response).to redirect_to(needs_url)
    end
  end

end
