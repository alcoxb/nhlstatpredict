class Run::TopN < Mutations::Command

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

    stats = players.collect do |p|
      outputs = Network::CalculateOutput.run!(:training_player => p, :neural_network => network)[:output]
      g = ((network.maxs[:goals].to_f - network.mins[:goals].to_f) * (outputs[0]) + network.mins[:goals]).round
      a = ((network.maxs[:assists].to_f - network.mins[:assists].to_f) * (outputs[1]) + network.mins[:assists]).round
      points = g+a
      puts g.to_s + " " + a.to_s + " " + points.to_s if p.name == "Victor Hedman"
      {:name => p.name, :goals => g, :assists => a, :points => points}
    end

    stats = stats.sort_by {|s| -1* s[:points]}

    stats[0,inputs[:n]].each_with_index do |s,i|
      puts (i+1).to_s + ". " + s[:name] + ": " + s[:goals].to_s + " Goals, " + s[:assists].to_s + " Assists, " + s[:points].to_s + " Points"
    end

    nil
  end
end