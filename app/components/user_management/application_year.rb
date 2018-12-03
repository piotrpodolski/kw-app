require 'results'

module UserManagement
  class ApplicationYear
    class << self
      def for(profile:)
        return Failure.new(:not_found) if profile.nil?
        return current_year unless profile.application_date.present?

        return next_year if profile.application_date.between?(Date.new(current_year, 15, 11), Date.today.end_of_year)

        current_year
      end

      private

      def application_date


        profile
      end

      def current_year
        Date.today.year
      end

      def next_year
        Date.today.next_year.year
      end
    end
  end
end
