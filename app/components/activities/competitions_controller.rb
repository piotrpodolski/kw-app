module Activities
  class CompetitionsController < ApplicationController
    append_view_path 'app/components'

    def index
      @q = Activities::CompetitionRecord.ransack(params[:q])
      @q.sorts = 'starts_at asc' if @q.sorts.empty?
      @competitions = @q.result(distinct: true)

      @competition = Activities::CompetitionRecord.new
    end

    def new
      @competition = Activities::CompetitionRecord.new
    end

    def create
      @competition = Activities::CompetitionRecord.new(competition_params)
      @competition.creator_id = current_user.id

      if @competition.save
        redirect_to competitions_path(q: params.to_unsafe_h[:q]), notice: 'Dodano zawody'
      else
        render :new
      end
    end

    private

    def competition_params
      params.require(:competition).permit(:name, :description, :start_date, :end_date, :website,
                                          :creator_id, :country, :category_type, :slug, :state)
    end
  end
end
