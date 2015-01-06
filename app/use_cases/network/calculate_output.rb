class Network::CalculateOutput < Mutations::Command

  required do
    model :training_player
    model :neural_network
  end

  def execute
    player = inputs[:training_player]
    network = inputs[:neural_network]

    in_fields = network.inputs


    #out_fields = [:goals, :assists, :points,:plus_minus, :penalty_minutes,
    #              :pp_points, :sh_points, :shots, :hits, :blocks]

    out_fields = network.outputs

    inputs = []
    in_fields.each do |f|
      inputs << ((player[f] - network.mins[f]).to_f / (network.maxs[f].to_f - network.mins[f].to_f))
    end

    h = []
    o = []

    0.upto(network.n_hidden - 1) do |i|
      h[i] = 0
      inputs.each_with_index do |val, j|
        h[i] += network.weights_ih[j][i] * (val || 0)
      end
      h[i] = Utility::Sigmoid.run!(:x => h[i], :k => network.k)
    end

    0.upto(network.n_output - 1) do |i|
      o[i] = 0
      h.each_with_index do |val, j|
        o[i] += network.weights_ho[j][i] * (val || 0)
      end
      o[i] = Utility::Sigmoid.run!(:x => o[i], :k => network.k)
    end

    ret = {:hidden => h, :output => o}

    out_hash = {}
    o.each_with_index do |val, i|
      out_hash[out_fields[i]] = val
    end

    ret
  end

end