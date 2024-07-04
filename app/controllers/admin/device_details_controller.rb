class Admin::DeviceDetailsController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @devices = DeviceDetail.all.paginate(page: params[:page], per_page: 15).order(created_at: :desc)
  end

  def show
    @device = DeviceDetail.find(params[:id])
    @appOpens = AppOpen.where(device_id: @device.device_id).paginate(page: params[:page], per_page: 15).order(created_at: :desc)
  end
end
