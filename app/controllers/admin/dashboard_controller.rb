module Admin
  class DashboardController < Admin::AdminController
    layout "admin"

    def index
      @users = UserDetail.count
      @matches = Match.count
      @leagues = League.count
      @news = News.count
    end
  end
end
