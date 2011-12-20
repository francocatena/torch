require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  setup do
    @user = users(:admin)
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:user_session)
    assert_select '#error_body', false
    assert_template 'user_sessions/new'
  end

  test 'should create user session' do
    post :create, user_session: {
      email: @user.email,
      password: 'admin123'
    }

    assert user_session = UserSession.find
    assert_equal @user, user_session.user
    assert_redirected_to apps_url
  end
  
  test 'should not create a user session' do
    post :create, user_session: {
      email: @user.email,
      password: 'wrong'
    }

    assert_nil UserSession.find
    assert_response :success
    assert_not_nil assigns(:user_session)
    assert_select '#error_body', false
    assert_template 'user_sessions/new'
  end
  
  test 'should not create a user session with a disabled user' do
    user = users(:disabled_user)
    
    post :create, user_session: {
      email: user.email,
      password: 'disabled_user123'
    }

    assert_nil UserSession.find
    assert_response :success
    assert_not_nil assigns(:user_session)
    assert_select '#error_body', false
    assert_template 'user_sessions/new'
  end

  test 'should destroy user session' do
    UserSession.create(@user)

    assert_not_nil UserSession.find
    
    delete :destroy

    assert_nil UserSession.find
    assert_redirected_to admin_url
  end
end