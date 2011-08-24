require 'test_helper'

class AppsControllerTest < ActionController::TestCase
  setup do
    @app = apps(:torch)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:apps)
    assert_select '#unexpected_error', false
    assert_template 'apps/index'
  end

  test 'should get new' do
    UserSession.create(users(:admin))
    get :new
    assert_response :success
    assert_not_nil assigns(:app)
    assert_select '#unexpected_error', false
    assert_template 'apps/new'
  end

  test 'should create app' do
    UserSession.create(users(:admin))
    assert_difference('App.count') do
      post :create, app: {
        name: 'Rocket control',
        url: 'http://rocketcontrol.com',
        description: 'Super application to control rocket launchs'
      }
    end

    assert_redirected_to app_url(assigns(:app))
  end

  test 'should show app' do
    get :show, id: @app.to_param
    assert_response :success
    assert_not_nil assigns(:app)
    assert_select '#unexpected_error', false
    assert_template 'apps/show'
  end

  test 'should get edit' do
    UserSession.create(users(:admin))
    get :edit, id: @app.to_param
    assert_response :success
    assert_not_nil assigns(:app)
    assert_select '#unexpected_error', false
    assert_template 'apps/edit'
  end

  test 'should update app' do
    UserSession.create(users(:admin))
    put :update, id: @app.to_param, app: {
      name: 'Torch',
      url: 'http://torch.com',
      description: 'Torchiness will give you using it =)'
    }
    
    assert_redirected_to app_path(assigns(:app))
    assert_equal 'Torchiness will give you using it =)', @app.reload.description
  end

  test 'should destroy app' do
    UserSession.create(users(:admin))
    assert_difference('App.count', -1) do
      delete :destroy, id: @app.to_param
    end

    assert_redirected_to apps_path
  end
end