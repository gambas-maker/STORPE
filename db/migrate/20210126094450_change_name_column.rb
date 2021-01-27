class ChangeNameColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :articles, :url, :photo
  end
end
