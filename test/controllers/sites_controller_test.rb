require 'test_helper'

describe SitesController do
  
  before do
    @site = sites(:one)
  end
  
  it 'should update site' do
    patch :update, id: @site, site: {abbr: 'CC', pxe: '10.10.1.4', code: 10}
    assert_redirected_to sites_path
  end
  
end