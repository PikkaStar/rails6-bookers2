class UsersController < ApplicationController
  before_action :logined_user
  before_action :ensure_correct_user, only: [:edit,:update]
   before_action :authenticate_user!, only: [:show]

  def show
   @user = User.find(params[:id])
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end
    @book = Book.new
    @books = @user.books
end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update

    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else

      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

   def logined_user
    unless user_signed_in?
      redirect_to new_user_session_path
  end
end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
