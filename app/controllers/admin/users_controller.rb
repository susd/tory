class Admin::UsersController < AdminController
  respond_to :html
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    flash[:notice] = 'User was successfully created.' if @user.save
    respond_with @user
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'User updated.'
    else
      render action: :edit
    end
  end
  
  def delete
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
  
end