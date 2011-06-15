class VersionsController < ApplicationController
  expose(:versions) { current_camp.versions.order('id DESC').limit(40)}
  expose(:version)

  def index
  end

  def show
    case version.item_type
      when 'Shelf'
        redirect_to shelf_path(version.item_id)
      when 'Book'
        redirect_to book_path(version.item_id)
      when 'Comment'
        comment = Comment.find version.item_id
        redirect_to comment.resource
      when 'Bookmark'
        bookmark = Bookmark.find version.item_id
        redirect_to book_path(bookmark.book)
      else
        redirect_to root_path, :notice => 'No encontrado'
    end
  end
end
