class FixLearningRateName < ActiveRecord::Migration
  def change
    rename_column :neural_networks, :learing_rate, :learning_rate
  end
end
