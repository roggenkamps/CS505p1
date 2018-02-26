class HomepageController < ApplicationController
	include ApplicationHelper
  def index
  end

  def show
    set_homepage
  end

  private

  def set_homepage
    if current_user.present?
      if current_user.role == "SO"
        @assigneds = Assigned.find_by_grantor( current_user.user )
        @tables    = Relation.all
        @log_entries = Log.where( "user = '"+current_user.user+"'" )
      else
      end
    else
      redirect_to new_user_session_path
    end
  end
end
