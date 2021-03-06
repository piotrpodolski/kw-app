module Training
  module Supplementary
    class PackagesController < ApplicationController
      include EitherMatcher
      append_view_path 'app/components'

      def new
        @course = Training::Supplementary::CourseRecord.find(params[:course_id])
        @package = @course.package_types.new
      end

      def create
        either(create_record) do |result|
          result.success do
            redirect_back(fallback_location: root_path, notice: 'Dodałeś pakiet!')
          end

          result.failure do |errors|
            flash[:error] = errors.values.join(", ")
            redirect_back(fallback_location: root_path)
          end
        end
      end

      def create_record
        Training::Supplementary::CreatePackage.new(
          Training::Supplementary::Repository.new,
          Training::Supplementary::CreatePackageForm.new
        ).call(raw_inputs: package_params)
      end

      def package_params
        params.require(:package).permit(:name, :cost, :course_id, :membership)
      end
    end
  end
end
