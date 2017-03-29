module ApplicationHelper
  def current_user
    return User.find(session[:user_id]) if session[:user_id].kind_of?(Fixnum)
    false
  end

  def current_user_id
    return session[:user_id] if session[:user_id].kind_of?(Fixnum)
    nil
  end

  def auth_check
    redirect_to :controller => "users", :action => "login" unless current_user
  end
end
