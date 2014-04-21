class DevicesController < ApplicationController
  before_action :set_device, except: [:index, :new, :create]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.order(created_at: :desc)
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    @tasks = @device.tasks.order(created_at: :desc)
    @image_map = Image.all.pluck(:name, :id)
    @site_map = Site.all.pluck(:name, :id)
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)
    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render action: 'show', status: :created, location: @device }
        format.xml { render text: "Success" }
      else
        format.html { render action: 'new' }
        format.json { render json: @device.errors, status: :unprocessable_entity }
        format.xml { render xml: @devise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url }
      format.json { head :no_content }
    end
  end
  
  def parse
    @device.extract_from_xml!
    @device.save
    redirect_to @device
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_device
    @device = Device.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_params
    params.require(:device).permit(:mac_address, :site_id, :image_id, :xmlfile, :htmlfile, :notes)
  end
end
