class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.string :user
      t.string :relation
      t.string :operation
      t.string :object
      t.string :parameters

      t.timestamps
    end
    add_index :logs, :user
    add_index :logs, :relation
  end
end
