require 'test_helper'

class TimeCardsControllerTest < ActionController::TestCase
  setup do
    @time_card = time_cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:time_cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create time_card" do
    assert_difference('TimeCard.count') do
      post :create, time_card: { date: @time_card.date, message: @time_card.message, time_started: @time_card.time_started, time_stopped: @time_card.time_stopped }
    end

    assert_redirected_to time_card_path(assigns(:time_card))
  end

  test "should show time_card" do
    get :show, id: @time_card
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @time_card
    assert_response :success
  end

  test "should update time_card" do
    patch :update, id: @time_card, time_card: { date: @time_card.date, message: @time_card.message, time_started: @time_card.time_started, time_stopped: @time_card.time_stopped }
    assert_redirected_to time_card_path(assigns(:time_card))
  end

  test "should destroy time_card" do
    assert_difference('TimeCard.count', -1) do
      delete :destroy, id: @time_card
    end

    assert_redirected_to time_cards_path
  end
end
