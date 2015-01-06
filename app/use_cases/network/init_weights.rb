class Network::InitWeights < Mutations::Command

  required do
    integer :network_id
  end

  def execute
    network = NeuralNetwork.find inputs[:network_id]

    network.weights_ih = []
    0.upto(network.n_input).each do |i|
      network.weights_ih[i] = []
      0.upto(network.n_hidden).each do |h|
        dec = rand(10).to_s + rand(10).to_s
        pm = (rand(2) == 1) ? "-" : ""
        network.weights_ih[i][h] = (pm + "0." + dec).to_f
      end
    end

    network.weights_ho = []
    0.upto(network.n_hidden).each do |h|
      network.weights_ho[h] = []
      0.upto(network.n_output).each do |o|
        dec = rand(10).to_s + rand(10).to_s
        pm = (rand(2) == 1) ? "-" : ""
        network.weights_ho[h][o] = (pm + "0." + dec).to_f
      end
    end
    network.save

    network
  end

end