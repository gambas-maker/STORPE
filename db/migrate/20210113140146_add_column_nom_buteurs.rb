class AddColumnNomButeurs < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :nom_buteur_1, :string
    add_column :matches, :nom_buteur_2, :string
    add_column :matches, :nom_buteur_3, :string
    add_column :matches, :nom_buteur_4, :string
  end
end
