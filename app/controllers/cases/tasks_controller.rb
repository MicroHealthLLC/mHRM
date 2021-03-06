class TasksController < UserCasesController

  before_action :set_task, only: [:link_plan, :add_plan, :show, :edit, :update, :destroy,
                                  :delete_sub_task_relation]

  before_action :authorize_edit, only: [:edit, :update]
  before_action :authorize_delete, only: [:destroy]


  # GET /tasks
  # GET /tasks.json
  def index
    add_breadcrumb I18n.t('tasks'), :tasks_path


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
    options[:appointment_id] = params[:appointment_id]
    respond_to do |format|
      format.html{  }
      format.js{ render 'application/index' }
      format.pdf{
        scope = Task.root
        scope = case params[:status_type]
                  when 'all' then scope.all_data
                  when 'opened' then scope.opened
                  when 'closed' then scope.closed
                  when 'flagged' then scope.flagged
                  else
                    scope.opened
                end
        scope = scope.include_enumerations.
            where('tasks.assigned_to_id = :user OR tasks.for_individual_id = :user', user:  User.current.id)
        @tasks = scope
      }
      format.csv{
        options[:show_case] = 'true'
        params[:length] = 500
        json = TaskDatatable.new(view_context, options).as_json
        send_data Task.to_csv(json[:data]), filename: "Actions-#{Date.today}.csv"
      }
      format.json{
        render json: TaskDatatable.new(view_context,options)
      }
    end
  end

  def my
    render 'tasks/index'
  end

  def link_plan
    @plans = @task.plans
    @available_plans = @task.available_plans
  end


  def add_plan
    respond_to do |format|
      format.js{
        @plan_id = params[:plan_id]
        g = @task.plan_tasks.where(plan_id: @plan_id)
        if g.present?
          g.delete_all
        else
          @plan = Plan.find(@plan_id)
          @available_plans = @task.available_plans
          if @available_plans.include?(@plan)
            @task.plans<< @plan
          end
        end
      }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    set_client_profile(@task)
    @notes = @task.task_notes
    @tasks = @task.sub_tasks

    @plans = @task.plans
  end

  # GET /tasks/new
  def new
    if params[:plan_id]
      if params[:plan_id]
        @task = Task.new(user_id: User.current.id,
                         assigned_to_id: User.current_user.id,
                         for_individual_id: User.current.id,
                         date_start: Time.now,
                         related_to_id: params[:case_id],
                         related_to_type: 'Case')
        @task.plan_tasks.build(plan_id: params[:plan_id])
      end
    else
      @task = Task.new(user_id: User.current.id,
                       date_start: Time.now,
                       assigned_to_id: User.current_user.id,
                       for_individual_id: User.current.id,
                       sub_task_id: params[:sub_task_id],
                       related_to_id: params[:related_to],
                       related_to_type: params[:type])
    end

    set_breadcrumbs
  end

  # GET /tasks/1/edit
  def edit
    set_client_profile(@task)
    @note = TaskNote.new(user_id: User.current.id)
    @notes = @task.task_notes
    @tasks = @task.sub_tasks
    @plans = @task.plans
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @case = @task.case
    @note = TaskNote.new(user_id: User.current.id)

    respond_to do |format|
      if @task.save
        set_link_to_appointment(@task)
        format.html { redirect_to back_index_case_url, notice: 'Action was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @note = TaskNote.new(user_id: User.current.id)

    @plans = @task.plans

    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to back_index_case_url, notice: 'Action was successfully updated.' }
        #  format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to back_index_case_url, notice: 'Action was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_sub_task_relation
    if params[:subtasks]
      @task.sub_tasks.each do |task|
        task.related_to_id = @task.related_to_id
        task.sub_task_id = nil
        task.save
      end
    else
      @task.related_to_id = @task.parent_task.related_to_id if  @task.parent_task
      @task.sub_task_id = nil
      @task.save
    end

    redirect_to edit_task_path(@task)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
    @case =  @task.case
    set_breadcrumbs
    add_breadcrumb @task.to_s, @task
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def set_breadcrumbs
    if @task.is_subtask? and  @parent_task = @task.parent_task and @parent_task.case
      add_breadcrumb @parent_task.case, @parent_task.case
      add_breadcrumb I18n.t('tasks'), case_path(@parent_task.case) + '#tabs-tasks'
      add_breadcrumb @parent_task.to_s, @parent_task

      @task.case = @parent_task.case

    elsif @task.is_subtask? and  @parent_task = @task.parent_task
      add_breadcrumb I18n.t('tasks'), tasks_path
      add_breadcrumb @parent_task.to_s, @parent_task
      @task.case = @parent_task.case
    elsif @task.case
      add_breadcrumb @task.case, @task.case
      add_breadcrumb I18n.t('tasks'), case_path(@task.case) + '#tabs-tasks'
    else
      add_breadcrumb I18n.t('tasks'), :tasks_path
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(Task.safe_attributes)
  end

  def authorize_edit
    raise Unauthorized unless @task.can?(:edit_tasks, :manage_tasks, :manage_roles)
  end

  def authorize_delete
    raise Unauthorized unless @task.can?(:delete_tasks, :manage_tasks, :manage_roles)
  end

end
