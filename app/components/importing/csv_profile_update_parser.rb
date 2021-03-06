module Importing
  class CsvProfileUpdateParser
    class << self
      REQUIRED_PROFILE_HEADERS = %w(
        email acomplished_courses sections profession
      )

      def parse(file:)
        parsed_data = []
        invalid_lines = {}
        return Failure.new(:invalid, message: I18n.t('.empty_file')) if file.size.zero?

        CSV.open(file.path, col_sep: ';', headers: true).each_with_index do |row, index|
          next if row.empty?

          if index == 0
            result = check_headers(row)
            return result if result.failure?
          end

          parsed_object = Importing::ProfileUpdate.new(
            email: row['email'],
            acomplished_courses: row['acomplished_courses'].to_s.split(',').map(&:strip),
            sections: row['sections'].to_s.split(',').map(&:strip),
            profession: row['profession']
          )

          if parsed_object.invalid?
            invalid_lines[index + 1] = parsed_object.errors.messages
          else
            parsed_data << parsed_object
          end
        end

        return failure_with_lines(invalid_lines) if invalid_lines.any?

        Success.new(parsed_data: parsed_data)
      end

      private

      def parsed_profile(row)
        Importing::ProfileUpdate.new(
          email: row['email'],
          acomplished_courses: row['acomplished_courses'],
          sections: row['sections'],
          profession: row['profession']
        )
      end

      def failure_with_lines(invalid_lines)
        errors = []

        invalid_lines.each do |key, value|
          errors << "Line #{key}: #{value.keys.join(', ')}"
        end

        Failure.new(:invalid, message: "Invalid fields: #{errors.join('; ')}")
      end

      def check_headers(row)
        missing_headers = REQUIRED_PROFILE_HEADERS - row.headers

        if missing_headers.any?
          return Failure.new(:invalid, message: "missing columns: #{missing_headers.join(', ')}")
        end

        extra_headers = row.headers - REQUIRED_PROFILE_HEADERS

        if extra_headers.any?
          return Failure.new(:invalid, message: "extra columns: #{extra_headers.join(', ')}")
        end

        Success.new
      end
    end
  end
end
