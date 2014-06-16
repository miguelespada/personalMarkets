module CategoryHelper
  def formatted_button(category)
    "<button type='button' 
        class='theme btn btn-sm category-theme-button' 
        style='background-color:#{category.color}' 
        tile='#{category.style}'
        title='#{category.name}'>
        <i class='fa #{category.glyph}'>
        #{category.name}</i>
    </button> ".html_safe
  end
  
  def all_categories_button
      "<button type='button' 
          class='theme btn btn-sm btn-all-categories' 
          style='background-color:#FFFFFF' 
          tile='jameshedaweng.hf5b366j' 
          title='All categories'>
          <i class='fa fa-bars'>
          All categories</i>
      </button> ".html_safe  
  end
end

