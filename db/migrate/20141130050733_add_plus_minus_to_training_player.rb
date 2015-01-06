class AddPlusMinusToTrainingPlayer < ActiveRecord::Migration
  def change
    add_column :training_players, :plus_minus, :integer
  end
end
