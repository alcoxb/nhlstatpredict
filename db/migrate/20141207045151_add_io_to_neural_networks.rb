class AddIoToNeuralNetworks < ActiveRecord::Migration
  def change
    add_column :neural_networks, :inputs, :text
    add_column :neural_networks, :outputs, :text
  end
end
