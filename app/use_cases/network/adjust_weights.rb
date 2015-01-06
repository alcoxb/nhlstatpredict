class Network::AdjustWeights < Mutations::Command

  required do
    array :input
    array :output
    array :hidden
    array :actual
    model :neural_network
  end

  def execute

    network = inputs[:neural_network]

    e = Network::CalculateErrors.run!(:neural_network => network, :output => inputs[:output], :hidden => inputs[:hidden], :actual => inputs[:actual])

    inputs[:hidden].each_with_index do |hidden, h|
      inputs[:output].each_with_index do |output, o|
        network.weights_ho[h][o] += network.learning_rate*e[:output][o]*hidden
      end
      inputs[:input].each_with_index do |input, i|
        network.weights_ih[i][h] += network.learning_rate*e[:hidden][h]*input
      end
    end

    network
  end

end