class FileParsing::ReadAgesOfPlayers < Mutations::Command

  required do
    integer :season
  end

  def execute
    file = File.open("config/"+inputs[:season].to_s+"bios", "r")

    players = []
    file.each_line do |line|
      tokens = line.split(/\s/)
      name = tokens[1,2].join(" ")

      player = TrainingPlayer.where(:name => name, :season => inputs[:season]).first

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

      year = tokens[6+teams.size][1..-1]

      age = inputs[:season]-1 - (year.to_i + ((year.to_i < 60) ? 2000 : 1900))

      player.update_attributes!(:age => age)

      players << player
    end

    TrainingPlayer.where(:season => inputs[:season]).all.each do |tp|
      if tp.age.nil? or tp.age == 0
        tp.destroy
      end
    end

    players
  end

end