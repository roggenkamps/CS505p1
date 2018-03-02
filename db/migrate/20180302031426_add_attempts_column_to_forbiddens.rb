class AddAttemptsColumnToForbiddens < ActiveRecord::Migration[5.0]
  def change
    add_column :forbiddens, :attempts, :integer
  end
end
