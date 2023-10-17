class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    comment = BookComment.new(book_comment_params)
    comment.user_id = current_user.id
    comment.book_id = @book.id
    comment.save
    @books=Book.find(params[:book_id])
   @book_comment = BookComment.new

  end

   def destroy
  @books=Book.find(params[:book_id])
  @book_comment=BookComment.find_by(id: params[:id], book_id: params[:book_id])
  @book_comment.destroy
  @book_comment = BookComment.new
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
