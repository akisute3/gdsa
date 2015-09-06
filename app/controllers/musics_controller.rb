# coding: utf-8
class MusicsController < ApplicationController
  def index
    @hots = MstMusic.includes(mst_levels: [:mst_game, :mst_difficulty]).where(hot: true)
    @others = MstMusic.includes(mst_levels: [:mst_game, :mst_difficulty]).where(hot: false)

    respond_to do |format|
      format.html
      format.json do
        list = {}
        (@hots + @others).each do |music|
          games = Hash.new { |h,k| h[k] = {} }
          music.mst_levels.each do |l|
            games[l.mst_game.name][l.mst_difficulty.name] = l.level
          end

          list[music.name] = games
        end

        render json: list
      end
    end
  end
end
