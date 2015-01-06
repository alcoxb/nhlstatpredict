class Run::TrainNetwork < Mutations::Command

  required do
    integer :train_season
    integer :check_season
    float :learning_rate
    float :k
    integer :hidden_count
    integer :epochs
  end

  def execute

    in_fields = [:age, :team_a_rank, :team_b_rank, :games_played, :position, :goals, :assists, :points,
                 :plus_minus, :penalty_minutes, :pp_points, :sh_points, :shots, :toi, :hits, :blocks,
                 :give_aways, :take_aways]


    #out_fields = [:goals, :assists, :points,:plus_minus, :penalty_minutes,
    #              :pp_points, :sh_points, :shots, :hits, :blocks]

    out_fields = [:goals, :assists, :points, :plus_minus, :penalty_minutes, :pp_points,
                  :sh_points, :shots, :hits, :blocks]

    training_players = TrainingPlayer.where(:season => inputs[:train_season]).all
    result_players = []

    training_players = training_players.sort_by {rand}
    training_players.each do |p|
      result = TrainingPlayer.where(:season => inputs[:check_season], :name => p.name).first
      if result.blank?
        training_players -= [p]
      else
        result_players << result
      end
    end

    test_input_players = training_players[0,(training_players.size/3)]
    test_result_players = result_players[0,test_input_players.size]

    training_players = training_players[test_input_players.size..-1]
    result_players = result_players[test_input_players.size..-1]

    maxs = {}
    mins = {}
    avgs = {}
    stdevs = {}

    in_fields.each do |f|
      maxs[f] = training_players.max_by{|p| p[f]}[f] * 1.5
      mins[f] = training_players.min_by{|p| p[f]}[f] / 1.5
      avgs[f] = training_players.collect{|p| p[f]}.sum.to_f / training_players.size
      stdevs[f] = Math.sqrt(training_players.collect{|p| (p[f] - avgs[f]) ** 2}.sum.to_f / training_players.size)
    end

    network = NeuralNetwork.create!()
    network.years = 100*inputs[:train_season] + inputs[:check_season] - 202000
    network.n_input = in_fields.size
    network.n_hidden = inputs[:hidden_count]
    network.n_output = out_fields.size
    network.learning_rate = inputs[:learning_rate]
    network.k = inputs[:k]
    network.maxs = maxs
    network.mins = mins
    network.avgs = avgs
    network.inputs = in_fields
    network.outputs = out_fields
    network.save

    network = Network::InitWeights.run!(:network_id => network.id)

    errors = []
    err = {}
    strikes = 0
    1.upto(inputs[:epochs]) do |i|
      network.outputs.each do |f|
        err[f] = 0
      end
      training_players.each do |tp|
        rp = result_players.select{|p| p.name == tp.name}.first
        inputs = in_fields.collect {|f| tp[f]}

        in_fields.each_with_index do |f,j|
          inputs[j] = ((inputs[j] - mins[f]).to_f / (maxs[f].to_f - mins[f].to_f))
        end
        actuals = []
        out_fields.each do |f|
          actuals << ((rp[f] - mins[f]).to_f / (maxs[f].to_f - mins[f].to_f))
        end

        output_hash = Network::CalculateOutput.run!(:training_player => tp, :neural_network => network)
        hiddens = output_hash[:hidden]
        outputs = output_hash[:output]

        network = Network::AdjustWeights.run!(:neural_network => network, :input => inputs, :output => outputs, :hidden => hiddens, :actual => actuals)
      end

      test_input_players.each do |tp|
        rp = test_result_players.select{|p| p.name == tp.name}.first
        inputs = in_fields.collect {|f| tp[f]}

        in_fields.each_with_index do |f,j|
          inputs[j] = ((inputs[j] - mins[f]).to_f / (maxs[f].to_f - mins[f].to_f))
        end
        actuals = []
        out_fields.each do |f|
          actuals << ((rp[f] - mins[f]).to_f / (maxs[f].to_f - mins[f].to_f))
        end

        output_hash = Network::CalculateOutput.run!(:training_player => tp, :neural_network => network)
        outputs = output_hash[:output]

        network.outputs.each do |f|
          err[f] += (((maxs[f].to_f - mins[f].to_f) * (actuals[network.outputs.index(f)]) + mins[f]) - ((maxs[f].to_f - mins[f].to_f) * (outputs[network.outputs.index(f)]) + mins[f])).abs
        end

        if i%10 == 0 and test_input_players.collect{|t| t.id}.index(tp.id) % 10 == 0
          network.outputs.each do |f|
            puts i.to_s + " Actual #{f.to_s}: " + ((maxs[f].to_f - mins[f].to_f) * (actuals[network.outputs.index(f)]) + mins[f]).to_s
            puts "Input #{f.to_s}: " + ((maxs[f].to_f - mins[f].to_f) * (inputs[network.inputs.index(f)]) + mins[f]).to_s
            puts "Predicted #{f.to_s}: " + ((maxs[f].to_f - mins[f].to_f) * (outputs[network.outputs.index(f)]) + mins[f]).to_s

          end
          puts ""
        end

      end


      if i%10 == 0
        e = 0
        network.outputs.each do |f|
          x = ((err[f]).to_f / test_input_players.size)/stdevs[f]
          e += x
          puts "err #{f.to_s}: " + (err[f].to_f / test_input_players.size).to_s + " (" + x.to_s[0,5] + ")"
        end
        errors << e/network.outputs.size
        puts "e: " + errors.last.to_s
        if i == 100 and errors.last >= 1
          break
        end
        if errors.size > 1 and errors.last > errors[-2]
          strikes += 1
          puts "STRIKE " + strikes.to_s
          if strikes >= 3
            break
          end
        elsif errors.last <= errors.min
          network.save
        end
      end

      result_players_b = []
      training_players = training_players.sort_by {rand}
      training_players.each do |p|
        result = result_players.select{|rp| rp.name == p.name}.first
        result_players_b << result
      end
      result_players = result_players_b

    end

    if errors.min <= 0.92
      puts "id: " + network.id.to_s + " e: " + errors.min.to_s
      Utility::GenerateScorings.run!(:season => (inputs[:check_season] + 1), :network_id => network.id)
    else
      puts "FAILED!"
    end

    errors
  end

end