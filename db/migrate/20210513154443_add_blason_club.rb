class AddBlasonClub < ActiveRecord::Migration[6.0]
  def change
    add_column :blasons, :club, :integer
  end
end
