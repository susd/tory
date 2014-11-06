require 'test_helper'

class Admin::ServersControllerTest < ActionController::TestCase
  setup do
    @site = sites(:one)
    @server = servers(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index, site_id: @site.id
    assert_response :success
    assert_not_nil assigns(:servers)
  end

  test "should get new" do
    get :new, site_id: @site.id
    assert_response :success
  end

  test "should create server" do
    assert_difference('Server.count') do
      post :create, server: { ip_addr: @server.ip_addr, role: @server.role, site_id: @server.site_id }, site_id: @site.id
    end

    assert_redirected_to admin_site_path(@site)
  end

  test "should get edit" do
    get :edit, id: @server, site_id: @site.id
    assert_response :success
  end

  test "should update server" do
    patch :update, server: { ip_addr: @server.ip_addr, role: @server.role, site_id: @server.site_id }, site_id: @site.id, id: @server.id
    assert_redirected_to admin_site_path(@site)
  end

  test "should destroy server" do
    assert_difference('Server.count', -1) do
      delete :destroy, id: @server, site_id: @site.id
    end

    assert_redirected_to admin_site_path
  end
end
