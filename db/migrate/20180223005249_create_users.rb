class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :usedid, null:false
      t.string :name, null:false
      t.string :role, null:false

      t.timestamps
    end
  end
end
