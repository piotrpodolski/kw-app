class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :payed_at
    create_table :payments do |t|
      t.integer :user_id, null: false
      t.integer :year, null: false
    end
  end
end
