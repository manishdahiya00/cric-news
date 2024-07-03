module Admin
  class DashboardController < Admin::AdminController
    layout "admin"

    def index
      @devices = DeviceDetail.count
      @matches = Match.count
    end
  end
end
