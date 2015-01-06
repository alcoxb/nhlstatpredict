class AddToiToTrainingPlayer < ActiveRecord::Migration
  def change
    add_column :training_players, :toi, :integer, :default => 0
  end
end
