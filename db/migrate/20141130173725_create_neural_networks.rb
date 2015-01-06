class CreateNeuralNetworks < ActiveRecord::Migration
  def change
    create_table :neural_networks do |t|
      t.integer :years
      t.integer :n_input
      t.integer :n_hidden
      t.integer :n_output
      t.string :weights_ih
      t.string :weights_ho
      t.float :learing_rate
      t.float :k
      t.timestamps
    end
  end
end
