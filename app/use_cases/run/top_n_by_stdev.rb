class Run::TopNByStdev < Mutations::Command

  required do
    integer :season
    integer :n
  end

  optional do
    integer :network_id
  end

  def execute
    network = (inputs[:network_id].blank?) ? NeuralNetwork.last : NeuralNetwork.find(inputs[:network_id])

    players = TrainingPlayer.where(:season => inputs[:season] - 1).all

    data = players.collect do |p|
      stats = {:name => p.name,:sum => 0}
      outputs = Network::CalculateOutput.run!(:training_player => p, :neural_network => network)[:output]
      network.outputs.each do |f|
        stats[f] = ((network.maxs[f].to_f - network.mins[f].to_f) * (outputs[network.outputs.index(f)]) + network.mins[f])
      end

      stats
    end

    avg = {}
    stdev = {}
    network.outputs.each do |f|
      avg[f] = data.collect{|p| p[f]}.sum.to_f / data.size
      stdev[f] = Math.sqrt(data.collect{|p| (p[f] - avg[f]) ** 2}.sum.to_f / data.size)
    end

    data.each do |d|
      network.outputs.each do |f|
        d[f] = (d[f].to_f - avg[f]) / stdev[f]
      end
      d[:sum] = network.outputs.collect{|f| d[f]}.sum
    end

    data = data.sort_by {|s| -1* s[:sum]}

    names = []
    data[0,inputs[:n]].each_with_index do |s,i|
      names << s[:name]
      puts (i+1).to_s + ". " + s[:name] + ": " + s[:sum].to_s
    end

    names
  end
end