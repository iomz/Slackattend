class CreateStatuses < ActiveRecord::Migration
  def up
    create_table :statuses do |t|
      t.string :name
      t.string :status
      t.timestamps :null => true
    end
  end

  def down
    drop_table :statuses
  end
end
