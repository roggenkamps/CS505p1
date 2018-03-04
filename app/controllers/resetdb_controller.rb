class ResetdbController < ActionController::Base
  def resetdb
    if current_user.role == "SO"
      respond_to do |format|
        format.html { render :show, notice: 'RESET DB' }
        format.json { render :show, status: :ok, location: @assigned }
      end
    else
      respond_to do |format|
        format.html { redirect_to :root }
        format.json { render json: @assigned.errors, status: :unprocessable_entity }
      end
    end
  end

  def resetdb_commit
    if current_user.role == "SO"
      rc = Kernel.system( "bin/reset_database.sh" )
      if rc.present? and rc
        Log.new({user: current_user.user, 
                 subject: "database",
                 operation: "RESET"
                }).save
        
        respond_to do |format|
          format.html { redirect_to :root, notice: "Database successfully reset" }
          format.json { render json: @assigned.errors, status: :unprocessable_entity }
        end
      else
        respond_to do |format|
          format.html { redirect_to :root, notice: "Database reset failed, exit = "+$?.to_s }
          format.json { render json: @assigned.errors, status: :unprocessable_entity }
        end
      end
    end
  end
end
