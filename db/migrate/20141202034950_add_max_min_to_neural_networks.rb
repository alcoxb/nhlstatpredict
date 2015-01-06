class AddMaxMinToNeuralNetworks < ActiveRecord::Migration
  def change
    add_column :neural_networks, :maxs, :text
    add_column :neural_networks, :mins, :text
  end
end
