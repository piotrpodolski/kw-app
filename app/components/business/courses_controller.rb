module Business
  class CoursesController < ApplicationController
    append_view_path 'app/components'
    respond_to :html, :xlsx

    def index
      params[:q] ||= {}
      courses = unless params[:q][:starts_at_gteq]
        Business::CourseRecord.includes(:coordinator).where('starts_at >= ?', Time.zone.now)
      else
        Business::CourseRecord.includes(:coordinator)
      end
      @q = courses.ransack(params[:q])
      @q.sorts = 'starts_at asc' if @q.sorts.empty?
      @courses = @q.result(distinct: true).page(params[:page])

      authorize! :read, Business::CourseRecord

      @course = Business::CourseRecord.new
    end

    def new
      @course = Business::CourseRecord.new
      @course.coordinator_id = current_user.id

      authorize! :create, Business::CourseRecord
    end

    def create
      @course = Business::CourseRecord.new(course_params)

      authorize! :create, Business::CourseRecord

      @course.creator_id = current_user.id

      if @course.save
        @course.update(sign_up_url: "https://panel.kw.krakow.pl/kursy/#{@course.slug}")
        project = ::Settlement::ProjectRecord.create(
          name: @course.name_with_date,
          area_type: :course_budget,
          user_id: current_user.id
        )
        ::Settlement::ProjectItemRecord.create(
          accountable_type: 'Business::CourseRecord',
          accountable_id: @course.id,
          user_id: current_user.id,
          project_id: project.id
        )
        redirect_to courses_path(q: params.to_unsafe_h[:q]), notice: 'Dodano kurs'
      else
        render :new
      end
    end

    def show
      @course = Business::CourseRecord.friendly.find(params[:id])

      authorize! :read, Business::CourseRecord

      respond_with do |format|
        format.html
        format.xlsx do
          disposition = "attachment; filename=#{@course.activity_type}_#{@course.start_date}_#{Time.now.strftime("%Y-%m-%d-%H%M%S")}.xlsx"
          response.headers['Content-Disposition'] = disposition
        end
      end
    end

    def public
      @course = Business::CourseRecord.friendly.find(params[:id])
      @sign_up = @course.sign_ups.new

      render layout: 'public'
    end

    def seats_minus
      @course = Business::CourseRecord.find(params[:id])
      @course.seats -= 1

      authorize! :manage, Business::CourseRecord

      if @course.save
        redirect_to courses_path(q: params.to_unsafe_h[:q]), notice: 'Zwolniono miejsce!'
      else
        redirect_to courses_path(q: params.to_unsafe_h[:q]), alert: @course.errors.messages
      end
    end

    def seats_plus
      @course = Business::CourseRecord.find(params[:id])
      @course.seats += 1

      authorize! :manage, Business::CourseRecord

      if @course.save
        redirect_to courses_path(q: params.to_unsafe_h[:q]), notice: 'Zwolniono miejsce!'
      else
        redirect_to courses_path(q: params.to_unsafe_h[:q]), alert: @course.errors.full_messages
      end
    end

    def edit
      @course = Business::CourseRecord.find(params[:id])

      authorize! :manage, Business::CourseRecord
    end

    def update
      @course = Business::CourseRecord.find(params[:id])

      authorize! :manage, Business::CourseRecord

      if @course.update(course_params)
        redirect_to edit_course_path(@course.id), notice: 'Zaktualizowano kurs'
      else
        render :edit
      end
    end

    def destroy
      @course = Business::CourseRecord.find(params[:id])
      @course.destroy

      authorize! :manage, Business::CourseRecord

      redirect_to courses_path(q: params.to_unsafe_h[:q]), notice: 'Usunięto kurs'
    end

    private

    def course_params
      params
        .require(:course)
        .permit(
          :coordinator_id, :price, :seats, :starts_at,:ends_at,
          :description, :activity_type, :state, :instructor_id,
          :max_seats, :sign_up_url, :creator_id, :event_id,
          :payment_first_cost, :payment_second_cost, :equipment,
          :email_first_content, :email_second_content, :cash
        )
    end
  end
end
