require 'test_helper'

class AppTest < ActiveSupport::TestCase
  fixtures :apps

  def setup
    @app = App.find apps(:torch).id
  end

  test 'find' do
    assert_kind_of App, @app
    assert_equal apps(:torch).name, @app.name
    assert_equal apps(:torch).url, @app.url
    assert_equal apps(:torch).description, @app.description
  end

  test 'create' do
    assert_difference 'App.count' do
      @app = App.create(
        name: 'Rocket control',
        url: 'http://rocketcontrol.com',
        description: 'Super application to control rocket launchs'
      )
    end
  end

  test 'update' do
    assert_no_difference 'App.count' do
      assert @app.update_attributes(name: 'Updated name')
    end

    assert_equal 'Updated name', @app.reload.name
  end

  test 'destroy' do
    assert_difference('App.count', -1) { @app.destroy }
  end

  test 'validates blank attributes' do
    @app.name = '  '
    @app.url = '  '
    @app.description = '  '
    assert @app.invalid?
    assert_equal 3, @app.errors.count
    assert_equal [error_message_from_model(@app, :name, :blank)],
      @app.errors[:name]
    assert_equal [error_message_from_model(@app, :url, :blank)],
      @app.errors[:url]
    assert_equal [error_message_from_model(@app, :description, :blank)],
      @app.errors[:description]
  end

  test 'validates duplicated attributes' do
    @app.name = apps(:ignite).name
    assert @app.invalid?
    assert_equal 1, @app.errors.count
    assert_equal [error_message_from_model(@app, :name, :taken)],
      @app.errors[:name]
  end

  test 'validates length of attributes' do
    @app.name = 'abcde' * 52
    @app.url = 'abcde' * 52
    assert @app.invalid?
    assert_equal 2, @app.errors.count
    assert_equal [
      error_message_from_model(@app, :name, :too_long, count: 255)
    ], @app.errors[:name]
    assert_equal [
      error_message_from_model(@app, :url, :too_long, count: 255)
    ], @app.errors[:url]
  end
end