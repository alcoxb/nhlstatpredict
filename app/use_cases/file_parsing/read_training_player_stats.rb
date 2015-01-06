class FileParsing::ReadTrainingPlayerStats < Mutations::Command

  required do
    integer :season
  end

  def execute
    file = File.open("config/"+inputs[:season].to_s+"stats", "r")

    players = []
    file.each_line do |line|
      tokens = line.split(/\s/)
      name = tokens[1,2].join(" ")

      player = TrainingPlayer.where(:name => name, :season => inputs[:season]).first

      if player.blank?
        player = TrainingPlayer.create!(:name => name, :season => inputs[:season])
      end

      teams = []
      check = true
      while check do
        check = false
        team = tokens[3+teams.size]
        if team.include?(",")
          check = true
          team = team.split(",").first
          teams << team
        else
          teams << team
        end
      end

      pos = tokens[3+teams.size]
      pos_i = (pos == "D") ? 0 : (pos == "C") ? 1 : 2

      params = {
          :team_a => teams.first,
          :team_b => teams.last,
          :position => pos_i,
          :games_played => tokens[4+teams.size],
          :goals => tokens[5+teams.size],
          :assists => tokens[6+teams.size],
          :points => tokens[7+teams.size],
          :plus_minus => tokens[8+teams.size],
          :penalty_minutes => tokens[9+teams.size],
          :pp_points => tokens[11+teams.size],
          :sh_points => tokens[13+teams.size],
          :shots => tokens[16+teams.size],
          :toi => tokens[18+teams.size].split(":").first.to_i * 60 + tokens[18+teams.size].split(":").last.to_i
      }

      player.update_attributes!(params)

      players << player
    end

    players
  end

end