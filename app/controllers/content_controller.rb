class ContentController < ApplicationController

  def index
    current = Year.current
    @year = current.year
    @doc = current.registration_doc
    @pdf = current.registration_pdf
  end
end
