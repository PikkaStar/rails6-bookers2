class BookCommentsController < ApplicationController
  
  def create
    book = Book.find(params[:book_id])
    comment = BookComment.new(book_comment_params)
    comment.user_id = current_user.id
    comment.book_id = book.id
    comment.save
    redirect_back(fallback_location: root_path)
  end
  
end
