module CategoryHelper
  def formatted_button(category)
  "<button type='button' class='theme btn btn-sm' style='background-color:#{category.color}' id='#{category.style}'  
      title='#{category.name}'>
      <i class='fa #{category.glyph}'></i>
  </button>".html_safe
  end
end
