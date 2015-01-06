class CreateTrainingPlayer < ActiveRecord::Migration
  def change
    create_table :training_players do |t|
      t.string :name
      t.string :team_a
      t.integer :team_a_rank
      t.string :team_b
      t.integer :team_b_rank
      t.integer :age
      t.integer :games_played
      t.integer :goals
      t.integer :assists
      t.integer :points
      t.integer :penalty_minutes
      t.integer :hits
      t.integer :blocks
      t.integer :pp_points
      t.integer :sh_points
      t.integer :shots
      t.timestamps
    end
  end
end
