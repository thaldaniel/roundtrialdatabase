require 'test_helper'

class ParticipantProceedingResultsControllerTest < ActionController::TestCase
  setup do
    @participant_proceeding_result = participant_proceeding_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:participant_proceeding_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create participant_proceeding_result" do
    assert_difference('ParticipantProceedingResult.count') do
      post :create, participant_proceeding_result: { checked: @participant_proceeding_result.checked, participant_proceeding: @participant_proceeding_result.participant_proceeding, results: @participant_proceeding_result.results }
    end

    assert_redirected_to participant_proceeding_result_path(assigns(:participant_proceeding_result))
  end

  test "should show participant_proceeding_result" do
    get :show, id: @participant_proceeding_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @participant_proceeding_result
    assert_response :success
  end

  test "should update participant_proceeding_result" do
    patch :update, id: @participant_proceeding_result, participant_proceeding_result: { checked: @participant_proceeding_result.checked, participant_proceeding: @participant_proceeding_result.participant_proceeding, results: @participant_proceeding_result.results }
    assert_redirected_to participant_proceeding_result_path(assigns(:participant_proceeding_result))
  end

  test "should destroy participant_proceeding_result" do
    assert_difference('ParticipantProceedingResult.count', -1) do
      delete :destroy, id: @participant_proceeding_result
    end

    assert_redirected_to participant_proceeding_results_path
  end
end
