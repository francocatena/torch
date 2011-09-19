require 'test_helper'

class HintsControllerTest < ActionController::TestCase
  setup do
    @hint = hints(:new_hint)
    @app = apps(:torch)
  end

  test 'should get index' do
    UserSession.create(users(:admin))
    get :index, app_id: @app.to_param
    assert_response :success
    assert_not_nil assigns(:hints)
    assert assigns(:hints).size > 0
    assert assigns(:hints).all? { |h| h.app_id == @app.id }
    assert assigns(:hints).any?(&:private)
    assert_select '#unexpected_error', false
    assert_template 'hints/index'
  end
  
  test 'should get index without privates' do
    get :index, app_id: @app.to_param
    assert_response :success
    assert_not_nil assigns(:hints)
    assert assigns(:hints).size > 0
    assert assigns(:hints).all? { |h| h.app_id == @app.id }
    assert assigns(:hints).all? { |h| !h.private }
    assert_select '#unexpected_error', false
    assert_template 'hints/index'
  end
  
  test 'should get index filtered by tag' do
    tag = @app.tags.with_hints.first
    get :index, app_id: @app.to_param, tag_id: tag.to_param
    assert_response :success
    assert_not_nil assigns(:hints)
    assert assigns(:hints).size > 0
    assert assigns(:hints).all? { |h| h.app_id == @app.id && h.tags.include?(tag) }
    assert_select '#unexpected_error', false
    assert_template 'hints/index'
  end

  test 'should get new' do
    UserSession.create(users(:admin))
    get :new, app_id: @app.to_param
    assert_response :success
    assert_not_nil assigns(:hint)
    assert_select '#unexpected_error', false
    assert_template 'hints/new'
  end

  test 'should create hint' do
    UserSession.create(users(:admin))
    counts = [
      '@app.hints.count', 'Comment.count', 'ActionMailer::Base.deliveries.size'
    ]
    assert_difference counts do
      post :create, app_id: @app.to_param, hint: {
        header: 'Update a hint in Torch',
        content: 'To update a *hint* in _Torch_ you must...',
        importance: 1,
        comments_attributes: {
          new_1: {
            comment: 'This is the first comment in the hint =)',
            must_be_sent_by_email: '1'
          }
        }
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
    UserSession.create(users(:admin))
    get :edit, app_id: @app.to_param, id: @hint.to_param
    assert_response :success
    assert_not_nil assigns(:hint)
    assert_select '#unexpected_error', false
    assert_template 'hints/edit'
  end

  test 'should update hint' do
    UserSession.create(users(:admin))
    counts = ['@hint.comments.count', 'ActionMailer::Base.deliveries.size']
    assert_difference counts do
      put :update, app_id: @app.to_param, id: @hint.to_param, hint: {
        header: 'Create a new hint in Torch (updated)',
        content: 'To create a new *hint* in _Torch_ you must... (updated)',
        importance: 2,
        comments_attributes: {
          new_1: {
            comment: 'This is a new comment in an "old" hint =)',
            must_be_sent_by_email: '1'
          }
        }
      }
    end
    
    assert_redirected_to app_hint_url(@app, assigns(:hint))
    assert_equal 'Create a new hint in Torch (updated)', @hint.reload.header
  end

  test 'should destroy hint' do
    UserSession.create(users(:admin))
    assert_difference(['@app.hints.count', 'Comment.count'], -1) do
      delete :destroy, app_id: @app.to_param, id: @hint.to_param
    end

    assert_redirected_to app_hints_url(@app)
  end
  
  test 'should get history' do
    UserSession.create(users(:admin))
    get :history, app_id: @app.to_param, id: @hint.to_param
    assert_response :success
    assert_not_nil assigns(:hint)
    assert_not_nil assigns(:versions)
    assert !assigns(:versions).empty?
    assert_select '#unexpected_error', false
    assert_template 'hints/history'
  end
  
  test 'should get diff' do
    UserSession.create(users(:admin))
    get :diff, app_id: @app.to_param, id: @hint.to_param,
      version_id: @hint.versions.last.to_param
    assert_response :success
    assert_not_nil assigns(:hint)
    assert_not_nil assigns(:old_hint)
    assert_select '#unexpected_error', false
    assert_template 'hints/diff'
  end
end