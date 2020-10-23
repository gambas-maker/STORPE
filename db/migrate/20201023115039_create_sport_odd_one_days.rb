class CreateSportOddOneDays < ActiveRecord::Migration[6.0]
  def change
    create_table :sport_odd_one_days do |t|

      t.timestamps
    end
  end
end
