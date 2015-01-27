class CreateAttendanceCounts < ActiveRecord::Migration
  def change
    create_table :attendance_counts do |t|
      t.date :date
      t.time :time
      t.integer :count
    end
  end
end
