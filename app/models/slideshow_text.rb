class SlideshowText
  include Mongoid::Document
  field :title, type: String
  field :title_en, type: String
  field :subtitle, type: String
  field :subtitle_en, type: String

  def intl_title(language)
    return title_en if language == 'en'
    title
  end

  def intl_subtitle(language)
    return subtitle_en if language == 'en'
    subtitle
  end

  def self.title_list(language)
    all.collect{|t| t.intl_title(language)}.join(";")
  end
  def self.subtitle_list(language)
    all.collect{|t| t.intl_subtitle(language)}.join(";")
  end

  def self.icon
    "fa-quote-right"
  end
end