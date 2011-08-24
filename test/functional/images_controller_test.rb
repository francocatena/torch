require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  setup do
    @image = images(:login)
  end

  test 'should get index' do
    UserSession.create(users(:admin))
    get :index
    assert_response :success
    assert_not_nil assigns(:images)
    assert_select '#unexpected_error', false
    assert_template 'images/index'
  end

  test 'should get new' do
    UserSession.create(users(:admin))
    get :new
    assert_response :success
    assert_not_nil assigns(:image)
    assert_select '#unexpected_error', false
    assert_template 'images/new'
  end

  test 'should create image' do
    UserSession.create(users(:admin))
    assert_difference('Image.count') do
      post :create, image: {
        name: 'Help screenshot',
        caption: 'Help screen',
        image: fixture_file_upload('/files/test.gif', 'image/gif')
      }
    end

    assert_redirected_to image_path(assigns(:image))
  end

  test 'should show image' do
    UserSession.create(users(:admin))
    get :show, id: @image.to_param
    assert_response :success
    assert_not_nil assigns(:image)
    assert_select '#unexpected_error', false
    assert_template 'images/show'
  end

  test 'should get edit' do
    UserSession.create(users(:admin))
    get :edit, id: @image.to_param
    assert_response :success
    assert_not_nil assigns(:image)
    assert_select '#unexpected_error', false
    assert_template 'images/edit'
  end

  test 'should update image' do
    UserSession.create(users(:admin))
    put :update, id: @image.to_param, image: {
      name: 'Updated screenshot',
      caption: 'Updated screen',
      image: fixture_file_upload('/files/test.gif', 'image/gif')
    }
    
    assert_redirected_to image_path(assigns(:image))
    assert_equal 'Updated screenshot', @image.reload.name
  end

  test 'should destroy image' do
    UserSession.create(users(:admin))
    assert_difference('Image.count', -1) do
      delete :destroy, id: @image.to_param
    end

    assert_redirected_to images_path
  end
end