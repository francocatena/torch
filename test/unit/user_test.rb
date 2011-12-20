require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.find users(:admin).id
  end

  test 'find' do
    assert_kind_of User, @user
    assert_equal users(:admin).name, @user.name
    assert_equal users(:admin).lastname, @user.lastname
    assert_equal users(:admin).email, @user.email
    assert_equal users(:admin).enable, @user.enable
  end

  test 'create' do
    assert_difference 'User.count' do
      @user = User.create(
        name: 'Jar Jar',
        lastname: 'Binks',
        email: 'jjb@sw.com',
        password: 'jarjar123',
        password_confirmation: 'jarjar123',
        enable: true
      )
    end
  end

  test 'update' do
    assert_no_difference 'User.count' do
      assert @user.update_attributes(name: 'Updated name')
    end

    assert_equal 'Updated name', @user.reload.name
  end

  test 'destroy' do
    assert_difference('User.count', -1) { @user.destroy }
  end

  test 'validates blank attributes' do
    @user.name = '  '
    @user.lastname = '  '
    @user.email = '  '
    assert @user.invalid?
    assert_equal 3, @user.errors.count
    assert_equal [error_message_from_model(@user, :name, :blank)],
      @user.errors[:name]
    assert_equal [error_message_from_model(@user, :lastname, :blank)],
      @user.errors[:lastname]
    assert_equal [I18n.t('authlogic.error_messages.email_invalid')],
      @user.errors[:email]
  end
  
  test 'validates well formated attributes' do
    @user.email = 'incorrect@format'
    assert @user.invalid?
    assert_equal 1, @user.errors.count
    assert_equal [I18n.t('authlogic.error_messages.email_invalid')],
      @user.errors[:email]
  end

  test 'validates duplicated attributes' do
    @user.name = users(:anakin).name
    @user.lastname = users(:anakin).lastname
    @user.email = users(:anakin).email
    assert @user.invalid?
    assert_equal 2, @user.errors.count
    assert_equal [error_message_from_model(@user, :name, :taken)],
      @user.errors[:name]
    assert_equal [error_message_from_model(@user, :email, :taken)],
      @user.errors[:email]
  end

  test 'validates length of attributes' do
    @user.name = 'abcde' * 52
    @user.lastname = 'abcde' * 52
    assert @user.invalid?
    assert_equal 2, @user.errors.count
    assert_equal [
      error_message_from_model(@user, :name, :too_long, count: 255)
    ], @user.errors[:name]
    assert_equal [
      error_message_from_model(@user, :lastname, :too_long, count: 255)
    ], @user.errors[:lastname]
  end
end