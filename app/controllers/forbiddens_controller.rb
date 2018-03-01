class ForbiddensController < ApplicationController
  before_action :set_forbidden, only: [:show, :edit, :update, :destroy]
  before_action :so_user_check, only: [:show, :edit, :update, :destroy, :signout]
  
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
    @forbidden = Forbidden.new
  end

  # GET /forbiddens/1/edit
  def edit
  end

  # POST /forbiddens
  # POST /forbiddens.json
  def create
    @forbidden = Forbidden.new(forbidden_params)
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

  # PATCH/PUT /forbiddens/1
  # PATCH/PUT /forbiddens/1.json
  def update
    Log.new({user: current_user.user, 
              subject: "user:"+@forbidden.user,
              operation: "updated forbidden",
              object:    "table:"+@forbidden.relation
            }).save

    respond_to do |format|
      if @forbidden.update(forbidden_params)
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

  def so_user_check
    if current_user.present? and current_user.role == :SO
      @user = User.find( current_user.id )
    end
  end

  # Use callbacks to share common setup or constraints between actions.
    def set_forbidden
      @forbidden = Forbidden.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forbidden_params
      params.require(:forbidden).permit(:user, :relation)
    end
end
