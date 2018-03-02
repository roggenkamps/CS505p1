class AddActiveColumnToForbiddens < ActiveRecord::Migration[5.0]
  def change
    add_column :forbiddens, :active, :boolean
  end
end
