module Importing
  class FromCsv
    class << self
      def import(file:, type:)
        result = case type.to_sym
                 when :mountain_route
                   Importing::CsvMountainRouteParser.parse(file: file)
                 when :user
                   Importing::CsvUserParser.parse(file: file)
                 when :profile
                   Importing::CsvProfileParser.parse(file: file)
                 when :membership_fee
                   Importing::CsvMembershipFeeParser.parse(file: file)
                 else
                   fail 'wrong type'
                 end
        result.invalid { |message:| return Failure.new(:invalid, message: message) }
        result.success do |parsed_data:|
          case type.to_sym
          when :mountain_route
            return Importing::Store.store_mountain_type(parsed_data)
          when :user
            return Importing::Store.store_user(parsed_data)
          when :profile
            return Importing::Store.store_profile(parsed_data)
          when :membership_fee
            return Importing::Store.store_membership_fee(parsed_data)
          else
            fail 'wrong type'
          end
        end
      end
    end
  end
end
