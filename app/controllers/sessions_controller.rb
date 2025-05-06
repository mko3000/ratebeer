class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
    puts "rendering login page"
  end

  def create
    user = User.find_by username: params[:username]
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to signin_path, notice: "Wrong username or password"
    end
  end

  def destroy
    puts "destroying session"
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
