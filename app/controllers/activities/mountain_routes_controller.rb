module Activities
  class MountainRoutesController < ApplicationController
    append_view_path 'app/components'
    before_action :authenticate_user!, only: [:create, :update, :destroy]

    def index
      @q = Db::Activities::MountainRoute.where(hidden: false)
      @q = @q.climbing if params[:route_type] == 'climbing'
      @q = @q.ski if params[:route_type] == 'ski'
      @q = @q.ransack(params[:q])
      @q.sorts = 'climbing_date desc' if @q.sorts.empty?
      @routes = @q.result(distinct: true).includes(:user).page(params[:page]).per(10).uniq
      @prev_month_leaders = Training::Activities::Repository.new.fetch_prev_month
      @current_month_leaders = Training::Activities::Repository.new.fetch_current_month
      @season_leaders = Training::Activities::Repository.new.fetch_season

      authorize! :read, Db::Activities::MountainRoute

      respond_to do |format|
        format.html
        format.xlsx do
          disposition = "attachment; filename='przejscia_#{Time.now.strftime("%Y-%m-%d-%H%M%S")}.xlsx'"
          response.headers['Content-Disposition'] = disposition
        end
      end
    end

    def new
      @route = Db::Activities::MountainRoute.new

      authorize! :create, Db::Activities::MountainRoute
    end

    def show
      @route = Db::Activities::MountainRoute.find(params[:id])
      authorize! :read, @route
    end

    def edit
      @route = Db::Activities::MountainRoute.find(params[:id])
      return redirect_to activities_mountain_routes_path, alert: t('.not_owner') unless user_signed_in?
      return redirect_to activities_mountain_routes_path, alert: t('.not_owner') unless current_user.admin? || current_user.id == @route.user_id || @route.colleagues.include?(current_user)
    end

    def update
      @route = Db::Activities::MountainRoute.find(params[:id])

      if @route.update(route_params)
        redirect_to activities_mountain_route_path(@route), notice: t('.updated_successfully')
      else
        render :edit
      end
    end

    def hide
      route = Db::Activities::MountainRoute.find(params[:id])

      authorize! :hide, route
      route.update(hidden: true)

      redirect_back(fallback_location: activities_mountain_routes_path, notice: t('.hidden_successfully'))
    end

    def create
      @route = Db::Activities::MountainRoute.new(route_params)
      @route.route_type = :regular_climbing
      @route.user_id = current_user.id

      return redirect_to activities_mountain_routes_path, alert: t('.has_to_be_signed_in') unless user_signed_in?

      if @route.save
        redirect_to new_activities_mountain_route_path, notice: "Dziękujemy za dodanie przejścia, możesz teraz dodać kolejne ;)"
      else
        render :new
      end
    end

    def destroy
      route = Db::Activities::MountainRoute.find(params[:id])
      if user_signed_in? && (current_user.admin? || current_user.id == route.user_id)
        route.destroy

        redirect_to activities_mountain_routes_path, notice: t('.removed_successfully')
      else
        redirect_to :back, alert: 'Musisz być właścicielem przejścia lub administratorem'
      end
    end

    private

    def route_params
      params.require(:route).permit(:peak, :mountains, :length, :area, :name, :description, :difficulty, :partners, :time, :climbing_date, :route_type, :rating, :hidden, colleagues_names: [], attachments: [])
    end
  end
end
