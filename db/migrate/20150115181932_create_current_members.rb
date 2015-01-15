class CreateCurrentMembers < ActiveRecord::Migration
  def change
    create_table :current_members do |t|
      t.string :name
      t.string :avatar_image_url
      t.timestamps :null => true
    end
  end
end
