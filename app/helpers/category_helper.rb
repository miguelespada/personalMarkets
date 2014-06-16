module CategoryHelper
  def formatted_button(category)
    "<button type='button' 
        class='theme theme-styled btn btn-sm category-theme-button' 
        style='background-color:#{category.color}' 
        tile='#{category.style}'
        id='#{category.name}'
        title='#{category.name}'>
        <i class='fa #{category.glyph}'>
        </i> #{category.name}
    </button> ".html_safe
  end
  
  def all_categories_button
      "<button type='button' 
          class='theme btn btn-sm btn-all-categories' 
          style='background-color:#FFFFFF' 
          tile='' 
          title='All categories'>
          <i class='fa fa-bars'>
          </i> All categories
      </button> ".html_safe  
  end
end

