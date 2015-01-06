class Utility::GenerateScorings < Mutations::Command

  required do
    integer :season
  end

  optional do
    integer :network_id
  end

  def execute
    network = (inputs[:network_id].blank?) ? NeuralNetwork.last : NeuralNetwork.find(inputs[:network_id])

    names = Run::TopNByStdev.run!(:season => inputs[:season], :n => 25, :network_id => network.id)

    names.each_with_index do |p, i|
      if i >= 20
        score = 10 + (26 - i)
      elsif i >= 11
        score = 4 + 2 * (26 - i)
      else
        score = 34 + 3.upto(13-i).sum
      end
      scoring = Scoring.where(:season => inputs[:season], :name => p).first
      if scoring.blank?
        scoring = Scoring.create!(:name => p, :season => inputs[:season])
      end

      scoring.score = scoring.score + score
      scoring.reached_count = scoring.reached_count + 1
      scoring.save!
    end

    nil
  end
end