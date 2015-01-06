class CreateScoring < ActiveRecord::Migration
  def change
    create_table :scorings do |t|
      t.string :name, :null => false
      t.integer :season, :null => false
      t.integer :score, :default => 0
      t.integer :reached_count, :default => 0
    end
  end
end
