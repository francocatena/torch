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
  
  def sortable(column, title = nil)
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    
    link_to(
      title || column.titleize,
      request.query_parameters.merge(sort: column, direction: direction),
      {:class => css_class}
    )
  end
end