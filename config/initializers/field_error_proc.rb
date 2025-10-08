# config/initializers/field_error_proc.rb

# Prevent Rails from wrapping form fields with errors in a <div class="field_with_errors">
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end
