class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.integer :item_id
      t.string :state

      t.timestamps null: false
    end
  end
end
