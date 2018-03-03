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
    if !check_permissions( current_user.user, @relation.name, false )
      Log.new({user: current_user.user, 
               subject: "user:"+current_user.user,
               operation: "ACCESS DENIED",
               object:  "table:"+@relation.name
              }).save
      redirect_to relations_path, notice: current_user.user+": you do not have permisisons to view "+@relation.name
    end
  end

  # GET /relations/new
  def new
    @relation = Relation.new
  end

  # GET /relations/1/edit
  def edit
    if !check_permissions( current_user.user, @relation.name, false )
      Log.new({user: current_user.user, 
               subject: "user:"+current_user.user,
               operation: "ACCESS DENIED",
               object:  "table:"+@relation.name
              }).save
      redirect_to relations_path, notice: current_user.user+": you do not have permisisons to change "+@relation.name
    end
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
      respond_to do |format|
        if @relation.save
          format.html { redirect_to @relation, notice: current_user.user+': you do not have permissions to create a table' }
          format.json { render :show, status: :denied, location: @relation }
        else
          format.html { render :new }
          format.json { render json: @relation.errors, status: :unprocessable_entity }
        end
      end
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
    if !check_permissions( current_user.user, @relation.name, false )
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
    if !check_permissions( current_user.user, @relation.name, false )
      Log.new({user: current_user.user, 
              subject: "user:"+current_user.user,
              operation: "DROP ACCESS DENIED",
              object:  "table:"+@relation.name
              }).save
      redirect_to relations_path,  notice: current_user.user+": you do not have permisisons to drop "+@relation.name
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

  # check_permissions - check permissions of the user
  # username  - name of the user
  # tablename - name of the table
  # granting  - is this user granting privileges to others?
  def check_permissions(username,tablename, granting )
    # current user must have permisison to show a table
    # first check the forbiddens table to see if the user cannot access the table

    user = User.find_by_user( username )

    # check to see if this user is on the FORBIDDEN list for this table
    forbidden = Forbidden.find_by( user: username, relation: tablename, active: true )

    # users with role of 'SO' have permission to do anything
    if user.role == 'SO' && !forbidden.present?
      return true
    end

    if forbidden.present?
      return false
    else
      level = 0

      # perform a depdth-first search of the ASSIGNED, starting with username
      # and going backward in the graph to a user with a role of SO
      # activeUsers contains the list of users who may have permission
      activeUsers = [ username ]
      while !activeUsers.empty?
        username = activeUsers.shift

        # get array of users who have granted permission to username
        permitted = Assigned.where( grantee: username, relation: tablename )
        permitted.find_each do |permission|

          # check if the grantor in the chain has granted permission
          # and they are not in the FORBIDDENS table
          grantor = User.find_by_user( permission.grantor )
          forbidden = Forbidden.find_by( user: grantor.user, relation: tablename, active: true )
          if !forbidden.present?

            # the grantor is not FORBIDDEN
            # if the original user is granting privileges to someone else
            # we need to check whether everyon in the chain has the
            # GRANT privilege
            if granting
              if grantor.role == 'SO'
                if permission.can_grant
                  return true   # we are done
                else
                  return false  # but the SO did not grant privilege to GRANT
                end
              else
                # add the grantor to the list of users to check
                if permission.can_grant
                  activeUsers << grantor.user
                end
              end
            else
              if permission.can_grant || level == 0
                if grantor.role == 'SO'
                  return true
                else
                  activeUsers << grantor.user
                end
              end
            end
          end
        end
        level = level + 1
      end
    end
    return false
  end

  def RelationsController.check_permissions(username,tablename, granting )
#    byebug
    @new_rel = new
    rc = @new_rel.check_permissions(username,tablename, granting )
    return rc
  end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_relation
    @relation = Relation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def relation_params
    params.require(:relation).permit(:name, :description)
  end
end
