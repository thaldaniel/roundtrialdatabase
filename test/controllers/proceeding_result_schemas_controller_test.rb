require 'test_helper'

class ProceedingResultSchemasControllerTest < ActionController::TestCase
  setup do
    @proceeding_result_schema = proceeding_result_schemas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proceeding_result_schemas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proceeding_result_schema" do
    assert_difference('ProceedingResultSchema.count') do
      post :create, proceeding_result_schema: { metadata_schema: @proceeding_result_schema.metadata_schema, proceeding_id: @proceeding_result_schema.proceeding_id, result_schema: @proceeding_result_schema.result_schema }
    end

    assert_redirected_to proceeding_result_schema_path(assigns(:proceeding_result_schema))
  end

  test "should show proceeding_result_schema" do
    get :show, id: @proceeding_result_schema
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @proceeding_result_schema
    assert_response :success
  end

  test "should update proceeding_result_schema" do
    patch :update, id: @proceeding_result_schema, proceeding_result_schema: { metadata_schema: @proceeding_result_schema.metadata_schema, proceeding_id: @proceeding_result_schema.proceeding_id, result_schema: @proceeding_result_schema.result_schema }
    assert_redirected_to proceeding_result_schema_path(assigns(:proceeding_result_schema))
  end

  test "should destroy proceeding_result_schema" do
    assert_difference('ProceedingResultSchema.count', -1) do
      delete :destroy, id: @proceeding_result_schema
    end

    assert_redirected_to proceeding_result_schemas_path
  end
end
