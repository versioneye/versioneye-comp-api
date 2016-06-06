class IndexController < ApplicationController

  def index
  end

  def api_docs
    render :layout => 'swagger'
  end

end
