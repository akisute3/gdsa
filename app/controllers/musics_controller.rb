class MusicsController < ApplicationController
  def index
    @hots = MstMusic.includes(:mst_levels).where(hot: true)
    @others = MstMusic.includes(:mst_levels).where(hot: false)
  end
end
