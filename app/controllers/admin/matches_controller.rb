class Admin::MatchesController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @matches = Match.all.paginate(page: params[:page], per_page: 15).order(created_at: :desc)
  end

  def show
    @match = Match.find(params[:id])
  end
end
