class Run::TopNScores < Mutations::Command

  required do
    integer :season
    integer :n
  end

  def execute
    scores = Scoring.where(:season => inputs[:season]).all
    scores = scores.sort_by{|s| -1 * s.score}[0,inputs[:n]]

    scores.each_with_index do |s,i|
      puts (i+1).to_s + ". " + s[:name] + ": " + s[:score].to_s
    end

    nil
  end
end