class CreateJobFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :job_favorites do |t|
      t.integer :job_id
      t.integer :user_id

      t.timestamps
    end
  end
end
