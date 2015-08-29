class MstGame < ActiveRecord::Base
  has_many :mst_levels

  DRUMS = ['Drum']
  GUITARS = ['Guitar', 'Base']

  def inst
    @inst ||= Inst.from_game(self.name)
  end
end
