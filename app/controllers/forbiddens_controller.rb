class ForbiddensController < ApplicationController
  before_action :set_forbidden, only: [:show, :edit, :update, :destroy]
  before_action :so_user_check, only: [:create, :show, :edit, :update, :destroy]
  
  # GET /forbiddens
  # GET /forbiddens.json
  def index
    @forbiddens = Forbidden.all
  end

  # GET /forbiddens/1
  # GET /forbiddens/1.json
  def show
  end

  # GET /forbiddens/new
  def new
    if current_user.present?
      if current_user.role == "SO"
        @forbidden = Forbidden.new
      else
        Log.new({user: current_user.user, 
                 subject: "user:"+@forbidden.user,
                 operation: "created forbidden",
                 object:    "table:"+@forbidden.relation
                }).save
      end
    end
  end
  
  # GET /forbiddens/1/edit
  def edit
  end

  # POST /forbiddens
  # POST /forbiddens.json
  def create
    if current_user.present? && current_user.role == "SO"
      @forbidden = Forbidden.new(forbidden_params)
      if !@forbidden.attempts.present?
        @forbidden.attempts = 0
      end
      @assigned = Assigned.where( grantee: @forbidden.user, relation: @forbidden.relation )
      @assigned = @assigned.first
      if @forbidden.attempts == 0 and @assigned.present?
        @forbidden.attempts = @forbidden.attempts+1
        @forbidden.active = false
        respond_to do |format|
          if @forbidden.save
            @forbidden = Forbidden.where( user: @forbidden.user, relation:@forbidden.relation ).first
            format.html { redirect_to edit_forbidden_path(@forbidden.id), warning: "User: %{@forbidden.user} currently has access to %{@forbidden.relation} table.  Please confirm removing access." }
            format.json { render json: @forbidden.warning, status: "User currently has access" }
          else
            format.html { render :new }
            format.json { render json: @forbidden.errors, status: :unprocessable_entity }
          end
        end
      else
        @forbidden.active = true
        Log.new({user: current_user.user, 
                 subject: "user:"+@forbidden.user,
                 operation: "created forbidden",
                 object:    "table:"+@forbidden.relation
                }).save

        respond_to do |format|
          if @forbidden.save
            format.html { redirect_to @forbidden, notice: 'Forbidden was successfully created.' }
            format.json { render :show, status: :created, location: @forbidden }
          else
            format.html { render :new }
            format.json { render json: @forbidden.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  # PATCH/PUT /forbiddens/1
  # PATCH/PUT /forbiddens/1.json
  def update
    Log.new({user: current_user.user, 
             subject: "user:"+@forbidden.user,
             operation: "updated forbidden",
             object:    "table:"+@forbidden.relation
            }).save
    @updated_params = forbidden_params
    set_forbidden
    updates = {}
    if @forbidden.attempts == 1 and !@forbidden.active
      updates[:active] = true
      updates[:attempts] = 0
    end
    respond_to do |format|
      if @forbidden.update(updates)
        format.html { redirect_to @forbidden, notice: 'Forbidden was successfully updated.' }
        format.json { render :show, status: :ok, location: @forbidden }
      else
        format.html { render :edit }
        format.json { render json: @forbidden.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forbiddens/1
  # DELETE /forbiddens/1.json
  def destroy
    Log.new({user: current_user.user, 
             subject: "user:"+@forbidden.user,
             operation: "deleted forbidden",
             object:    "table:"+@forbidden.relation
            }).save
    @forbidden.destroy
    respond_to do |format|
      format.html { redirect_to forbiddens_url, notice: 'Forbidden was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # insure only SO can create Forbiddens
  def so_user_check
    if current_user.present? and current_user.role == :SO
      @forbidden = Forbidden.find(params[:id])
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_forbidden
    @forbidden = Forbidden.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def forbidden_params
    params.require(:forbidden).permit(:id,:user, :relation, :attempts, :active )
  end
end
