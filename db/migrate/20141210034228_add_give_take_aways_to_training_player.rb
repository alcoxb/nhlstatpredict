class AddGiveTakeAwaysToTrainingPlayer < ActiveRecord::Migration
  def change
    add_column :training_players, :give_aways, :integer
    add_column :training_players, :take_aways, :integer
  end
end
