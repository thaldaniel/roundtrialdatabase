require 'test_helper'

class ParticipantProceedingsControllerTest < ActionController::TestCase
  setup do
    @participant_proceeding = participant_proceedings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:participant_proceedings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create participant_proceeding" do
    assert_difference('ParticipantProceeding.count') do
      post :create, participant_proceeding: { device_id: @participant_proceeding.device_id, metadata: @participant_proceeding.metadata, participant_id: @participant_proceeding.participant_id, proceeding_id: @participant_proceeding.proceeding_id }
    end

    assert_redirected_to participant_proceeding_path(assigns(:participant_proceeding))
  end

  test "should show participant_proceeding" do
    get :show, id: @participant_proceeding
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @participant_proceeding
    assert_response :success
  end

  test "should update participant_proceeding" do
    patch :update, id: @participant_proceeding, participant_proceeding: { device_id: @participant_proceeding.device_id, metadata: @participant_proceeding.metadata, participant_id: @participant_proceeding.participant_id, proceeding_id: @participant_proceeding.proceeding_id }
    assert_redirected_to participant_proceeding_path(assigns(:participant_proceeding))
  end

  test "should destroy participant_proceeding" do
    assert_difference('ParticipantProceeding.count', -1) do
      delete :destroy, id: @participant_proceeding
    end

    assert_redirected_to participant_proceedings_path
  end
end
