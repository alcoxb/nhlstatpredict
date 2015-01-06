class Network::CalculateErrors < Mutations::Command

  required do
    array :output
    array :hidden
    array :actual
    model :neural_network
  end

  def execute

    network = inputs[:neural_network]

    e_o = []
    e_h = []
    inputs[:actual].each_with_index do |a, i|
      o = inputs[:output][i] || 0
      e_o[i] = network.k * (o) * (1-o) * (a-o)
      #puts "e: " + e_o[i].to_s + " o: " + o.to_s + " a: " + a.to_s
    end
    inputs[:hidden].each_with_index do |h,i|
      t = 0

      e_o.each_with_index do |o,j|
        t += o * network.weights_ho[i][j]
      end
      e_h[i] = network.k * (h) * (1-h) * t
    end

    {:hidden => e_h, :output => e_o}
  end

end