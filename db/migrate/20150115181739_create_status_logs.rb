class CreateStatusLogs < ActiveRecord::Migration
  def change
    create_table :status_logs do |t|
      t.string :name
      t.string :action
      t.timestamps :null => true
    end
  end
end
