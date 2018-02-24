class CreateForbiddens < ActiveRecord::Migration[5.0]
  def change
    create_table :forbiddens do |t|
      t.string :user, null:false
      t.string :relation, null:false
      t.timestamps
    end
  end
end
