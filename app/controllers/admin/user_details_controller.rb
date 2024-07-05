class Admin::UserDetailsController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @users = UserDetail.all.paginate(page: params[:page], per_page: 15).order(created_at: :desc)
  end

  def show
    @user = UserDetail.find(params[:id])
    @appOpens = AppOpen.where(user_id: @user.id).paginate(page: params[:page], per_page: 15).order(created_at: :desc)
  end
end
