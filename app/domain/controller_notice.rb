class ControllerNotice
  def self.success action, object
    s = I18n.t(:your_singular).capitalize  + " " + I18n.t(object.to_s).downcase + " " + I18n.t(:was) + " " + I18n.t(action.to_s) + " " + I18n.t(:successfully)
    s.strip
  end

  def self.fail action, object
    s = I18n.t(:your_singular).capitalize + " " + I18n.t(object.to_s).downcase + " " + I18n.t(:fail) + " " + I18n.t(action.to_s)
    s.strip
  end
end