class RelationsController < ApplicationController
  before_action :set_relation, only: [:show, :edit, :update, :destroy]

  # GET /relations
  # GET /relations.json
  def index
    @relations = Relation.all
  end

  # GET /relations/1
  # GET /relations/1.json
  def show
    if false # !check_permissions( current_user.user, @relation.name, 0 )
      Log.new({user: current_user.user, 
               subject: "user:"+current_user.user,
               operation: "ACCESS DENIED",
               object:  "table:"+@relation.name
              }).save
      redirect_to relations_path
    end
  end

  # GET /relations/new
  def new
    @relation = Relation.new
  end

  # GET /relations/1/edit
  def edit
  end

  # POST /relations
  # POST /relations.json
  def create
    if current_user.role != "SO"
      Log.new({user: current_user.user, 
               subject: "user:"+current_user.user,
               operation: "CREATE DENIED",
               object:  "table:"+relation_params[:name]
              }).save
      redirect_to relations_path
    else
      Log.new({user: current_user.user, 
               subject: "user:"+current_user.user,
               operation: "created",
               object:  "table:"+relation_params[:name]
              }).save
      @relation = Relation.new(relation_params)

      respond_to do |format|
        if @relation.save
          format.html { redirect_to @relation, notice: 'Relation was successfully created.' }
          format.json { render :show, status: :created, location: @relation }
        else
          format.html { render :new }
          format.json { render json: @relation.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /relations/1
  # PATCH/PUT /relations/1.json
  def update
    if false #  !check_permissions( current_user.user, @relation.name, 0 )
      Log.new({user: current_user.user, 
               subject: "user:"+current_user.user,
               operation: "UPDATE DENIED",
               object:  "table:"+@relation.name
              }).save
      redirect_to relations_path
    else
      Log.new({user: current_user.user, 
               subject: "user:"+current_user.user,
               operation: "modiifed",
               object:  "table:"+@relation.name
              }).save
      respond_to do |format|
        if @relation.update(relation_params)
          format.html { redirect_to @relation, notice: 'Relation was successfully updated.' }
          format.json { render :show, status: :ok, location: @relation }
        else
          format.html { render :edit }
          format.json { render json: @relation.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /relations/1
  # DELETE /relations/1.json
  def destroy
    if false #  !check_permissions( current_user.user, @relation.name, 0 )
      Log.new({user: current_user.user, 
              subject: "user:"+current_user.user,
              operation: "dropped",
              object:  "table:"+@relation.name
              }).save
      redirect_to relations_path
    else
      Log.new({user: current_user.user, 
               subject: "user:"+current_user.user,
               operation: "dropped",
               object:  "table:"+@relation.name
              }).save
      @relation.destroy
      respond_to do |format|
        format.html { redirect_to relations_url, notice: 'Relation was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private

  def check_permissions(username,tablename,level)
    # current user must have permisison to show a table
    # first check the forbiddens table to see if the user cannot access the table

    byebug
    user = User.find_by_user( username )
    if user.role == 'SO'
      return true
    end
    forbid = Forbidden.find_by( user: username, relation: tablename )
    if forbid.present?
        return false
    else
      permitted = Assigned.where( grantee: username, relation: tablename )
      rc = permitted.present?
      permitted.find_each do |permission|
        grantor = User.find_by_user( permission.grantor )
        if grantor.role == 'SO'
          return true
        else
          if permission.can_grant or level == 0
            if check_permissions( grantor.user, tablename, level + 1 )
              return true
            end
          end
        end
      end
    end
    return false
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_relation
    @relation = Relation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def relation_params
    params.require(:relation).permit(:name, :description)
  end
end
