require 'test_helper'

class HintTest < ActiveSupport::TestCase
  def setup
    @hint = Hint.find hints(:new_hint).id
  end

  test 'find' do
    assert_kind_of Hint, @hint
    assert_equal hints(:new_hint).header, @hint.header
    assert_equal hints(:new_hint).content, @hint.content
    assert_equal hints(:new_hint).importance, @hint.importance
    assert_equal hints(:new_hint).app_id, @hint.app_id
  end

  test 'create' do
    assert_difference 'Hint.count' do
      @hint = Hint.create(
        header: 'Update a hint in Torch',
        content: 'To update a *hint* in _Torch_ you must...',
        importance: 1,
        app: apps(:torch)
      )
    end
  end

  test 'update' do
    assert_no_difference 'Hint.count' do
      assert @hint.update_attributes(header: 'Updated name')
    end

    assert_equal 'Updated name', @hint.reload.header
  end

  test 'destroy' do
    assert_difference('Hint.count', -1) { @hint.destroy }
  end

  test 'validates blank attributes' do
    @hint.header = '  '
    @hint.content = '  '
    @hint.importance = nil
    @hint.app_id = nil
    assert @hint.invalid?
    assert_equal 4, @hint.errors.count
    assert_equal [error_message_from_model(@hint, :header, :blank)],
      @hint.errors[:header]
    assert_equal [error_message_from_model(@hint, :content, :blank)],
      @hint.errors[:content]
    assert_equal [error_message_from_model(@hint, :importance, :blank)],
      @hint.errors[:importance]
    assert_equal [error_message_from_model(@hint, :app, :blank)],
      @hint.errors[:app]
  end

  test 'validates duplicated attributes' do
    @hint.header = hints(:new_slide).header
    @hint.app = hints(:new_slide).app
    assert @hint.invalid?
    assert_equal 1, @hint.errors.count
    assert_equal [error_message_from_model(@hint, :header, :taken)],
      @hint.errors[:header]
  end

  test 'validates length of attributes' do
    @hint.header = 'abcde' * 52
    assert @hint.invalid?
    assert_equal 1, @hint.errors.count
    assert_equal [
      error_message_from_model(@hint, :header, :too_long, count: 255)
    ], @hint.errors[:header]
  end
  
  test 'validates format of attributes' do
    @hint.importance = 'x'
    assert @hint.invalid?
    assert_equal 1, @hint.errors.count
    assert_equal [
      error_message_from_model(@hint, :importance, :not_a_number)
    ], @hint.errors[:importance]
    
    @hint.importance = '1.2'
    assert @hint.invalid?
    assert_equal 1, @hint.errors.count
    assert_equal [
      error_message_from_model(@hint, :importance, :not_an_integer)
    ], @hint.errors[:importance]
  end
  
  test 'validates attributes boundaries' do
    @hint.importance = '0'
    assert @hint.invalid?
    assert_equal 1, @hint.errors.count
    assert_equal [
      error_message_from_model(@hint, :importance, :greater_than, count: 0)
    ], @hint.errors[:importance]
  end
end