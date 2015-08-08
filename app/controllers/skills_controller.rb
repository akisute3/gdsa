# coding: utf-8
class SkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_skill, only: [:edit, :update, :destroy]

  def new
    @skill = Skill.new
    @skill.mst_level = MstLevel.new
  end

  def create
    @skill = Skill.new(skill_params.merge(user_id: current_user.id))
    @skill.mst_level = MstLevel.find_by(level_params)

    # 更新
    #  - 同じ Game, Music が既に登録されていたら上書き
    #  - 選択した難易度が存在しなければ @skill.check_and_save は nil を返す
    respond_to do |format|
      if @skill.check_and_save
        format.html {redirect_to ({action: 'new'}), notice: '登録しました。'}
      else
        flash.now[:alert] =
          '登録できませんでした。選択した難易度が存在しない可能性があります。'
        @skill.mst_level = MstLevel.new(level_params)
        format.html {render :new}
      end
    end
  end

  def edit
  end

  def update
    # 更新
    #  - 入力は同じ Game, Music に対してのみ許可 (Guitar, Base は切り替え可能)
    #  - 選択した難易度が存在しなければ @skill.check_and_update は nil を返す
    respond_to do |format|
      if @skill.check_and_update(skill_params, level_params)
        flash.now[:alert] = '登録しました。'
        # TODO: action を返すメソッドを作成
        action = (@skill.mst_level.mst_game.name == 'Drum') ? :drum : :guitar
        format.html {redirect_to ({controller: 'users', id: current_user.id, action: action}), notice: '更新しました。'}
      else
        flash.now[:alert] =
          '登録できませんでした。選択した難易度が存在しない可能性があります。'
        format.html {render :edit}
      end
    end
  end

  def destroy
    @skill.destroy

    respond_to do |format|
      action = (@skill.mst_level.mst_game.name == 'Drum') ? :drum : :guitar
      format.html {redirect_to ({controller: 'users', id: current_user.id, action: action}), notice: '削除しました。'}
    end
  end


  private
    def set_skill
      @skill = Skill.find(params[:id])
    end

    def skill_params
      params.require(:skill).permit(
        :achievement, :full_combo, :comment, :goal)
    end

    def level_params
      params.require(:mst_level).permit(
        :mst_game_id, :mst_music_id, :mst_difficulty_id)
    end
end
