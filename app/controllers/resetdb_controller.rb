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
      Kernel.system( "bin/rake db:reset" )
      respond_to do |format|
        format.html { redirect_to :root, notice: "Database reset" }
        format.json { render json: @assigned.errors, status: :unprocessable_entity }
      end
    end
  end
end
