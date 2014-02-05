require 'test_helper'

class ProfitabilitiesControllerTest < ActionController::TestCase
  setup do
    @profitability = profitabilities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profitabilities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profitability" do
    assert_difference('Profitability.count') do
      post :create, profitability: { daily_cash_collection_amount: @profitability.daily_cash_collection_amount, gross_profit_margin: @profitability.gross_profit_margin, projected_daily_profit: @profitability.projected_daily_profit }
    end

    assert_redirected_to profitability_path(assigns(:profitability))
  end

  test "should show profitability" do
    get :show, id: @profitability
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profitability
    assert_response :success
  end

  test "should update profitability" do
    patch :update, id: @profitability, profitability: { daily_cash_collection_amount: @profitability.daily_cash_collection_amount, gross_profit_margin: @profitability.gross_profit_margin, projected_daily_profit: @profitability.projected_daily_profit }
    assert_redirected_to profitability_path(assigns(:profitability))
  end

  test "should destroy profitability" do
    assert_difference('Profitability.count', -1) do
      delete :destroy, id: @profitability
    end

    assert_redirected_to profitabilities_path
  end
end
