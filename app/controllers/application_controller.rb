class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def welcome
    render html: "Welcome to CS505 Project 1"
  end
end
