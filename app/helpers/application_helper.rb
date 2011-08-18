module ApplicationHelper
  # Return the error messages from a model in HTML format
  # 
  # * _model_:: The model to inspect for errors
  def show_error_messages(model)
    unless model.errors.empty?
      render 'shared/error_messages', model: model
    end
  end
  
  # Converts the text in textile into html using RedCloth
  #
  # * _text_:: The text in textile
  def textilize(text)
    textilized = RedCloth.new(text, [:hard_breaks])
    textilized.hard_breaks = true if textilized.respond_to?(:'hard_breaks=')
    
    raw textilized.to_html
  end
end