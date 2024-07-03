class Admin::LoginController < ApplicationController
  def new
  end

  def login
    if params[:username] == "admin@gmail.com" && params[:password] == "Cric@News"
      session[:admin_authenticated] = true
      redirect_to admin_dashboard_path
    else
      redirect_to admin_path, notice: "Invalid email or password"
    end
  end

  def logout
    session[:admin_authenticated] = nil
    redirect_to admin_path, notice: "Logged out successfully!"
  end
end
