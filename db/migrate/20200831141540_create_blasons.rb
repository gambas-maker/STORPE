class CreateBlasons < ActiveRecord::Migration[6.0]
  def change
    create_table :blasons do |t|

      t.timestamps
    end
  end
end
