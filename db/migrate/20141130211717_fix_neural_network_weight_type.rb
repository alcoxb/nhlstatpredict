class FixNeuralNetworkWeightType < ActiveRecord::Migration
  def change
    change_column :neural_networks, :weights_ih, :text
    change_column :neural_networks, :weights_ho, :text
  end
end
