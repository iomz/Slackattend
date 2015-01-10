class CreateStatuses < ActiveRecord::Migration
  def up
    create_table :statuses do |t|
      t.string :name
      t.string :status
      t.timestamp :updated_at
    end
  end

  def down
    drop_table :statuses
  end
end
