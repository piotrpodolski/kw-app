module Settlement
  module Admin
    class ContractorsController < ::Admin::BaseController
      include EitherMatcher
      append_view_path 'app/components'

      def index
        @contractors = Settlement::ContractorRecord.all
      end

      def new
        authorize! :create, Settlement::ContractorRecord

        @contractor = Settlement::ContractorRecord.new
      end

      def create
        authorize! :create, Settlement::ContractorRecord

        either(create_record) do |result|
          result.success do |a|
            if contractor_params[:back_url] == 'sponsorship_requests'
              redirect_to sponsorship_requests_path, notice: 'Dodano'
            elsif contractor_params[:back_url] == 'new_sponsorship_request'
              redirect_to new_sponsorship_request_path, notice: 'Dodano'
            else
              redirect_to admin_contracts_path, notice: 'Dodano'
            end
          end

          result.failure do |errors|
            @contractor = Settlement::ContractorRecord.new(contractor_params)
            flash[:error] = errors.values.join(", ")
            render :new
          end
        end
      end

      def show
        @contractor = Settlement::ContractorRecord.find(params[:id])
      end

      private

      def create_record
        Settlement::CreateContractor.new(
          Settlement::Repository.new,
          Settlement::ContractorForm
        ).call(raw_inputs: contractor_params)
      end

      def contractor_params
        params
          .require(:contractor)
          .permit(:name, :description, :nip, :back_url, :email, :www, :contact_name, :reason_type, :phone)
      end
    end
  end
end
