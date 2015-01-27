class CreateStatusLogs < ActiveRecord::Migration
  def change
    create_table :status_logs do |t|
      t.string :user
      t.string :action
      t.timestamps :null => true
    end
  end
end
