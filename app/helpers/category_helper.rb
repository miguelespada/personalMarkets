module CategoryHelper
  def icon(category)

    if !category.glyph_img.nil?
     "<i class='fa icon'>#{cl_image_tag(category.glyph_img.path, :width => 16, :height => 16, :crop => :fill, :class => "icon")}</i>"
    else
      "<i class='fa #{category.glyph}'></i>"
    end
  end
  def formatted_button(category)
    "<button type='button' 
        class='theme theme-styled btn btn-sm category-theme-button btn-category' 
        style='background-color:#{category.color}' 
        tile='#{category.style}'
        id='#{category.slug}'
        title='#{category.slug}'>
        #{icon(category)}
        <span>#{intl_name(category)}</span>
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

