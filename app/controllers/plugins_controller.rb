class PluginsController < ApplicationController
  def index
     @services = Service.order(:name)
  end
end
