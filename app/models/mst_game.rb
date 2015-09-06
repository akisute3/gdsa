class MstGame < ActiveRecord::Base
  has_many :mst_levels

  def inst
    @inst ||= Inst.from_game(self.name)
  end
end
