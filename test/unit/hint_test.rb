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
      assert_difference 'Tag.count', 2 do
        @hint = Hint.create(
          header: 'Update a hint in Torch',
          content: 'To update a *hint* in _Torch_ you must...',
          importance: 1,
          tag_list: 'New tag, other new tag',
          app: apps(:torch)
        )
      end
    end
  end

  test 'update' do
    assert_no_difference ['Hint.count', '@hint.versions.count'] do
      assert @hint.update_attributes(header: 'Updated header')
    end
    
    assert_difference '@hint.versions.count' do
      assert @hint.update_attributes(content: 'Updated content')
    end

    assert_equal 'Updated header', @hint.reload.header
    assert_equal 'Updated content', @hint.reload.content
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
  
  test 'read tag list' do
    assert_equal 'Hints', @hint.tag_list
  end
  
  test 'write tag list' do
    assert_difference ['Tag.count', '@hint.tags.count'], 2 do
      assert @hint.update_attributes(tag_list: 'Hints, Multi word tag,NewTag, ')
    end
    
    assert_equal 'Hints,Multi word tag,NewTag', @hint.reload.tag_list
    
    assert_difference '@hint.tags.count', -2 do
      assert_no_difference 'Tag.count' do
        assert @hint.update_attributes(tag_list: 'NewTag, ')
      end
    end
    
    assert_equal 'NewTag', @hint.reload.tag_list
    
    assert_difference '@hint.tags.count', -1 do
      assert_no_difference 'Tag.count' do
        assert @hint.update_attributes(tag_list: '')
      end
    end
    
    assert_equal '', @hint.reload.tag_list
  end
end