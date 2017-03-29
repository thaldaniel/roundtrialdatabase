require 'test_helper'

class RoundtrialsControllerTest < ActionController::TestCase
  setup do
    @roundtrial = roundtrials(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:roundtrials)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create roundtrial" do
    assert_difference('Roundtrial.count') do
      post :create, roundtrial: { active: @roundtrial.active, name: @roundtrial.name }
    end

    assert_redirected_to roundtrial_path(assigns(:roundtrial))
  end

  test "should show roundtrial" do
    get :show, id: @roundtrial
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @roundtrial
    assert_response :success
  end

  test "should update roundtrial" do
    patch :update, id: @roundtrial, roundtrial: { active: @roundtrial.active, name: @roundtrial.name }
    assert_redirected_to roundtrial_path(assigns(:roundtrial))
  end

  test "should destroy roundtrial" do
    assert_difference('Roundtrial.count', -1) do
      delete :destroy, id: @roundtrial
    end

    assert_redirected_to roundtrials_path
  end
end
