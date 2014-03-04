class SitesController < ApplicationController
  before_action :load_site, except: :index
  def index
    @sites = Site.all
  end
  
  def edit
  end
  
  def update
    if @site.update(site_params)
      redirect_to sites_path, notice: 'Site was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  private
  
  def load_site
    @site = Site.find(params[:id])
  end
  
  def site_params
    params.require(:site).permit(:name, :abbr, :pxe, :storage, :code)
  end
end