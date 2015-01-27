class CreateSojournTimes < ActiveRecord::Migration
  def change
    create_table :sojourn_times do |t|
      t.string :user
      t.date :date
      t.time :from
      t.time :to
      t.integer :minute
    end
  end
end
