class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.text :content
      t.string :status
      t.integer :priority
      t.string :owner

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
