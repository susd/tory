class SitesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_site, except: [:index, :new, :create]
  def index
    @sites = Site.all
  end
  
  def show
    @devices = @site.devices.order(created_at: :desc).limit(5)
  end
  
  def new
    @site = Site.new
  end
  
  def edit
  end
  
  def create
    @site = Site.new(site_params)
    if @site.save
      redirect_to sites_path, notice: 'Site created.'
    else
      render action: 'new'
    end
  end
  
  def update
    if @site.update(site_params)
      redirect_to sites_path, notice: 'Site updated.'
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