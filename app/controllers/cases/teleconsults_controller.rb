class TeleconsultsController  < UserCasesController

  before_action :set_teleconsult, only: [:show, :edit, :update, :destroy]

  before_action :authorize_edit, only: [:edit, :update]
  before_action :authorize_delete, only: [:destroy]


  # GET /teleconsults
  # GET /teleconsults.json
  def index
    add_breadcrumb I18n.t(:teleconsults), :teleconsults_path
    options = Hash.new
    options[:status_type] = params[:status_type]
    options[:show_case] = params[:show_case]
    options[:case_id] = params[:case_id]
    options[:appointment_id] = params[:appointment_id]
    if params[:case_id]
      @case = Case.find params[:case_id]
    end
    if params[:appointment_id]
      @appointment = Appointment.find params[:appointment_id]
    end
    respond_to do |format|
      format.html{ }
      format.js{ render 'application/index' }
      format.pdf{}
      format.csv{ params[:length] = 500

      json = TeleconsultDatatable.new(view_context, options).as_json
      send_data Teleconsult.to_csv(json[:data]), filename: "Teleconsult-#{Date.today}.csv"
      }
      format.json{

        render json: TeleconsultDatatable.new(view_context,options)
      }
    end
  end

  # GET /teleconsults/1
  # GET /teleconsults/1.json
  def show
  end

  # GET /teleconsults/new
  def new
    @teleconsult = Teleconsult.new(user_id: User.current.id,
                                   date: Date.today,
                                   case_id: params[:case_id])
    set_breadcrumbs


  end

  # GET /teleconsults/1/edit
  def edit
  end

  # POST /teleconsults
  # POST /teleconsults.json
  def create
    @teleconsult = Teleconsult.new(teleconsult_params)
    @case = @teleconsult.case
    respond_to do |format|
      if @teleconsult.save
        set_link_to_appointment(@teleconsult)
        format.html { redirect_to back_index_case_url, notice: 'Teleconsult was successfully created.' }
        format.json { render :show, status: :created, location: @teleconsult }
      else
        format.html { render :new }
        format.json { render json: @teleconsult.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teleconsults/1
  # PATCH/PUT /teleconsults/1.json
  def update
    respond_to do |format|
      if @teleconsult.update(teleconsult_params)
        format.html { redirect_to back_index_case_url, notice: 'Teleconsult was successfully updated.' }
      #  format.json { render :show, status: :ok, location: @teleconsult }
      else
        format.html { render :edit }
        format.json { render json: @teleconsult.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teleconsults/1
  # DELETE /teleconsults/1.json
  def destroy
    @teleconsult.destroy
    respond_to do |format|
      format.html { redirect_to back_index_case_url, notice: 'Teleconsult was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_teleconsult
    @teleconsult = Teleconsult.find(params[:id])
    @case = @teleconsult.case
    set_breadcrumbs
    add_breadcrumb @teleconsult.to_s, @teleconsult
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def set_breadcrumbs
    if @teleconsult.case
      add_breadcrumb @teleconsult.case, @teleconsult.case
      add_breadcrumb I18n.t(:teleconsults), case_path(@teleconsult.case) + '#tabs-teleconsults'
    else
      add_breadcrumb I18n.t(:teleconsults), :teleconsults_path
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def teleconsult_params
    params.require(:teleconsult).permit(Teleconsult.safe_attributes)
  end

  def authorize_edit
    raise Unauthorized unless @teleconsult.can?(:edit_teleconsults, :manage_teleconsults, :manage_roles)
  end

  def authorize_delete
    raise Unauthorized unless @teleconsult.can?(:delete_teleconsults, :manage_teleconsults, :manage_roles)
  end
end
