class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:signout]
  before_action :so_user_check, only: [:show, :edit, :update, :destroy, :signout]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    Log.new({user: current_user.user, 
              subject: "user:"+current_user.user,
              operation: "Created user",
              object:    "user:"+@user.name,
            }).save

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    Log.new({user: current_user.user, 
              subject: "user:"+current_user.user,
              operation: "Updated user",
              object:    "user:"+@user.name,
              parameters: "user_params"
            }).save
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    Log.new({user: current_user.user, 
              subject: "user:"+current_user.user,
              operation: "Deleted user",
              object:    "user:"+@user.name,
            }).save
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def signout
    if current_user.present?
      session.destroy
      redirect_to root_path
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
  def set_user
    if current_user.present?
      @user = User.find(params[:id])
    end
  end

  def so_user_check
    if current_user.present? and current_user.role == :SO
      @user = User.find(params[:id])
    end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    p "UsersControllers: "+params.to_s
    params.require(:user).permit(:user, :name, :role)
  end
end
