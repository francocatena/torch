require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:admin)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert_select '#unexpected_error', false
    assert_template 'users/index'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
    assert_select '#unexpected_error', false
    assert_template 'users/new'
  end

  test 'should create user' do
    assert_difference('User.count') do
      post :create, user: {
        name: 'Jar Jar',
        lastname: 'Binks',
        email: 'jjb@sw.com',
        password: 'jarjar123',
        password_confirmation: 'jarjar123'
      }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test 'should show user' do
    get :show, id: @user.to_param
    assert_response :success
    assert_not_nil assigns(:user)
    assert_select '#unexpected_error', false
    assert_template 'users/show'
  end

  test 'should get edit' do
    get :edit, id: @user.to_param
    assert_response :success
    assert_not_nil assigns(:user)
    assert_select '#unexpected_error', false
    assert_template 'users/edit'
  end

  test 'should update user' do
    put :update, id: @user.to_param, user: {
      name: 'Darth',
      lastname: 'Sidious',
      email: 'ds@sw.com'
    }
    
    assert_redirected_to user_path(assigns(:user))
    assert_equal 'ds@sw.com', @user.reload.email
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.to_param
    end

    assert_redirected_to users_path
  end
end