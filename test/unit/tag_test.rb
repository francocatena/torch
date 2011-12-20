require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @tag = Tag.find tags(:hints).id
  end

  test 'find' do
    assert_kind_of Tag, @tag
    assert_equal tags(:hints).name, @tag.name
    assert_equal tags(:hints).app_id, @tag.app_id
  end

  test 'create' do
    assert_difference 'Tag.count' do
      @tag = Tag.create(
        name: 'Apps',
        app_id: apps(:torch).id
      )
    end
  end

  test 'update' do
    assert_no_difference 'Tag.count' do
      assert @tag.update_attributes(name: 'Updated name')
    end

    assert_equal 'Updated name', @tag.reload.name
  end

  test 'destroy' do
    assert_difference('Tag.count', -1) { @tag.destroy }
  end

  test 'validates blank attributes' do
    @tag.name = '  '
    @tag.app = nil
    assert @tag.invalid?
    assert_equal 2, @tag.errors.count
    assert_equal [error_message_from_model(@tag, :name, :blank)],
      @tag.errors[:name]
    assert_equal [error_message_from_model(@tag, :app, :blank)],
      @tag.errors[:app]
  end

  test 'validates duplicated attributes' do
    @tag.name = tags(:slides).name
    @tag.app = tags(:slides).app
    assert @tag.invalid?
    assert_equal 1, @tag.errors.count
    assert_equal [error_message_from_model(@tag, :name, :taken)],
      @tag.errors[:name]
  end

  test 'validates length of attributes' do
    @tag.name = 'abcde' * 52
    assert @tag.invalid?
    assert_equal 1, @tag.errors.count
    assert_equal [
      error_message_from_model(@tag, :name, :too_long, count: 255)
    ], @tag.errors[:name]
  end
end