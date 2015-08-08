class UsersController < ApplicationController

  before_action :set_user, only: [:show, :guitar, :drum]

  def index
    @users = User.all
  end

  def show
    @guitar_skills = Skill.point_list(@user.id, :guitar, :current)
    @drum_skills = Skill.point_list(@user.id, :drum, :current)
    @guitar_goals = Skill.point_list(@user.id, :guitar, :goal)
    @drum_goals = Skill.point_list(@user.id, :drum, :goal)
  end

  def guitar
    @title = 'GuitarFreaks'
    @skills = Skill.point_list(@user.id, :guitar, :current)
    @goals = Skill.point_list(@user.id, :guitar, :goal)
    @hots = Skill.find_target(@user.id, :guitar, :hot)
    @others = Skill.find_target(@user.id, :guitar, :other)

    render 'skill'
  end

  def drum
    @title = 'DrumMania'
    @skills = Skill.point_list(@user.id, :drum, :current)
    @goals = Skill.point_list(@user.id, :drum, :goal)
    @hots = Skill.find_target(@user.id, :drum, :hot)
    @others = Skill.find_target(@user.id, :drum, :other)

    render 'skill'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

end
