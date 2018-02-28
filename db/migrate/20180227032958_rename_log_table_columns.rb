class RenameLogTableColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :logs, :relation, :subject
  end
end
