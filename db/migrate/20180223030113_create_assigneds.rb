class CreateAssigneds < ActiveRecord::Migration[5.0]
  def change
    create_table :assigneds do |t|
      t.string :grantor, null: false
      t.string :grantee, null: false
      t.string :relation, null: false
      t.boolean :can_grant
      t.timestamps
    end
  end
end
