class AddArchivedToAuctions < ActiveRecord::Migration[5.0]
  def change
    add_column :auctions, :archived, :boolean, default: false
  end
end
