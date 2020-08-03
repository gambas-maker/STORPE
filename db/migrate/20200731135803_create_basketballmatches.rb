class CreateBasketballmatches < ActiveRecord::Migration[6.0]
  def change
    create_table :basketballmatches do |t|

      t.timestamps
    end
  end
end
