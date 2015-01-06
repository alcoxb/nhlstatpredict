class FileParsing::ReadTeamStats < Mutations::Command

  required do
    integer :season
  end

  def execute
    file = File.open("config/"+inputs[:season].to_s+"teamstats", "r")
    std_file = File.open("config/"+inputs[:season].to_s+"stats", "r")

    players = []
    players_left = TrainingPlayer.where(:season => inputs[:season])
    file.each_line do |line|
      tokens = line.split(/\s/)
      name = tokens[1,2].join(" ")

      player = TrainingPlayer.where(:name => name, :season => inputs[:season]).first

      players_left -= [player]
      if player.blank?
        next
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

      params = {

      }
      player.update_attributes!(params)

      players << player
    end

    players_left.each do |tp|
      tp.destroy
    end

    players
  end

end