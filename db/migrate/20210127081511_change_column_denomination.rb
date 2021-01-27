class ChangeColumnDenomination < ActiveRecord::Migration[6.0]
  def change
    rename_column :articles, :text, :body
  end
end
