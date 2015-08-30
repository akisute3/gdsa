# coding: utf-8
class SkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_skill, only: [:edit, :update, :destroy]

  def new
    @skill = Skill.new
    @skill.mst_level = MstLevel.new
  end

  def create
    if level = MstLevel.find_by(level_params)
      same_group_ids = level.extract_same_group_ids
      level_id = level.id
    else
      # 選択した難易度が存在しないときは、@skill を新規作成した後、
      # update で存在しない level_id を引数にすることでバリデーションエラーさせる
      # (エラーメッセージをバリデーションで一元管理するため)
      same_group_ids = []
      level_id = -1
    end
    @skill = Skill.find_or_initialize_by(user_id: current_user.id, mst_level_id: same_group_ids)

    respond_to do |format|
      exec = (@skill.new_record?) ? '登録' : '更新'
      if @skill.update(skill_params.merge(mst_level_id: level_id))
        format.html {redirect_to ({action: 'new'}),
                                 notice: "#{level.mst_game.name} の「#{level.mst_music.name}」を#{exec}しました。"}
      else
        flash.now[:alert] = '登録に失敗しました。エラー内容を確認してください。'
        @skill.mst_level = MstLevel.new(level_params)
        format.html {render :new}
      end
    end
  end

  def edit
  end

  def update
    # update 失敗時のために、前の mst_level_id を保存しておく
    pre_level_id = @skill.mst_level.id

    # create と同様
    level_id = (level = MstLevel.find_by(level_params)) ? level.id : -1

    respond_to do |format|
      if @skill.update(skill_params.merge(mst_level_id: level_id))
        # flash.now[:alert] = '登録しました。'
        # TODO: action を返すメソッドを作成
        action = (@skill.mst_level.mst_game.name == 'Drum') ? :drum : :guitar
        format.html {redirect_to ({controller: 'users', id: current_user.id, action: action}), notice: '更新しました。'}
      else
        @skill.mst_level_id = pre_level_id
        flash.now[:alert] = '登録に失敗しました。エラー内容を確認してください。'
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
