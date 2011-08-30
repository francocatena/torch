require 'test_helper'

class FeedbacksControllerTest < ActionController::TestCase
  def setup
    @hint = hints(:new_hint)
  end
  
  test 'should create positive feedback' do
    assert_difference 'Feedback.positive.count' do
      post :create, hint_id: @hint.to_param, score: 'positive'
    end

    assert_response :success
    assert_select '#error_body', false
    assert_template 'feedbacks/positive'
  end
  
  test 'should create negative feedback' do
    assert_difference 'Feedback.negative.count' do
      post :create, hint_id: @hint.to_param, score: 'negative'
    end

    assert_response :success
    assert_select '#error_body', false
    assert_template 'feedbacks/negative'
  end

  test 'should update feedback' do
    feedback = feedbacks(:needs_polishing)
    wrong_hint = hints(:new_slide)
    
    xhr :put, :update, hint_id: @hint.to_param, id: feedback.to_param, feedback: {
      hint_id: wrong_hint,
      comments: 'It seems to me that needs polishing'
    }
    
    assert_response :success
    assert_select '#error_body', false
    assert_template 'feedbacks/negative_comment'
    assert_equal 'It seems to me that needs polishing', feedback.reload.comments
    assert_not_equal wrong_hint.id, feedback.reload.hint_id
  end
end