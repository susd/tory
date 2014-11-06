require 'test_helper'

describe Admin::SitesController do
  
  before do
    @site = sites(:one)
    @user = users(:one)
    sign_in @user
  end
  
  it 'should update site' do
    patch :update, id: @site, site: {abbr: 'CC', pxe: '10.10.1.4', code: 10}
    assert_redirected_to admin_sites_path
  end
  
end