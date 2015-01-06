class AddSeasonToTrainingPlayer < ActiveRecord::Migration
  def change
    add_column :training_players, :season, :integer
  end
end
