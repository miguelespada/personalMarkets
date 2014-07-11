module CategoryHelper
  def formatted_button(category)
    "<button type='button' 
        class='theme theme-styled btn btn-sm category-theme-button btn-category' 
        style='background-color:#FFFFFF' 
        tile='#{category.style}'
        id='#{category.slug}'
        title='#{category.slug}'>
        <i class='fa #{category.glyph}'>
        </i> <span>#{intl_name(category)}</span>
    </button> ".html_safe
  end

  
  def all_categories_button
      "<button type='button' 
          class='theme btn btn-sm btn-all-categories btn-category' 
          style='background-color:#FFFFFF' 
          tile='' 
          title='All categories'>
          <i class='fa fa-bars'>
          </i> <span>#{t :all_categories}</span>
       </button> ".html_safe  
  end

  def intl_name (category)
    if params['language'] == 'es'
      category.name
    else
      category.english
    end
  end
end

