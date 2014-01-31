class InventoryController < ApplicationController
  
  def index
    if params[:mac_address]
      @devices = Device.where(_mac_address: normalize_mac(params[:mac_address]))
    else
      @devices = []
    end
    respond_to do |format|
      format.json { render json: @devices }
    end
  end
  
  def create
    @device = Device.where(_mac_address: normalize_mac(inventory_params[:mac_address])).first_or_initialize
    @device.site = Site.find_by(code: site_code_from_ip(inventory_params[:device][:ip_addr]))
    respond_to do |format|
      if @device.update(inventory_params[:device])
        format.json { render json: 'JSON success' }
        format.xml { render text: "Success\n" }
      else
        format.json { render json: @device.errors, status: :unprocessable_entity }
        format.xml { render xml: @devise.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def inventory_params
    params.permit(:mac_address, :format, device: [:xmlfile, :htmlfile, :ip_addr])
  end
  
  def normalize_mac(str)
    str.gsub(/\:/,'').downcase.chomp
  end
  
  def site_code_from_ip(ip_addr)
    unless ip_addr.nil?
      code = ip_addr.split('.')[1].to_i
    end
  end
end