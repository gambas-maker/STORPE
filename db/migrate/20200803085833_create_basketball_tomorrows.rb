class CreateBasketballTomorrows < ActiveRecord::Migration[6.0]
  def change
    create_table :basketball_tomorrows do |t|

      t.timestamps
    end
  end
end
