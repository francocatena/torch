require 'test_helper'

# Clase para probar el modelo "Feedback"
class FeedbackTest < ActiveSupport::TestCase
  fixtures :feedbacks

  # Función para inicializar las variables utilizadas en las pruebas
  def setup
    @feedback = Feedback.find(feedbacks(:needs_polishing).id)
  end

  # Prueba que se realicen las búsquedas como se espera
  test 'find' do
    assert_kind_of Feedback, @feedback
    assert_equal feedbacks(:needs_polishing).positive, @feedback.positive
    assert_equal feedbacks(:needs_polishing).comments, @feedback.comments
    assert_equal feedbacks(:needs_polishing).hint_id, @feedback.hint_id
  end

  # Prueba la creación de una retroalimentación
  test 'create' do
    assert_difference 'Feedback.positive.count' do
      @feedback = Feedback.create(
        positive: true,
        hint_id: hints(:new_hint).id
      )
    end
  end

  # Prueba de actualización de una retroalimentación
  test 'update' do
    assert_no_difference 'Feedback.count' do
      assert @feedback.update_attributes(
        hint_id: hints(:new_slide),
        comments: 'It seems to me that needs polishing'
      ), @feedback.errors.full_messages.join('; ')
    end
    
    assert_not_equal hints(:new_slide).id, @feedback.reload.hint_id
    assert_equal 'It seems to me that needs polishing', @feedback.comments
  end

  # Prueba de eliminación de retroalimentaciones
  test 'should not destroy' do
    # no se puede eliminar nunca una =)
    assert_no_difference('Feedback.count') { @feedback.destroy }
  end
end