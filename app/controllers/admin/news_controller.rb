class Admin::NewsController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @news_data = News.all.paginate(page: params[:page], per_page: 15).order(created_at: :desc)
  end
end
