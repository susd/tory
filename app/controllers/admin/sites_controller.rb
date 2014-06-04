class Admin::SitesController < AdminController
  before_action :load_site, except: [:index, :new, :create]
  def index
    @sites = Site.order(:code).includes(:servers)
  end
  
  def new
    @site = Site.new
  end
  
  def show
  end
  
  def edit
  end
  
  def create
    @site = Site.new(site_params)
    if @site.save
      redirect_to admin_sites_path, notice: 'Site created.'
    else
      render action: 'new'
    end
  end
  
  def update
    if @site.update(site_params)
      redirect_to admin_sites_path, notice: 'Site updated.'
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