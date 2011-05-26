module BooksHelper

  def render_description(book)
    text = auto_link(book.description)
    text = text.gsub(/(#\w+)/, '<a>\0</a>')
    text = RDiscount.new(text, :smart).to_html.html_safe
    text = text.sub(/<em>[^<]*<\/em>/, '<a href="' + url_for(book) + '">\0</a>') unless book.title.present?
    text
  end

  def render_book(book, ctx = :book)
    render :partial => 'books/book', :locals => {:book => book, :ctx => ctx}
  end

  def render_media(book)
    book.url.present? ? link_to(image_tag(book.media), book.url) : image_tag(book.media)
  end
end
