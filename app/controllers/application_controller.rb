class ApplicationController < ActionController::Base
  def hello
    render html: "привіт всім! і букві ї також ¡"
  end
end
