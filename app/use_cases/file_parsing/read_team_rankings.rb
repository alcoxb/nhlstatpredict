class FileParsing::ReadTeamRankings < Mutations::Command

  required do
    integer :season
  end

  def execute
    file_old = File.open("config/"+(inputs[:season]-1).to_s+"standings", "r")
    file_new = File.open("config/"+(inputs[:season]).to_s+"standings", "r")

    players = []
    a_ranks = []
    b_ranks = []
    file_old.each_line do |line|
      tokens = line.split(" ")
      if tokens[1].include? "ANAH"
        a_ranks << "ANA"
      elsif tokens[1].include? "ARIZ"
        a_ranks << "ARI"
      elsif tokens[1].include? "BOST"
        a_ranks << "BOS"
      elsif tokens[1].include? "BUFF"
        a_ranks << "BUF"
      elsif tokens[1].include? "CALG"
        a_ranks << "CGY"
      elsif tokens[1].include? "CARO"
        a_ranks << "CAR"
      elsif tokens[1].include? "CHICA"
        a_ranks << "CHI"
      elsif tokens[1].include? "COLO"
        a_ranks << "COL"
      elsif tokens[1].include? "COLU"
        a_ranks << "CBJ"
      elsif tokens[1].include? "DALL"
        a_ranks << "DAL"
      elsif tokens[1].include? "DETR"
        a_ranks << "DET"
      elsif tokens[1].include? "EDMO"
        a_ranks << "EDM"
      elsif tokens[1].include? "FLOR"
        a_ranks << "FLA"
      elsif tokens[2].include? "ANGEL"
        a_ranks << "LAK"
      elsif tokens[1].include? "MINN"
        a_ranks << "MIN"
      elsif tokens[1].include? "MONT"
        a_ranks << "MTL"
      elsif tokens[1].include? "NASH"
        a_ranks << "NSH"
      elsif tokens[2].include? "ISLAN"
        a_ranks << "NYI"
      elsif tokens[2].include? "RANG"
        a_ranks << "NYR"
      elsif tokens[2].include? "JERSE"
        a_ranks << "NJD"
      elsif tokens[1].include? "OTTA"
        a_ranks << "OTT"
      elsif tokens[1].include? "PHILA"
        a_ranks << "PHI"
      elsif tokens[1].include? "PHOE"
        a_ranks << "PHX"
      elsif tokens[1].include? "PITT"
        a_ranks << "PIT"
      elsif tokens[2].include? "JOSE"
        a_ranks << "SJS"
      elsif tokens[2].include? "LOUI"
        a_ranks << "STL"
      elsif tokens[1].include? "TAMP"
        a_ranks << "TBL"
      elsif tokens[1].include? "TORO"
        a_ranks << "TOR"
      elsif tokens[1].include? "VANC"
        a_ranks << "VAN"
      elsif tokens[1].include? "WASH"
        a_ranks << "WSH"
      elsif tokens[1].include? "WINN"
        a_ranks << "WPG"
      end
    end

    file_new.each_line do |line|
      tokens = line.split(" ")
      if tokens[1].include? "ANAH"
        b_ranks << "ANA"
      elsif tokens[1].include? "ARIZ"
        b_ranks << "ARI"
      elsif tokens[1].include? "BOST"
        b_ranks << "BOS"
      elsif tokens[1].include? "BUFF"
        b_ranks << "BUF"
      elsif tokens[1].include? "CALG"
        b_ranks << "CGY"
      elsif tokens[1].include? "CARO"
        b_ranks << "CAR"
      elsif tokens[1].include? "CHICA"
        b_ranks << "CHI"
      elsif tokens[1].include? "COLO"
        b_ranks << "COL"
      elsif tokens[1].include? "COLU"
        b_ranks << "CBJ"
      elsif tokens[1].include? "DALL"
        b_ranks << "DAL"
      elsif tokens[1].include? "DETR"
        b_ranks << "DET"
      elsif tokens[1].include? "EDMO"
        b_ranks << "EDM"
      elsif tokens[1].include? "FLOR"
        b_ranks << "FLA"
      elsif tokens[2].include? "ANGEL"
        b_ranks << "LAK"
      elsif tokens[1].include? "MINN"
        b_ranks << "MIN"
      elsif tokens[1].include? "MONT"
        b_ranks << "MTL"
      elsif tokens[1].include? "NASH"
        b_ranks << "NSH"
      elsif tokens[2].include? "ISLAN"
        b_ranks << "NYI"
      elsif tokens[2].include? "RANG"
        b_ranks << "NYR"
      elsif tokens[2].include? "JERSE"
        b_ranks << "NJD"
      elsif tokens[1].include? "OTTA"
        b_ranks << "OTT"
      elsif tokens[1].include? "PHILA"
        b_ranks << "PHI"
      elsif tokens[1].include? "PHOE"
        b_ranks << "PHX"
      elsif tokens[1].include? "PITT"
        b_ranks << "PIT"
      elsif tokens[2].include? "JOSE"
        b_ranks << "SJS"
      elsif tokens[2].include? "LOUI"
        b_ranks << "STL"
      elsif tokens[1].include? "TAMP"
        b_ranks << "TBL"
      elsif tokens[1].include? "TORO"
        b_ranks << "TOR"
      elsif tokens[1].include? "VANC"
        b_ranks << "VAN"
      elsif tokens[1].include? "WASH"
        b_ranks << "WSH"
      elsif tokens[1].include? "WINN"
        b_ranks << "WPG"
      end
    end

    TrainingPlayer.where(:season => inputs[:season]).all.each do |tp|
      tp.team_a_rank = a_ranks.index(tp.team_a)
      tp.team_b_rank = b_ranks.index(tp.team_b)
      tp.save
      players << tp
    end

    players
  end

end