class AssignedsController < ApplicationController
  before_action :set_assigned, only: [:show, :edit, :update, :destroy]

  # GET /assigneds
  # GET /assigneds.json
  def index
    if current_user.present? and current_user.role == "SO"
      @assigneds = Assigned.all.order( :grantor, :grantee )
    else
      @assigneds = Assigned.where( grantor: current_user.name ).order( :grantor, :grantee )
    end
  end

  # GET /assigneds/1
  # GET /assigneds/1.json
  def show
  end

  # GET /assigneds/new
  def new
    @assigned = Assigned.new
  end

  # GET /assigneds/1/edit
  def edit
  end

  # POST /assigneds
  # POST /assigneds.json
  def create
    @assigned = Assigned.new(assigned_params)
    @table    = Relation.find_by_name( @assigned.relation )
#    byebug
    if @table.present?
      if RelationsController.check_permissions( @assigned.grantor, @assigned.relation, true )
        Log.new({user: current_user.user, 
                 subject: "user:"+@assigned.grantee,
                 operation: "added access",
                 object:    "table:"+@assigned.relation,
                 parameters: "canGrant:"+@assigned.can_grant.to_s
                }).save
        respond_to do |format|
          if @assigned.save
            format.html { redirect_to @assigned, notice: 'Assigned was successfully created.' }
            format.json { render :show, status: :created, location: @assigned }
          else
            format.html { redirect_to assigneds_path, notice: 'Problem saving Assigned.' }
            format.json { render json: @assigned.errors, status: :unprocessable_entity }
          end
        end
      else
        Log.new({user: current_user.user, 
                 subject: "user:"+@assigned.grantee,
                 operation: "ACCESS DENIED",
                 object:    "table:"+@assigned.relation,
                 parameters: "canGrant:"+@assigned.can_grant.to_s
                }).save
        respond_to do |format|
          format.html { redirect_to :root, notice: 'Access denied to '+@assigned.relation }
          format.json { render json: @assigned.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to :root, notice: 'Table not found: '+@assigned.relation }
        format.json { render json: @assigned.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assigneds/1
  # PATCH/PUT /assigneds/1.json
  def update
    Log.new({user: current_user.user, 
              subject: "user:"+@assigned.grantee,
              operation: "modified access",
              object:    "table:"+@assigned.relation,
              parameters: "canGrant:"+@assigned.can_grant.to_s
            }).save

    respond_to do |format|
      if @assigned.update(assigned_params)
        format.html { redirect_to @assigned, notice: 'Assigned was successfully updated.' }
        format.json { render :show, status: :ok, location: @assigned }
      else
        format.html { render :edit }
        format.json { render json: @assigned.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assigneds/1
  # DELETE /assigneds/1.json
  def destroy
    Log.new({user: current_user.user, 
              subject: "user:"+@assigned.grantee,
              operation: "revoked access",
              object:    "table:"+@assigned.relation
            }).save
    @assigned.destroy
    respond_to do |format|
      format.html { redirect_to assigneds_url, notice: 'Assigned was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assigned
      @assigned = Assigned.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assigned_params
      params.require(:assigned).permit(:grantor, :grantee, :relation, :can_grant)
    end
end
