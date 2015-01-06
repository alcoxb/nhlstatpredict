class AddAvgsToNeuralNetwork < ActiveRecord::Migration
  def change
    add_column :neural_networks, :avgs, :text
  end
end
