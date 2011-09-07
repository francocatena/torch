require 'test_helper'

# Clase para probar el modelo "Comment"
class CommentTest < ActiveSupport::TestCase
  fixtures :comments

  # Función para inicializar las variables utilizadas en las pruebas
  def setup
    @comment = Comment.find(comments(:is_ok).id)
  end

  # Prueba que se realicen las búsquedas como se espera
  test 'find' do
    assert_kind_of Comment, @comment
    assert_equal comments(:is_ok).comment, @comment.comment
    assert_equal comments(:is_ok).user_id, @comment.user_id
    assert_equal comments(:is_ok).hint_id, @comment.hint_id
  end

  # Prueba la creación de un comentario sin notificaciones
  test 'create without notification' do
    PaperTrail.whodunnit = users(:admin).id
    
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      assert_difference ['Comment.count', 'Version.count'] do
        @comment = Comment.create(
          comment: 'This need a tweak or two at least',
          hint: hints(:new_hint),
          user: users(:anakin),
          must_be_sent_by_email: '0'
        )
      end
    end
  end
  
  # Prueba la creación de un comentario con notificaciones
  test 'create with notification' do
    PaperTrail.whodunnit = users(:admin).id
    
    assert_difference 'ActionMailer::Base.deliveries.size' do
      assert_difference ['Comment.count', 'Version.count'] do
        @comment = Comment.create(
          comment: 'This need a tweak or two at least',
          hint: hints(:new_hint),
          user: users(:anakin),
          must_be_sent_by_email: '1'
        )
      end
    end
  end

  # Prueba de actualización de un comentario
  test 'update' do
    assert_no_difference 'Comment.count' do
      assert @comment.update_attributes(
        hint: hints(:new_slide),
        comment: 'It seems to me that this need a polish'
      ), @comment.errors.full_messages.join('; ')
    end
    
    assert_not_equal hints(:new_slide).id, @comment.reload.hint_id
    assert_not_equal 'It seems to me that this need a polish', @comment.comment
  end

  # Prueba de eliminación de comentarios
  test 'destroy' do
    assert_difference('Comment.count', -1) { @comment.destroy }
  end
  
  test 'validates blank attributes' do
    @comment.comment = '  '
    @comment.hint = nil
    assert @comment.invalid?
    assert_equal 2, @comment.errors.count
    assert_equal [error_message_from_model(@comment, :comment, :blank)],
      @comment.errors[:comment]
    assert_equal [error_message_from_model(@comment, :hint, :blank)],
      @comment.errors[:hint]
  end
  
  test 'emails' do
    assert_equal [@comment.user.email], @comment.emails
    
    @comment.user = nil
    
    assert_equal User.all_except(@comment.creator.id).map(&:email),
      @comment.emails
  end
end