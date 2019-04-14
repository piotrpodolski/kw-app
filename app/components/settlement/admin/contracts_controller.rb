module Settlement
  module Admin
    class ContractsController < ::Admin::BaseController
      include EitherMatcher
      append_view_path 'app/components'

      def index
        authorize! :read, Settlement::ContractRecord

        @contracts = Settlement::ContractRecord.includes([:acceptor, :creator]).where.not(state: :closed).accessible_by(current_ability).order(created_at: :desc)
      end

      def new
        authorize! :create, Settlement::ContractRecord

        @contract = Settlement::ContractRecord.new
      end

      def create
        authorize! :create, Settlement::ContractRecord

        either(create_record) do |result|
          result.success { |contract| redirect_to admin_contracts_path }

          result.failure do |errors|
            @contract = Settlement::ContractRecord.new(contract_params)
            flash[:error] = errors.values.join(", ")
            render :new
          end
        end
      end

      def show
        @contract = Settlement::ContractRecord.find(params[:id])

        authorize! :read, @contract
      end

      def edit
        @contract = Settlement::ContractRecord.find(params[:id])
        authorize! :read, @contract
      end

      def update
        @contract = Settlement::ContractRecord.find(params[:id])
        authorize! :update, @contract

        either(update_record) do |result|
          result.success do |contract|
            redirect_to edit_admin_contract_path(contract.id), notice: 'Zaktualizowano'
          end

          result.failure do |errors|
            render :edit
          end
        end
      end

      def accept
        authorize! :accept, Settlement::ContractRecord

        contract = Settlement::ContractRecord.find(params[:id])
        contract.accept!
        contract.update(acceptor_id: current_user.id)

        redirect_back(
          fallback_location: admin_contracts_path,
          notice: 'Zaakceptowano'
        )
      end

      def prepayment
        authorize! :prepayment, Settlement::ContractRecord

        contract = Settlement::ContractRecord.find(params[:id])
        contract.prepayment!

        redirect_back(
          fallback_location: admin_contracts_path,
          notice: 'Rozliczono!'
        )
      end

      private

      def create_record
        Settlement::CreateContract.new(
          Settlement::Repository.new,
          Settlement::ContractForm.new
        ).call(raw_inputs: contract_params, creator_id: current_user.id)
      end

      def update_record
        Settlement::UpdateContract.new(
          Settlement::Repository.new,
          Settlement::ContractForm.new
        ).call(id: params[:id], raw_inputs: contract_params)
      end

      def contract_params
        params
          .require(:contract)
          .permit(
            :title, :description, :cost, :state, attachments: [], users_names: []
          )
      end
    end
  end
end
