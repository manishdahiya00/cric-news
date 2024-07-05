module Admin
  class DashboardController < Admin::AdminController
    layout "admin"

    def index
      @users = UserDetail.count
      @matches = Match.count
    end
  end
end
