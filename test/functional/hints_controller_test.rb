require 'test_helper'

class HintsControllerTest < ActionController::TestCase
  setup do
    @hint = hints(:new_hint)
    @app = apps(:torch)
  end

  test 'should get index' do
    get :index, app_id: @app.to_param
    assert_response :success
    assert_not_nil assigns(:hints)
    assert assigns(:hints).all? { |h| h.app_id == @app.id }
    assert_select '#unexpected_error', false
    assert_template 'hints/index'
  end

  test 'should get new' do
    get :new, app_id: @app.to_param
    assert_response :success
    assert_not_nil assigns(:hint)
    assert_select '#unexpected_error', false
    assert_template 'hints/new'
  end

  test 'should create hint' do
    assert_difference('@app.hints.count') do
      post :create, app_id: @app.to_param, hint: {
        header: 'Update a hint in Torch',
        content: 'To update a *hint* in _Torch_ you must...',
        importance: 1
      }
    end

    assert_redirected_to app_hint_url(@app, assigns(:hint))
  end

  test 'should show hint' do
    get :show, app_id: @app.to_param, id: @hint.to_param
    assert_response :success
    assert_not_nil assigns(:hint)
    assert_select '#unexpected_error', false
    assert_template 'hints/show'
  end

  test 'should get edit' do
    get :edit, app_id: @app.to_param, id: @hint.to_param
    assert_response :success
    assert_not_nil assigns(:hint)
    assert_select '#unexpected_error', false
    assert_template 'hints/edit'
  end

  test 'should update hint' do
    put :update, app_id: @app.to_param, id: @hint.to_param, hint: {
      header: 'Create a new hint in Torch (updated)',
      content: 'To create a new *hint* in _Torch_ you must... (updated)',
      importance: 2
    }
    
    assert_redirected_to app_hint_url(@app, assigns(:hint))
    assert_equal 'Create a new hint in Torch (updated)', @hint.reload.header
  end

  test 'should destroy hint' do
    assert_difference('@app.hints.count', -1) do
      delete :destroy, app_id: @app.to_param, id: @hint.to_param
    end

    assert_redirected_to app_hints_url(@app)
  end
end