class RemoveForeignKey < ActiveRecord::Migration[6.0]
  def change
    remove_column :championships, :match_id
    add_column :championships, :name, :string
    add_column :championships, :start_date, :date
    add_column :championships, :end_date, :date
  end
end
