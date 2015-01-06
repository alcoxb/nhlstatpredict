class FileParsing::CollectData < Mutations::Command

  required do
    integer :season
  end

  def execute
    FileParsing::ReadTrainingPlayerStats.run!(:season => inputs[:season])
    FileParsing::ReadAgesOfPlayers.run!(:season => inputs[:season])
    FileParsing::ReadRealTimeStats.run!(:season => inputs[:season])
    FileParsing::ReadTeamRankings.run!(:season => inputs[:season])
  end
end