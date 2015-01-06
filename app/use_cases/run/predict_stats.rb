class Run::PredictStats < Mutations::Command

  required do
    string :name
    integer :season
  end

  def execute
    network = NeuralNetwork.last

    in_fields = network.outputs

    player = TrainingPlayer.where(:name => inputs[:name], :season => inputs[:season] - 1).first

    outputs = Network::CalculateOutput.run!(:training_player => player, :neural_network => network)[:output]

    outputs.each_with_index do |o,i|
      puts in_fields[i].to_s + ": " + ((network.maxs[in_fields[i]].to_f - network.mins[in_fields[i]].to_f) * (outputs[i]) + network.mins[in_fields[i]]).round.to_s
    end

    nil
  end
end