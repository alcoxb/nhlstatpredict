class AddPositionToTrainingPlayer < ActiveRecord::Migration
  def change
    add_column :training_players, :position, :integer
  end
end
