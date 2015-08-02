class UsersController < ApplicationController

  before_action :set_user, only: [:show]

  def index
    @users = User.all
  end

  def show
  end

  def drum
    @title = 'DrumMania'
    @skill = []
    @goal = []
    @hots = []
    @others = []

    render 'skill'
  end

  def guitar
    @title = 'GuitarFreaks'
    @skill = []
    @goal = []
    @hots = []
    @others = []

    render 'skill'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

end
