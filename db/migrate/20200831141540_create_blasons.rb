class CreateBlasons < ActiveRecord::Migration[6.0]
  def change
    create_table :blasons do |t|
      add_column :name, :string
      add_column :url, :string

      t.timestamps
    end
  end
end
