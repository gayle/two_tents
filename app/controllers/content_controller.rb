class ContentController < ApplicationController

  def index
    current = Year.current
    @year = current.year
    @doc = current.registration_doc
    @pdf = current.registration_pdf
  end

  def whats_new
    current = Year.current
    @year = current.year
    @theme = current.theme
  end
end
