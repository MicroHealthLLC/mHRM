require 'test_helper'

module Links
  class LinksControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @link = links_links(:one)
    end

    test "should get index" do
      get links_url
      assert_response :success
    end

    test "should get new" do
      get new_link_url
      assert_response :success
    end

    test "should create link" do
      assert_difference('Link.count') do
        post links_url, params: { link: { hostname: @link.hostname, title: @link.title, url: @link.url, user_id: @link.user_id } }
      end

      assert_redirected_to link_url(Link.last)
    end

    test "should show link" do
      get link_url(@link)
      assert_response :success
    end

    test "should get edit" do
      get edit_link_url(@link)
      assert_response :success
    end

    test "should update link" do
      patch link_url(@link), params: { link: { hostname: @link.hostname, title: @link.title, url: @link.url, user_id: @link.user_id } }
      assert_redirected_to link_url(@link)
    end

    test "should destroy link" do
      assert_difference('Link.count', -1) do
        delete link_url(@link)
      end

      assert_redirected_to links_url
    end
  end
end