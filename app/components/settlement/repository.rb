module Settlement
  class Repository
    def create_contract(form_outputs:, creator_id:)
      Settlement::ContractRecord
        .create!(form_outputs.to_h.merge(creator_id: creator_id))
    end
  end
end
