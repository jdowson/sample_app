class UsersController < ApplicationController

  before_filter :authenticate,     :except => [:show, :new, :create]
  before_filter :correct_user,     :only => [:edit, :update]
  before_filter :admin_user,       :only => :destroy
  before_filter :not_self,         :only => :destroy
  before_filter :unsigned_in_only, :only => [:create, :new]
   
  def new
    @user  = User.new
    @title = "Sign up"
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = CGI.escapeHTML(@user.name)  
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    @title = 'Edit user'
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  # def following
  #   @title = "Following"
  #   @user = User.find(params[:id])
  #   @users = @user.following.paginate(:page => params[:page])
  #   render 'show_follow'
  # end
  # 
  # def followers
  #   @title = "Followers"
  #   @user = User.find(params[:id])
  #   @users = @user.followers.paginate(:page => params[:page])
  #   render 'show_follow'
  # end
  # 
  # refactored to the below...note the send(method) to call a method by name
  
  def following
    show_follow(:following)
  end

  def followers
    show_follow(:followers)
  end

  def show_follow(action)
    @title = action.to_s.capitalize
    @user = User.find(params[:id])
    @users = @user.send(action).paginate(:page => params[:page])
    render 'show_follow'
  end
  
  
  private

    def unsigned_in_only
      redirect_to(root_path) unless !signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def not_self
      @user = User.find(params[:id])
      flash[:error] = "Cannot delete current user."
      redirect_to(users_path) unless !current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
