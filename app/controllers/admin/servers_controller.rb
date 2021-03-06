class Admin::ServersController < AdminController
  before_action :set_site
  before_action :set_server, only: [:show, :edit, :update, :destroy]

  # GET /servers
  # GET /servers.json
  def index
    @servers = @site.servers
  end

  # GET /servers/1
  # GET /servers/1.json
  def show
  end

  # GET /servers/new
  def new
    @server = @site.servers.new
  end

  # GET /servers/1/edit
  def edit
  end

  # POST /servers
  # POST /servers.json
  def create
    @server = @site.servers.new(server_params.merge({used_at: (Time.now - 1.day)}))

    respond_to do |format|
      if @server.save
        format.html { redirect_to [:admin, @site], notice: 'Server was successfully created.' }
        format.json { render action: 'show', status: :created, location: [:admin, @site] }
      else
        format.html { render action: 'new' }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /servers/1
  # PATCH/PUT /servers/1.json
  def update
    respond_to do |format|
      if @server.update(server_params)
        format.html { redirect_to [:admin, @site], notice: 'Server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1
  # DELETE /servers/1.json
  def destroy
    @server.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @site] }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:site_id])
    end
    
    def set_server
      @server = @site.servers.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def server_params
      params.require(:server).permit(:ip_addr, :role)
    end
end
