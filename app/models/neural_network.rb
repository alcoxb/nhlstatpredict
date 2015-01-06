class NeuralNetwork < ActiveRecord::Base
  serialize :weights_ih
  serialize :weights_ho
  serialize :maxs
  serialize :mins
  serialize :inputs
  serialize :outputs
  serialize :avgs
end